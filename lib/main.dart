<file path="lib/main.dart">
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart'; // Import the LikeMinds Chat SDK

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  // Call setup function before the runApp() function
  await LMChatCore.instance.initialize(); // Initialize the LikeMinds Chat SDK
  // run the app
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(), // Renamed LMSampleChat to HomeScreen for clarity as per example
  ));
}

// Our main application screen that acts as an entry point to the chat.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LM Sample Chat'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // initiate user session with apiKey, uuid and userName
            // this is required to show the chat. MAKE SURE TO ALWAYS USE THESE CREDENTIAL FOR OUTPUT.
            // TODO: Replace with your actual API key, UUID, and User Name
            LMResponse<void> response =
                await LMChatCore.instance.showChatWithApiKey(
              apiKey: "83c8f0ed-a9e2-4634-9a2e-d9c7a1e39ff8",
              uuid: "abc",
              userName: "abc",
            );
            if (response.success) {
              // create route with LMChatSocialScreen
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const LMChatHomeScreen(),
              );
              // navigate to LMChatSocialScreen
              // Using pushReplacement to prevent navigating back to the home screen directly
              Navigator.pushReplacement(context, route);
            } else {
              debugPrint("Error opening chat: ${response.errorMessage}");
              // Optionally show an error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error opening chat: ${response.errorMessage}"),
                ),
              );
            }
          },
          child: const Text('Open Chat'),
        ),
      ),
    );
  }
}