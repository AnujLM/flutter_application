import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import for Firebase Messaging
import 'package:device_info_plus/device_info_plus.dart'; // Import for device info
import 'screens/home_screen.dart'; // Using relative path for internal imports

// Function to get device ID, required for notification setup
Future<String> getDeviceId() async {
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  // This retrieves a platform-specific identifier.
  // For Android, it typically uses 'id' and for iOS, 'identifierForVendor'.
  final deviceId = deviceInfo.data["identifierForVendor"] 
    ?? deviceInfo.data["id"] 
    ?? "unknown_device_id"; // Fallback in case neither is available
  debugPrint("Device id - $deviceId");
  return deviceId.toString();
}

// Function to set up Firebase Messaging permissions and get FCM token
Future<String?> setupMessaging() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // Get token if permission granted
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    final token = await messaging.getToken();
    return token.toString();
  } else {
    debugPrint("FCM token permission not granted: ${settings.authorizationStatus}");
    return null;
  }
}

// Function to initialize LikeMinds Chat SDK's notification handler
Future<void> setupNotifications(GlobalKey<NavigatorState> navigatorKey) async {
  // Ensure Firebase is initialized if you are using it for notifications.
  // If not already done in your project, add 'package:firebase_core/firebase_core.dart';
  // and call `await Firebase.initializeApp();` here or earlier.
  // For this example, we assume Firebase is initialized externally or implicitly by other plugins.

  final devId = await getDeviceId();
  final fcmToken = await setupMessaging();
  if (fcmToken == null) {
    debugPrint("FCM token is null or permission declined. Notifications may not work.");
    return;
  }
  // Initialise the LMChatNotificationHandler with device ID, FCM token, and the root navigator key
  LMChatNotificationHandler.instance.init(
    deviceId: devId,
    fcmToken: fcmToken,
    rootNavigatorKey: navigatorKey, // Pass the root navigator key
  );
  debugPrint("LMChatNotificationHandler initialized.");

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(LMChatNotificationHandler.instance.handleBackgroundNotification);

  // Listen to foreground messages and display them
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');
    LMChatNotificationHandler.instance.handleForegroundNotifications(message);
  });

  // Handle messages when the app is opened from a terminated state
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    debugPrint("App opened from terminated state by notification.");
    LMChatNotificationHandler.instance.handleNotification(initialMessage, navigatorKey);
  }

  // Handle messages when the app is opened from a background state by tapping a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("App opened from background by tapping notification.");
    LMChatNotificationHandler.instance.handleNotification(message, navigatorKey);
  });
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Create a GlobalKey for NavigatorState

  // Call setup notifications with the created navigator key
  await setupNotifications(navigatorKey); 

  // Call SDK initialization
  await LMChatCore.instance.initialize(
    // It's a good practice to set a domain for the SDK if you have one.
    // domain: "your_likeminds_domain.com",
    // Example theme setup, can be customized further as per Theming.md
    theme: LMChatThemeData.light(),
    // Optional configuration for the SDK
    config: LMChatConfig(
      enablePushNotifications: true, // Set to true if you are handling push notifications
      shareLogsWithLM: true,
    ),
    // Optional callback for SDK events (success, failure, updates)
    lmChatCallback: LMChatCoreCallback(
      onInitSuccess: () {
        debugPrint("LMChatCore initialized successfully!");
      },
      onInitFailure: (error) {
        debugPrint("LMChatCore initialization failed: $error");
      },
      onLogoutSuccess: () {
        debugPrint("LMChatCore logged out successfully!");
      },
      onLogoutFailure: (error) {
        debugPrint("LMChatCore logout failed: $error");
      },
    ),
    // Optional analytics listener
    analyticsListener: (event) {
      debugPrint("Analytics Event: ${event.eventName}, Properties: ${event.eventProperties}");
    },
  );
  // run the app
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
    navigatorKey: navigatorKey, // Assign the navigator key to MaterialApp
  ));
}