import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebSocketChannel? channel;
  String data = "";
  String currentData = "";
  double ph = 0.0;
  double tds = 0.0;
  double temp = 0.0;

  List<dynamic> dataHistory = []; // Hold history for visualization

  @override
  void initState() {
    super.initState();
    initWebSocket();
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  void initWebSocket() async {
    // Replace with your ESP8266 access point's IP address and port
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.100:81'));
      channel?.stream.listen((message) {
        setState(() {
          data = message;

          Map<String, dynamic> currentData = jsonDecode(data);
          ph = currentData['ph'];
          tds = currentData['tds'];
          temp = currentData['temp'];
          dataHistory.add(currentData); // Ensure data format aligns with JSON
        });
      });
    } catch (e) {
      print(e); // Handle connection errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('I-droponics'),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 200,
                  width: 100,
                  child: Column(children: [
                    Text("ph level: $ph"),
                    const Divider(),
                    Text("tds value: $tds"),
                    const Divider(),
                    Text("temperature: $temp"),
                    const Divider(),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
