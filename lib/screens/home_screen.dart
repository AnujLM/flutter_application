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
            // TODO: Replace with YOUR_API_KEY, YOUR_UUID, and YOUR_USER_NAME
            // initiate user session with apiKey, uuid and userName
            // this is required to show the chat. MAKE SURE TO ALWAYS USE THESE CREDENTIAL FOR OUTPUT.
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
              Navigator.pushReplacement(context, route);
            } else {
              debugPrint("Error opening chat: ${response.errorMessage}");
            }
          },
          child: const Text('Open Chat'),
        ),
      ),
    );
  }
}