import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class Detail extends StatefulWidget {
    Detail({
        this.id
    });

    final String id;

    @override
    _DetailState createState() => new _DetailState();
}

class _DetailState extends State < Detail > {
    String message = "";
    bool isReady = false;
    Map _topicData;
    List _repliesData;

    // 模拟异步请求
    Future < String > fakeRequest() async {
        return Future.delayed(Duration(seconds: 2), () {
            return message + " hi";
        });
    }

    Future < void > _fetchTopicData(String id) async {
        print("topic id is" + id);
        var url = "https://www.v2ex.com/api/topics/show.json?id=${id}";
        var httpClient = new HttpClient();
        List data = [];
        try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();

            if (response.statusCode == HttpStatus.ok) {
                var resultStr = await response.transform(utf8.decoder).join();
                data = json.decode(resultStr);
                setState(() {
                    _topicData = data[0];
                });
            }
        } catch (e) {
            print(e);
        }
    }

    Future < void > _fetchTopicReplyData(String id) async {
        print('in fetch reply data');
        var url = "https://www.v2ex.com/api/replies/show.json?topic_id=${id}";
        print(url);
        var httpClient = new HttpClient();
        List data = [];
        try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();

            if (response.statusCode == HttpStatus.ok) {
                var resultStr = await response.transform(utf8.decoder).join();
                data = json.decode(resultStr);
                print(data.length);
                print('fetch reply success');
                setState(() {
                    _repliesData = data;
                });
            }
        } catch (e) {
            print(e);
        }
    }


    void _loadMore() async {
        String msg = await fakeRequest();
        setState(() {
            message = msg;
        });
    }

    Widget _buildProgressIndicator() {
        print("build progress");
        return new Padding(
            padding: const EdgeInsets.all(8.0),
                child: new Center(
                    child: new Opacity(
                        opacity: !isReady ? 1.0 : 0.0,
                        child: new CircularProgressIndicator(),
                    ),
                ),
        );
    }

    Widget _buildUpDetailView() {
        if (!isReady) {
            return new GestureDetector(
                child: new Center(
                    child: _buildProgressIndicator(),
                ),
                onTap: () {
                    print("tap");
                    _loadMore();
                }
            );
        } else {
            Widget titleSection = new Container(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
                child: new Text(
                    _topicData != null ? _topicData['title'] : '加载中',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                    ),
                ),
            );

            // FIXME: 如何渲染 HTML
            Widget contentSection = new Container(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
                child: new Text(
                    _topicData != null ? _topicData['content'] : '无',
                    style: new TextStyle(
                        fontSize: 14.0,
                    ),
                ),
            );

            var rows = _buildReplyRows();
            List < Widget > widgetList = [titleSection, contentSection];
            rows.forEach((el) {
                widgetList.add(el);
            });
            print("rows " + rows.length.toString());

            return new ListView(
                children: widgetList,
            );
        }
    }

    List < Widget > _buildReplyRows() {
        List < Widget > rows = [];

        if (_repliesData == null) {
            print('build reply row with null');
            return [];
        }

        print('build reply row not null');

        var floorCount = 1;

        _repliesData.forEach((el) {
            var row = new GestureDetector(
                onTap: () {
                    print('tap');
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
                                                                el['content'],
                                                                maxLines: 1,
                                                                style: new TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                ),
                                                            ),
                                                    ),
                                                    // new Text(
                                                    //   '最后回复：' + el['last_reply_by'],
                                                    //   style: new TextStyle(
                                                    //     color: Colors.grey[500],
                                                    //   ),
                                                    // ),
                                                ],
                                            )
                                    ),
                                ),
                                new Text(floorCount.toString()),
                            ],
                        ),
                )
            );
            floorCount += 1;
            rows.add(row);
        });

        return rows;
    }


    @override
    void initState() {
        super.initState();
        _fetchTopicData(widget.id)
            .then((_) {
                _fetchTopicReplyData(widget.id).then((_) {
                    setState(() => isReady = true);
                });
            });
    }

    @override
    Widget build(BuildContext context) {
        print(message);
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(isReady ? _topicData['title'] : '加载中'),
            ),
            body: _buildUpDetailView(),
        );
    }
}
