import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'screens/home_screen.dart'; // Using relative path for internal imports

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Call setup function before the runApp() function
  await LMChatCore.instance.initialize(); //cite: chat/Flutter/getting-started.md
  // run the app
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // Ensure debug banner is hidden
    home: HomeScreen(),
  ));
}