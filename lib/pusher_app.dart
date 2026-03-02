import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherApp extends StatefulWidget {
  const PusherApp({super.key});

  @override
  State<PusherApp> createState() => _PusherAppState();
}

class _PusherAppState extends State<PusherApp> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  String _log = "Initializing...";

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  Future<void> initPusher() async {
    try {
      await pusher.init(
        apiKey: "2e3674612d4c660f904f",
        cluster: "ap2",
        authEndpoint: "http://10.0.2.2:8000/api/broadcasting/auth",
        onEvent: onEvent,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onError: onError,
        authParams: {
          'headers': {
            'Authorization': 'Bearer 7|KuyddnfNRypQfYotjZWEtVBgqdyOTrzbsy2Dwjjk8c7d8955',
            'Content-Type': 'application/json',
          }
        },
      );

      // Subscribe specifically to a 'private-' prefixed channel
      await pusher.subscribe(channelName: "private-watch-chat.1");
      await pusher.connect();
    } catch (e) {
      setState(() => _log = "Error: $e");
    }
  }

  void onEvent(PusherEvent event) {
    setState(() => _log = "Event Received: ${event.data}");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    setState(() => _log = "Successfully joined $channelName");
  }

  void onError(String message, int? code, dynamic e) {
    setState(() => _log = "Pusher Error: $message (Code: $code)");
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Pusher Private Channel")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(_log, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}