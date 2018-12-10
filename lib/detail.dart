import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ago/ago.dart';
import './model/TopicDetailModel.dart';
import './model/TopicReplyModel.dart';

class Detail extends StatefulWidget {
    Detail({
        this.id
    });

    final String id;

    @override
    _DetailState createState() => new _DetailState();
}

class _DetailState extends State < Detail > {
    bool isReady = false;
    Map _topicData;
    List _repliesData;

    Future <void> _fetchTopicData(String id) async {
        var url = "https://www.v2ex.com/api/topics/show.json?id=${id}";
        print("topic data url: " + url);
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

    Future <void> _fetchTopicReplyData(String id) async {
        var url = "https://www.v2ex.com/api/replies/show.json?topic_id=${id}";
        print("reply list url:" + url);
        var httpClient = new HttpClient();
        List data = [];
        try {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();

            if (response.statusCode == HttpStatus.ok) {
                var resultStr = await response.transform(utf8.decoder).join();
                data = json.decode(resultStr);
                setState(() {
                    _repliesData = data;
                });
            }
        } catch (e) {
            print(e);
        }
    }


    Widget _buildProgressIndicator() {
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
            );
        } else {
            List<Widget> widgetList = [];
            var model = new TopicDetailModel.fromJson(_topicData);

            Widget titleSection = new Container(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
                decoration: new BoxDecoration(
                    border: new Border(bottom:BorderSide(color: Theme.of(context).dividerColor)),
                ),
                child: new Text(
                    _topicData != null ? model.title : '加载中',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                    ),
                ),
            );

            widgetList.add(titleSection);

            if (_topicData['content_rendered'] != "") {
                Widget contentSection = new Container(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    decoration: new BoxDecoration(
                        border: new Border(bottom:BorderSide(color: Theme.of(context).dividerColor)),
                    ),
                    child: _topicData != null ? new HtmlView(data: model.contentRendered) : new Text('无'),
                );

                widgetList.add(contentSection);
            }

            var rows = _buildReplyRows();
            widgetList.addAll(rows);

            return new ListView(
                children: widgetList,
            );
        }
    }

    List <Widget> _buildReplyRows() {
        List <Widget> rows = [];

        if (_repliesData == null) {
            return [];
        }

        _repliesData.forEach((el) {
            var model = new TopicReplyModel.fromJson(el);
            var floor = _repliesData.indexOf(el);
            var date = new DateTime.fromMillisecondsSinceEpoch(model.created * 1000);
            // var format = new DateFormat('y-MM-dd HH:mm');
            // var formatDate = format.format(date);
            var formatDate = ago(date, new DateTime.now());

            var row = new Container(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: new BoxDecoration(
                    border: new Border(bottom:BorderSide(color: Theme.of(context).dividerColor)),
                ),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        new Row(
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
                                                                model.member.username,
                                                                maxLines: null,
                                                                // style: new TextStyle(
                                                                //     fontWeight: FontWeight.bold,
                                                                // ),
                                                            ),
                                                    ),
                                                    new Text("${floor + 1}楼 回复时间: ${formatDate}"),
                                                ],
                                            )
                                    ),
                                ),
                            ],
                        ),
                        new Container(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                            child: new Text(
                                model.content,
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            // child: new HtmlView(data: "<p>" + el['content_rendered'] + "</p>"),
                        )
                    ]
                )
            );

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
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(isReady ? _topicData['title'] : '加载中'),
            ),
            body: _buildUpDetailView(),
        );
    }
}
