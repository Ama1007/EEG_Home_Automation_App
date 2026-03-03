import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  static final client =
      MqttServerClient("BROKER_IP", "flutter_client");

  static Future connect() async {
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    await client.connect();
  }

  static void send(String command) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(command);
    client.publishMessage("bulb/control",
        MqttQos.atLeastOnce, builder.payload!);
  }
}