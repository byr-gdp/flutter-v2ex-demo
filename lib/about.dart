import 'package:flutter/material.dart';

class About extends StatefulWidget {
    About();

    @override
    _DetailState createState() => new _DetailState();
}

class _DetailState extends State < About > {
    Widget buildAbout() {
        Widget titleSection = new Container(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
            // decoration: new BoxDecoration(
            //     border: new Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            // ),
            child: new Text(
                'About',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                ),
            ),
        );

        Widget contentSection = new Container(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
            // decoration: new BoxDecoration(
            //     border: new Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            // ),
            child: new Text(
                'A V2EX client powered by Flutter.',
                style: new TextStyle(
                    fontSize: 14.0,
                ),
            )
        );

        List < Widget > widgetList = [titleSection, contentSection];

        return new ListView(
            children: widgetList,
        );
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text('About'),
            ),
            body: buildAbout(),
        );
    }
}
