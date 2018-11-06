import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import './model/TopicListItemModel.dart';
import './detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'V2EX',
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
                // counter didn't reset back to zero; the application is not restarted.
                primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'V2EX'),
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({
        Key key,
        this.title
    }): super(key: key);

    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
    // how it looks.

    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State < MyHomePage > {
    // FIXME: 期望 items 最后有一项无效数据用于渲染 circularProgressIndeicator
    List < int > items = List.generate(11, (i) {
        if (i == 10) {
            return -1;
        } else {
            return i;
        }
    });
    List _listData = [];


    ScrollController _scrollController = new ScrollController();
    bool isLoading = false;

    Future < List < int >> fakeRequest(int from, int to) async {
        return Future.delayed(Duration(seconds: 2), () {
            return List.generate(to - from, (i) => i + from);
        });
    }

    _fetchListData() async {
        // 异步获取列表数据
        var hotApiUrl = 'https://www.v2ex.com/api/topics/hot.json';
        var httpClient = new HttpClient();
        List < dynamic > data = [];
        try {
            var request = await httpClient.getUrl(Uri.parse(hotApiUrl));
            var response = await request.close();

            if (response.statusCode == HttpStatus.ok) {
                var resultStr = await response.transform(utf8.decoder).join();
                data = json.decode(resultStr);
                print("fetch success");
                setState(() {
                    _listData = data;
                });
            }
        } catch (e) {
            print(e);
        }
    }

    void _loadMore() async {
        if (!isLoading) {
            // isLoading = true;
            setState(() => isLoading = true);
            List < int > newItems = await fakeRequest(items.length, items.length + 10);
            setState(() {
                // items.addAll(newItems);
                items.insertAll(items.length - 2, newItems);
                isLoading = false;
            });
        }
    }

    Widget _buildProgressIndicator() {
        print("build progress");
        return new Padding(
            padding: const EdgeInsets.all(8.0),
                child: new Center(
                    child: new Opacity(
                        opacity: isLoading ? 1.0 : 0.0,
                        // opacity: 0.8,
                        child: new CircularProgressIndicator(),
                    ),
                ),
        );
    }

    @override
    void initState() {
        super.initState();
        _scrollController.addListener(() {
            if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
                print("ready to load");
                _loadMore();
            }
        });
        _fetchListData();
    }

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called, for instance as done
        // by the _incrementCounter method above.
        //
        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
            ),
            // body: Center(
            //     // Center is a layout widget. It takes a single child and positions it
            //     // in the middle of the parent.
            //     child: Column(
            //         // Column is also layout widget. It takes a list of children and
            //         // arranges them vertically. By default, it sizes itself to fit its
            //         // children horizontally, and tries to be as tall as its parent.
            //         //
            //         // Invoke "debug paint" (press "p" in the console where you ran
            //         // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
            //         // window in IntelliJ) to see the wireframe for each widget.
            //         //
            //         // Column has various properties to control how it sizes itself and
            //         // how it positions its children. Here we use mainAxisAlignment to
            //         // center the children vertically; the main axis here is the vertical
            //         // axis because Columns are vertical (the cross axis would be
            //         // horizontal).
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: < Widget > [
            //             Text(
            //                 'You have pushed the button this many times:',
            //             ),
            //             Text(
            //                 '$_counter',
            //                 style: Theme.of(context).textTheme.display1,
            //             ),
            //         ],
            //     ),
            // ),
            body: ListView.builder(
                // itemCount: items.length,
                itemCount: _listData.length + 1,
                // itemBuilder: (context, index) {
                //     // 为了渲染加载条采用的 hack 方式
                //     if (items[index] == -1) {
                //         return _buildProgressIndicator();
                //     } else {
                //         return ListTile(title: new Text("Number $index"));
                //     }
                // },
                itemBuilder: (context, index) {
                    // if (items[index] == -1) {
                    if (_listData.length == index) {
                        return _buildProgressIndicator();
                    } else {
                        var el = _listData[index];
                        var model = new TopicListItemModel.fromJson(el);
                        // print(model.title);
                        return new GestureDetector(
                            // onTap: () {
                            //     print(index);
                            //     // Navigator
                            //     Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                            //         return new Detail(id: index.toString());
                            //         // return new SecondPage(title: index.toString());
                            //     }));
                            // },
                            // child: ListTile(title: new Text("Number $index")),
                            onTap: () {
                                print("tap topic id " + model.id.toString());
                                // print(el['id']);
                                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                    return new Detail(id: model.id.toString());
                                }));
                            },
                            child: new Container(
                                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                                    child: new Row(
                                        children: [
                                            new Image.network('http:' + el['member']['avatar_normal'], width: 40.0, height: 40.0, fit: BoxFit.fill),
                                            new Expanded(
                                                child: new Container(
                                                    margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                                        child: new Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                new Container(
                                                                    padding: const EdgeInsets.only(bottom: 2.0),
                                                                        child: new Text(
                                                                            el['title'],
                                                                            maxLines: 1,
                                                                            style: new TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                            ),
                                                                        ),
                                                                ),
                                                                new Text(
                                                                    '最后回复：' + el['last_reply_by'],
                                                                    style: new TextStyle(
                                                                        color: Colors.grey[500],
                                                                    ),
                                                                ),
                                                            ],
                                                        )
                                                ),
                                            ),
                                            new Text(el['replies'].toString()),
                                        ],
                                    ),
                            )
                        );
                    }
                },
                controller: _scrollController,
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
    }
}
