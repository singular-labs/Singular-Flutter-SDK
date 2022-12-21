import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';

class Skan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<Skan> {
  final fineValueTextController = TextEditingController(text:'32');
  final coarseValueTextController = TextEditingController(text:'1');

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
          child: TextField(
            controller: fineValueTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Fine Value',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: coarseValueTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Coarse Value',
            ),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Update Conversion Value',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              print('updating conversion vlue' + fineValueTextController.text);
              int? fineValue = int.tryParse(fineValueTextController.text);
              if (fineValue == null  || fineValue < 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid fine value"),
                    );
                  },
                );
                return;
              }


              Singular.skanUpdateConversionValue(fineValue);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Conversion value updated"),
                  );
                },
              );
            },
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Update Conversion Value (SKAN4)',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              print('updating conversion vlue: ' + fineValueTextController.text + ' coarse: ' + coarseValueTextController.text);
              int? fineValue = int.tryParse(fineValueTextController.text);
              int? coarseValue = int.tryParse(coarseValueTextController.text);
              if (fineValue == null  || fineValue < 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid fine value"),
                    );
                  },
                );
                return;
              }

              if (coarseValue == null  || coarseValue < 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid coarse value"),
                    );
                  },
                );
                return;
              }


              Singular.skanUpdateConversionValues(fineValue, coarseValue, false);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Conversion value updated"),
                  );
                },
              );
            },
          ),
        )
      ],
    ));
  }
}
