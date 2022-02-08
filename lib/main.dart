import 'package:flutter/material.dart';
import 'package:progetto_sdc_scan_app/QRScanScreen.dart';
import 'package:progetto_sdc_scan_app/FormPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progetto SDC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: "/home",
      routes: <String, WidgetBuilder>{
        "/home": (context) => const MyHomePage(title: "Progetto SDC"),
        "/qr_scan":(context) => const QRScannScreen(title: "Scan QR Code"),
        "/form":(context) => const FormPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Progetto SDC - A.A. 21/22", style: TextStyle(fontSize: 24, fontFamily: "Times")),
            Divider(),
            Text("Alessandro Straziota 0316930", style: TextStyle(fontSize: 24, fontFamily: "Times")),
            Text("Michele Cirillo 0315204", style: TextStyle(fontSize: 24, fontFamily: "Times")),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/qr_scan"),
        //onPressed: () => Navigator.pushNamed(context, "/form"),
        tooltip: 'Scan',
        child: const Icon(Icons.qr_code_scanner),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
