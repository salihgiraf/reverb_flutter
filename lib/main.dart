import 'package:flutter/material.dart';
import 'package:laravel_reverb/pusher_app.dart';
import 'package:pusher_reverb_flutter/pusher_reverb_flutter.dart';

void main() {
  runApp(const PusherApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize and connect

  Future<Map<String, String>> myAuthorizer(
    String channelName,
    String socketId,
  ) async {
    // Return authentication headers (e.g., Bearer token)
    return {'Authorization': 'Bearer 7|KuyddnfNRypQfYotjZWEtVBgqdyOTrzbsy2Dwjjk8c7d8955'};
  }

  late ReverbClient client;

  Channel? _channel;

  String receivedData = '';

  void subscribe() {
    try {
      _channel = client.subscribeToPrivateChannel('private-watch-chat.1');
    } catch (e) {
      print('Subscription error: $e');
    }

    _channel?.bind('WatchChatMessageSend', (String eventName, dynamic data) {
      print('Event Name: $eventName');
      print('Received data: $data');

      // If you need to update the UI
      setState(() {
        receivedData = data.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeClient();
    client.connect();
  }

  void _initializeClient() {
    client = ReverbClient.instance(
      host: '10.0.2.2',
      port: 8080,
      appKey: '50clc8gzhv7qts3lhs4p',
      authEndpoint: 'http://10.0.2.2:8000/api/broadcasting/auth',
      authorizer: myAuthorizer,
      onConnecting: () {
        print('Connecting to server...');
        // Update UI to show connecting indicator
      },

      // Callback fired when successfully connected
      onConnected: (socketId) {
        print('Connected! Socket ID: $socketId');
        subscribe();
      },

      // Callback fired when attempting to reconnect after connection loss
      onReconnecting: () {
        print('Connection lost. Reconnecting...');
        // Update UI to show reconnecting status
      },

      // Callback fired when disconnected
      onDisconnected: () {
        print('Disconnected from server');
        // Update UI to show disconnected status
      },

      // Callback fired on connection errors
      onError: (error) {
        print('Connection error: $error');
        // Show error message to user
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(receivedData.isEmpty ? 'Hello World' : receivedData),
        ),
      ),
    );
  }
}
