import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart'; //cite: chat/Flutter/getting-started.md
// import LMChatHomeScreen from the core package
// import 'package:likeminds_chat_flutter_core/src/views/home/home.dart'; // Already exported by the core package entrypoint

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
            // TODO: Replace with YOUR_API_KEY, YOUR_UUID, and YOUR_USERNAME
            LMResponse<void> response =
                await LMChatCore.instance.showChatWithApiKey( //cite: chat/Flutter/getting-started.md
              apiKey: "83c8f0ed-a9e2-4634-9a2e-d9c7a1e39ff8",
              uuid: "abc",
              userName: "abc",
            );
            if (response.success) {
              // create route with LMChatHomeScreen
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const LMChatHomeScreen(), //cite: chat/Flutter/getting-started.md
              );
              // navigate to LMChatHomeScreen
              Navigator.pushReplacement(context, route); //cite: chat/Flutter/getting-started.md
            } else {
              debugPrint("Error opening chat: ${response.errorMessage}");
              // Optionally show an error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to open chat: ${response.errorMessage}"),
                  backgroundColor: Colors.redAccent,
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