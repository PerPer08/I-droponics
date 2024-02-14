import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200  ,
                  child: Image.asset('assets/Logo.png', ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff085078),
                                      Color(0xff85d8ce)
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  )),
                              width: 150,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("pH",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text(
                                        "$ph",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ))),
                      Card(
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff085078),
                                      Color(0xff85d8ce)
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  )),
                              width: 150,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("TDS",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text(
                                        "$tds",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ))),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff085078),
                                      Color(0xff85d8ce)
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  )),
                              width: 150,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Temperature",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text(
                                        "$temp",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ))),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
