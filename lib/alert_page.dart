import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage>
    with SingleTickerProviderStateMixin {
  final List<String> alerts = [
    "High temperature detected!",
    "Heartbeat irregularity!",
    "Device disconnected!"
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alerts"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: Card(
                color: Colors.red[50],
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(alerts[index],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
