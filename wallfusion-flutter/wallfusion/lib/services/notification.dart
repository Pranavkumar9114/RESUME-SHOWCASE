import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  NotificationPage({required this.analytics});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseMessagingService _firebaseMessagingService =
      FirebaseMessagingService();
  List<RemoteMessage> _messages = [];
  late StreamSubscription<RemoteMessage> _subscription;

  @override
  void initState() {
    super.initState();
    _firebaseMessagingService.initialize(widget.analytics);
    _loadStoredMessages();

    // Subscribe to the stream of new messages
    _subscription = _firebaseMessagingService.messageStream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadStoredMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('notifications') ?? [];
    setState(() {
      _messages = storedMessages.map((messageJson) {
        return RemoteMessage.fromMap(jsonDecode(messageJson));
      }).toList();
    });
  }

  void _removeNotification(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('notifications') ?? [];

    // ignore: unused_local_variable
    final messageJson = jsonEncode(message.toMap());
    storedMessages.removeWhere(
        (msg) => jsonDecode(msg)['messageId'] == message.messageId);

    await prefs.setStringList('notifications', storedMessages);
    setState(() {
      _messages.removeWhere((msg) => msg.messageId == message.messageId);
    });
  }

  // ignore: unused_element
  void _markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unread_notifications', 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        title: Text('Notifications', style: GoogleFonts.alegreya(fontSize: 25)),
      ),
      body:
          NotificationList(messages: _messages, onDelete: _removeNotification),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<RemoteMessage> messages;
  final void Function(RemoteMessage message) onDelete;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  NotificationList({required this.messages, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index].notification?.title ?? ''),
          subtitle: Text(messages[index].notification?.body ?? ''),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(messages[index]),
          ),
        );
      },
    );
  }
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageController =
      StreamController<RemoteMessage>.broadcast();
  late FirebaseAnalytics _analytics;

  Stream<RemoteMessage> get messageStream => _messageController.stream;

  void initialize(FirebaseAnalytics analytics) {
    _analytics = analytics;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // ignore: avoid_print
      print(
          'Received a message: ${message.notification?.title} - ${message.notification?.body}');

      _analytics.logEvent(
        name: 'message_received',
        parameters: {
          'title': message.notification?.title ?? 'No Title',
          'body': message.notification?.body ?? 'No Body',
        },
      );

      await _saveMessage(message);

      _messageController.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ignore: avoid_print
      print('Message clicked!');
      _analytics.logEvent(
        name: 'message_clicked',
        parameters: {
          'title': message.notification?.title ?? 'No Title',
          'body': message.notification?.body ?? 'No Body',
        },
      );
    });

    _firebaseMessaging.getToken().then((token) {
      // ignore: avoid_print
      print("Firebase Token: $token");
    });
  }

  Future<void> _saveMessage(RemoteMessage message) async {
    // Check if the app is in the foreground
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();
      final storedMessages = prefs.getStringList('notifications') ?? [];

      final messageJson = jsonEncode(message.toMap());
      if (!storedMessages
          .any((msg) => jsonDecode(msg)['messageId'] == message.messageId)) {
        storedMessages.add(messageJson);
        await prefs.setStringList('notifications', storedMessages);
        await _incrementUnreadCount();
      }
    }
  }

  Future<void> _incrementUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    int unreadCount = prefs.getInt('unread_notifications') ?? 0;
    unreadCount++;
    await prefs.setInt('unread_notifications', unreadCount);
  }

  Future<int> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('unread_notifications') ?? 0;
  }

  void dispose() {
    _messageController.close();
  }
}

// ignore: use_key_in_widget_constructors
class NotificationBell extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NotificationBellState createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final FirebaseMessagingService _firebaseMessagingService =
      FirebaseMessagingService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _firebaseMessagingService.initialize(FirebaseAnalytics.instance);
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    int unreadCount = await _firebaseMessagingService.getUnreadCount();
    setState(() {
      _unreadCount = unreadCount;
    });
  }

  void _showNotifications(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: NotificationPage(analytics: FirebaseAnalytics.instance),
        );
      },
    );
    _markAllAsRead();
  }

  void _markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unread_notifications', 0);
    setState(() {
      _unreadCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RemoteMessage>(
      stream: _firebaseMessagingService.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _loadUnreadCount();
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => _showNotifications(context),
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$_unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
