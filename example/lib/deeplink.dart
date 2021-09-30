import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Deeplink extends StatefulWidget {
  Map<String, dynamic>? deeplinkParams;
  Deeplink(this.deeplinkParams);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<Deeplink> {
  // called on every foreground
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text('Deeplink', textAlign: TextAlign.left)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'App did not open with a deep link',
                labelText: widget.deeplinkParams == null
                    ? ""
                    : widget.deeplinkParams!['deeplink']),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text('Passthrough', textAlign: TextAlign.left)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'App did not open with a deep link',
                labelText: widget.deeplinkParams == null
                    ? ""
                    : widget.deeplinkParams!['passthrough']),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text('Is Deferred', textAlign: TextAlign.left)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'App did not open with a deep link',
                labelText: widget.deeplinkParams == null
                    ? ""
                    : widget.deeplinkParams!['isDeferred']),
          ),
        ),
      ],
    ));
  }
}
