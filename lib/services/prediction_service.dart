import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static Future<Map<String, dynamic>?> getPrediction() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.202.78:5000/predict"), // 🔥 CHANGE if needed
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print("Prediction error: $e");
      return null;
    }
  }
}