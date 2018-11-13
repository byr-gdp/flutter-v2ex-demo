import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import './model/TopicListItemModel.dart';
import './detail.dart';
import './about.dart';

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'V2EX Demo',
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
                // counter didn't reset back to zero; the application is not restarted.
                primarySwatch: Colors.grey,
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
    // 列表数据
    List _listData = [];

    // 当前 tab 下标。0 最热 1 最新。
    int _currentIndex = 0;

    ScrollController _scrollController = new ScrollController();
    bool isLoading = false;

    /**
     * 根据当前 tab 获取列表数据
     * 0: 最热，1: 最新
     */
    _fetchListData(int index) async {
        // 异步获取列表数据
        var hotApiUrl = 'https://www.v2ex.com/api/topics/hot.json';
        var latestApiUrl = 'https://www.v2ex.com/api/topics/latest.json';
        var url = index == 1 ? hotApiUrl : latestApiUrl;
        var httpClient = new HttpClient();
        List < dynamic > data = [];

        if (isLoading) {
            return;
        }

        setState(() => isLoading = true);
        try {
            var request = await httpClient.getUrl(Uri.parse(url));
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
        setState(() => isLoading = false);
    }

    Widget _buildBodyView() {
        if (isLoading) {
            return _buildProgressIndicator();
        } else {
            return ListView.builder(
                itemCount: _listData.length,
                itemBuilder: (context, index) {
                    if (isLoading) {
                        return _buildProgressIndicator();
                    } else {
                        var el = _listData[index];
                        var model = new TopicListItemModel.fromJson(el);

                        return new GestureDetector(
                            onTap: () {
                                print("tap topic id " + model.id.toString());
                                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                    return new Detail(id: model.id.toString());
                                }));
                            },
                            child: new Container(
                                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                                child: new Row(
                                    children: [
                                        new Image.network('http:' + model.member.avatarNormal, width: 40.0, height: 40.0, fit: BoxFit.fill),
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
            );
        }
    }

    Widget _buildProgressIndicator() {
        return new Padding(
            padding: const EdgeInsets.all(8.0),
                child: new Center(
                    child: new Opacity(
                        opacity: isLoading ? 1.0 : 0.0,
                        child: new CircularProgressIndicator(),
                    ),
                ),
        );
    }

    Widget _buildDrawer() {
        return Drawer(
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: < Widget > [
                    UserAccountsDrawerHeader(
                        accountName: new Text("Unknown"),
                        accountEmail: new Text("Github: byr-gdp"),
                        currentAccountPicture: new CircleAvatar(
                            backgroundImage: new NetworkImage("https://sf3-ttcdn-tos.pstatp.com/obj/game-files/5a272a22bb78b3974bba7265262c12eb.png"),
                        ),
                    ),
                    ListTile(
                        title: Text('About'),
                        onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                return new About();
                            }));
                        },
                    ),
                ],
            ),
        );
    }

    @override
    void initState() {
        super.initState();
        // 监听 list 滑动到底部
        // _scrollController.addListener(() {
        //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        //         print("ready to load");
        //     }
        // });
        _fetchListData(_currentIndex);
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
            // appBar 配置参考文档：https://docs.flutter.io/flutter/material/AppBar-class.html
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                // 如果 leading 通过 Icon 设置，则 left drawer 不会有机会手动触发
                // 可以通过 IconButton 代替 Icon 从而通过 onPressed 手动打开 drawer
                // leading: Icon(Icons.sentiment_satisfied),
                // leading: new Builder(builder: (context) {
                //     return new IconButton(
                //         icon: Icon(Icons.menu),
                //         tooltip: 'Profile',
                //         onPressed: () {
                //             Scaffold.of(context).openDrawer();
                //         },
                //     );
                // }),
                // actions: <Widget>[
                //     // 手动通过 action 打开 drawer，参考：https://www.reddit.com/r/FlutterDev/comments/7yma7y/how_do_you_open_a_drawer_in_a_scaffold_using_code/
                //     // 直接拿 context 有问题，通过 Builder 包了一层。
                //     new Builder(builder: (context) {
                //         return IconButton(
                //             icon: Icon(Icons.search),
                //             tooltip: '分区',
                //             onPressed: () {
                //                 Scaffold.of(context).openEndDrawer();
                //             },
                //         );
                //     })
                // ],
            ),
            body: _buildBodyView(),
            drawer: _buildDrawer(),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (int index) {
                    if (isLoading || index == _currentIndex) {
                        return;
                    }
                    setState(() {
                        _currentIndex = index;
                        _fetchListData(index);
                    });
                },
                currentIndex: _currentIndex, // this will be set when a new tab is tapped
                items: [
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.home),
                        title: new Text('最新'),
                    ),
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.event_note),
                        title: new Text('最热'),
                    ),
                ],
            ),
        );
    }
}
