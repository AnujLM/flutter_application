import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

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
            // This is required to show the chat.
            // TODO: Replace with your actual API_KEY, UUID, and USER_NAME
            LMResponse<void> response =
                await LMChatCore.instance.showChatWithApiKey(
              apiKey: "83c8f0ed-a9e2-4634-9a2e-d9c7a1e39ff8",
              uuid: "abc",
              userName: "abc",
            );
            if (response.success) {
              // Create route with LMCommunityHybridChatScreen
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const LMCommunityHybridChatScreen(),
              );
              // Navigate to LMCommunityHybridChatScreen, replacing the current screen
              Navigator.pushReplacement(context, route);
            } else {
              debugPrint("Error opening chat: ${response.errorMessage}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error opening chat: ${response.errorMessage}"),
                  backgroundColor: Colors.red,
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