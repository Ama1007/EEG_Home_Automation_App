class CommandMapper {
  static String? mapPrediction(String pred) {
    if (pred == "A") return "ON";
    if (pred == "B") return "OFF";
    return null;
  }
}