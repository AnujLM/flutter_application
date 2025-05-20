import 'package:flutter/material.dart';

Future<void> main() async {
  // run the app
  runApp(const MaterialApp(
    home: LMSampleChat(),
    debugShowCheckedModeBanner: false,
  ));
}

// A blank scaffold with a button that opens
// the LM Social Chat when clicked
class LMSampleChat extends StatelessWidget {
  const LMSampleChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LM Sample Chat'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: const Text('Open Chat'),
        ),
      ),
    );
  }
}
