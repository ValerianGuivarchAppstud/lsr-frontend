import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatefulDialog extends StatefulWidget {
  @override
  _StatefulDialogState createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();


  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value != null ?(value.isNotEmpty? null : "Enter any text") : null;
                        },
                        decoration:
                        InputDecoration(hintText: "Please Enter Text"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choice Box"),
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked ?? false;
                                });
                              })
                        ],
                      )
                    ],
                  )),
              title: Text('Stateful Dialog'),
              actions: <Widget>[
                InkWell(
                  child: Text('OK   '),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(
              color: Colors.deepOrange,
              onPressed: () async {
                await showInformationDialog(context);
              },
              child: Text(
                "Stateful Dialog",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
      ),
    );
  }
}