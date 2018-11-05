import 'package:flutter/material.dart';

class Detail extends StatefulWidget {

    Detail({
        this.id
    });

    final String id;

    @override
    _DetailState createState() => new _DetailState();
}

class _DetailState extends State < Detail > {
    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text('Detail'),
            ),
            body: new Center(
                child: new Text(
                    "ID: ${widget.id}",
                ),
            ),
        );
    }
}
