import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrform/diaglog.dart';
import 'package:qrform/settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final textStyle = TextStyle(fontSize: 16);
  var gidTextController = new TextEditingController();

  void _saveGID() async {
    var gid = gidTextController.text;
    Provider.of<Settings>(context).saveGID(gid);

    showAlertDialog(context, "Save", "Your GID : $gid is saved");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    gidTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String gid = Provider.of<Settings>(context).gid;
    if (gid != 'None') gidTextController.text = gid;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('GID : ', style: textStyle),
                Expanded(
                    child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: gidTextController,
                  style: textStyle,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Please enter your GID',
                  ),
                )),
                RaisedButton(
                  onPressed: _saveGID,
                  color: Colors.blue,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
