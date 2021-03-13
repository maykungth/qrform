import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:qrform/main.dart';
import 'package:qrform/diaglog.dart';
import 'package:http/http.dart' as http;
import 'package:qrform/settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homePageText = "Your GID : ";
  final textStyle = TextStyle(fontSize: 16);
  final urlGoogleForm =
      'https://docs.google.com/forms/d/e/xxxx/formResponse?';
  final locationEntity = 'entry.xxxx';
  final seatEntity = 'entry.xxxx';
  final gidEntity = 'entry.xxxx';
  final submit = 'submit=Submit';

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    var setting = Provider.of<Settings>(context,listen: false);
    await setting.loadSettings();

    if(!['','None','NotDefine'].contains(setting.gid)){
      WidgetsBinding.instance
        .addPostFrameCallback((_) => _onQrScanPressed());      
    }
  }

  void _onQrScanPressed() async {
    var gid = Provider.of<Settings>(context).gid;

    if(['','None','NotDefine'].contains(gid)){
      showAlertDialog(context, "Error", "Please setup your GID before scan");
      return;
    }

    var result = await BarcodeScanner.scan();
    if (result.rawContent.isNotEmpty) {
      List<String> params;
      if (result.rawContent.contains('tepc'))
        params = getParams(result.rawContent, false);
      else
        params = getParams(result.rawContent, true);

      var url = "$urlGoogleForm$locationEntity=${params[0]}&$seatEntity=${params[1]}&$gidEntity=$gid&$submit";

      try {
        await http.get(url);
        sendNotification(
            "Data Saved", "You $gid was ${params[0]} at ${params[1]}");
      } on Exception catch (ex) {
        showAlertDialog(context, "Error", ex.toString());
      }
    }
  }

  List<String> getParams(String uri, bool googleFormLink) {
    var loc = googleFormLink ? locationEntity : 'l';
    var seat = googleFormLink ? seatEntity : 's';

    return [
      Uri.dataFromString(uri).queryParameters[loc],
      Uri.dataFromString(uri).queryParameters[seat]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(homePageText, style: textStyle),
          Consumer<Settings>(builder: (context, setting, child) {
            return Text(setting.gid, style: textStyle);
          }),
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onQrScanPressed,
        icon: Icon(Icons.camera_alt),
        label: Text('QR Scan'),
      ),
    );
  }
}
