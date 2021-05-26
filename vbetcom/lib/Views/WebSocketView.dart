import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Models/Login/LoginRequest.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyAppSocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MyHomePage(
      title: title,
      channel: IOWebSocketChannel.connect(websocketUrl),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : snapshot.error.toString()),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {

    LoginRequestParams requestData = LoginRequestParams("dinaljivani", "Dinal35213de2");

    LoginRequest request = LoginRequest("restore_login"+cmdId,"restore_login", requestData);

    String requestJson = request.toJson().toString();
    String json = jsonEncode(request);

    widget.channel.sink.add(json);

//    {
//      "command": "restore_login", "params": {
//    "user_id": 11111,
//    "auth_token": "some-random-authToken-12345678" }
//  }

//    if (_controller.text.isNotEmpty) {
//      widget.channel.sink.add(_controller.text);
//    }


  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
