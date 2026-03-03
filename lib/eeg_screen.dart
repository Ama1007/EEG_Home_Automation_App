import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/prediction_service.dart';

class EEGScreen extends StatefulWidget {
  const EEGScreen({super.key});

  @override
  State<EEGScreen> createState() => _EEGScreenState();
}

class _EEGScreenState extends State<EEGScreen> {
  bool isAcquiring = false;
  bool isLightOn = false;
  bool isLoading = false;

  String detectedCharacter = "No Signal";
  String detectedType = "-";
  int detectedIndex = -1;

  Timer? _timer;

  final String bulbIP = "192.168.202.50"; // CHANGE if needed
  final int bulbPort = 38899;

  List<FlSpot> eegData = List.generate(
    50,
    (index) => FlSpot(index.toDouble(), (index % 7) * 0.3),
  );

  // -------------------------
  // WIZ BULB CONTROL
  // -------------------------
  Future<void> _controlBulb(bool turnOn) async {
    final payload = jsonEncode({
      "method": "setState",
      "params": {"state": turnOn}
    });

    try {
      RawDatagramSocket socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      socket.send(utf8.encode(payload), InternetAddress(bulbIP), bulbPort);
      socket.close();

      print("Bulb ${turnOn ? "ON" : "OFF"}");
    } catch (e) {
      print("Bulb error: $e");
    }
  }

  // -------------------------
  // START / STOP
  // -------------------------
  Future<void> _toggleAcquisition() async {
    setState(() => isAcquiring = !isAcquiring);

    if (isAcquiring) {
      _startPolling();
    } else {
      _stopPolling();
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      setState(() => isLoading = true);

      final response = await PredictionService.getPrediction();

      if (response != null &&
          response["character"] != null &&
          response["prediction"] != null &&
          response["bulb"] != null &&
          response["type"] != null) {

        String character = response["character"];
        int index = response["prediction"];
        bool bulbState = response["bulb"];
        String type = response["type"];

        setState(() {
          detectedCharacter = character;
          detectedIndex = index;
          detectedType = type;
          isLightOn = bulbState;
        });

        _controlBulb(bulbState);
      }

      setState(() => isLoading = false);
    });
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -------------------------
  // UI
  // -------------------------

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isAcquiring ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              child: Icon(
                isAcquiring ? Icons.bolt : Icons.pause,
                color: isAcquiring ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              isAcquiring ? "EEG Running..." : "EEG Stopped",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEEGChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: eegData,
                  isCurved: true,
                  dotData: FlDotData(show: false),
                  color: Colors.indigo,
                  barWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.psychology, color: Colors.indigo),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Character: $detectedCharacter",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Class Index: $detectedIndex"),
                  Text("Type: $detectedType"),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isLightOn ? Colors.yellow.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                  child: Icon(
                    Icons.lightbulb,
                    color: isLightOn ? Colors.orange : Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  isLightOn ? "Light ON" : "Light OFF",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Switch(value: isLightOn, onChanged: null)
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton.icon(
      onPressed: _toggleAcquisition,
      icon: Icon(isAcquiring ? Icons.stop : Icons.play_arrow),
      label: Text(isAcquiring ? "Stop" : "Start"),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAcquiring ? Colors.red : Colors.indigo,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EEG Character Recognition")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildEEGChart(),
            const SizedBox(height: 20),
            _buildPredictionCard(),
            const SizedBox(height: 20),
            _buildLightCard(),
            const Spacer(),
            _buildButton(),
          ],
        ),
      ),
    );
  }
}