import 'package:flutter/material.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Assistant"), centerTitle: true),
      body: Center(
        child: FadeTransition(
          opacity: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, size: 120, color: Colors.indigo[600]),
              const SizedBox(height: 30),
              Text("Tap the button and speak",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        )),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.mic, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
