# Smart Home Assistant - Flutter App

A comprehensive smart home automation application built with Flutter that combines voice assistant, health monitoring, alert management, and EEG (electroencephalogram) signal processing with ML-powered predictions for intelligent device control.

## About the App

The Smart Home Assistant is a multi-feature Flutter application designed to provide a seamless interface for controlling smart home devices and monitoring health metrics. The app integrates multiple technologies including MQTT for IoT communication, machine learning for signal prediction, and smart bulb control via UDP.

### Core Features

1. **Voice Assistant (Speech Screen)**
   - Speech-to-text recognition
   - Voice command processing
   - Interactive microphone interface with animated controls
   - Real-time voice input handling

2. **Health Monitor**
   - Real-time health metrics monitoring
   - Heart rate tracking
   - Animated health cards with smooth transitions
   - Visual health status indicators

3. **Alert System**
   - Notification management
   - Alert notification display
   - System-wide alert handling

4. **EEG Brain Signal Monitor**
   - Real-time EEG signal visualization
   - Live chart display of brain wave patterns
   - ML-powered signal prediction (TFLite integration)
   - Automatic character detection from EEG signals
   - Smart bulb control based on EEG predictions
   - UDP socket communication with WIZ smart bulbs
   - 2-second polling interval for predictions

## Technology Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Material 3** - Modern UI design system
- **fl_chart** - Real-time data visualization
- **animate_do** - Animation library
- **avatar_glow** - Animated avatar effects

### Backend Integration
- **MQTT Client (mqtt_client v9.7.2)** - IoT device communication
- **HTTP Client** - REST API calls for predictions
- **TFLite Flutter (v0.11.0)** - Machine learning model inference
- **Speech to Text (v7.0.0)** - Voice input processing
- **AudioPlayers (v6.4.0)** - Audio playback
- **WIZ SDK** - Smart bulb control

### Utilities
- **Shared Preferences** - Local data persistence
- **Highlight Text** - Text highlighting and formatting

## Architecture & Services

### Service Layer (`lib/services/`)

1. **mqtt_service.dart**
   - MQTT broker connection management
   - Message publishing for bulb control
   - Maintains persistent connection with broker
   - Publishes commands to "bulb/control" topic

2. **prediction_service.dart**
   - HTTP API integration for EEG predictions
   - Connects to prediction server (192.168.202.78:5000)
   - Fetches real-time prediction results
   - Returns character, prediction confidence, bulb state, and signal type

3. **command_mapper.dart**
   - Maps EEG predictions to control commands
   - Converts character predictions to ON/OFF states
   - Bridges prediction results to device control

### Screen Components (`lib/`)

1. **main.dart** - Application entry point and main navigation
   - Bottom tab navigation with 4 screens
   - Material 3 theming with Indigo color scheme
   - Stateful main screen managing navigation state

2. **speech_screen.dart** - Voice input interface
   - Animated microphone icon
   - Fade animation on UI elements
   - Floating action button for voice input

3. **HealthMonitorScreen.dart** - Health metrics display
   - Multiple health cards with animations
   - Staggered card animations on load
   - Color-coded health indicators

4. **eeg_screen.dart** - EEG signal monitoring
   - Real-time line chart visualization (fl_chart)
   - Toggle acquisition button
   - Bulb control via UDP sockets
   - 2-second polling timer for predictions
   - Automatic signal type detection
   - Character prediction display

5. **alert_page.dart** - Alert notifications

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android SDK (for Android development)
- Xcode (for iOS development)
- MQTT broker running (e.g., Mosquitto)
- Python Flask server for prediction endpoint (192.168.202.78:5000)
- WIZ smart bulb on network (192.168.202.50)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/Ama1007/EEG_Home_Automation_App.git
   cd app
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Configure network settings:
   - Update MQTT broker IP in `lib/services/mqtt_service.dart`
   - Update prediction server IP in `lib/services/prediction_service.dart`
   - Update WIZ bulb IP in `lib/eeg_screen.dart` (default: 192.168.202.50)

### Running the App

**For Android:**
```sh
flutter run
```

**For iOS:**
```sh
flutter run
```

**For Web:**
```sh
flutter run -d chrome
```

**For specific device:**
```sh
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── main.dart                          # App entry point & navigation
├── speech_screen.dart                 # Voice assistant screen
├── HealthMonitorScreen.dart           # Health metrics display
├── alert_page.dart                    # Alerts notification screen
├── eeg_screen.dart                    # EEG monitoring & control
└── services/
    ├── mqtt_service.dart              # MQTT communication
    ├── prediction_service.dart        # ML prediction API
    └── command_mapper.dart            # Prediction to command mapping

android/                               # Android platform code
ios/                                   # iOS platform code
web/                                   # Web platform code
linux/                                 # Linux platform code
macos/                                 # macOS platform code
windows/                               # Windows platform code
```

## How It Works

### EEG Signal Flow
1. **Acquisition**: Start polling with "Start Acquisition" button on EEG screen
2. **Prediction**: Backend ML model processes EEG signals every 2 seconds
3. **Detection**: Character and signal type predictions received from Flask API
4. **Control**: Based on prediction, send control command to WIZ bulb via UDP
5. **Visualization**: Real-time display of signal data on line chart

### Device Communication
- **MQTT**: Commands published to "bulb/control" topic for compatible devices
- **UDP**: Direct socket communication to WIZ bulb IP (192.168.202.50:38899)
- **HTTP**: GET requests to prediction API for ML inference results

## API Endpoints

### Prediction Endpoint
**URL**: `http://192.168.202.78:5000/predict`
**Method**: GET
**Response Format**:
```json
{
  "character": "A",
  "prediction": 0.95,
  "bulb": true,
  "type": "Alpha"
}
```

## Configuration

Important network addresses to configure:

| Component | Default IP | Default Port | Config File |
|-----------|-----------|--------------|------------|
| WIZ Bulb | 192.168.202.50 | 38899 | eeg_screen.dart |
| Prediction Server | 192.168.202.78 | 5000 | prediction_service.dart |
| MQTT Broker | BROKER_IP | 1883 | mqtt_service.dart |

## Dependencies

See `pubspec.yaml` for complete list:
- **flutter**: SDK framework
- **mqtt_client**: ^9.7.2 - MQTT messaging
- **http**: ^0.13.6 - HTTP requests
- **tflite_flutter**: ^0.11.0 - ML inference
- **speech_to_text**: ^7.0.0 - Voice recognition
- **fl_chart**: ^1.1.0 - Data visualization
- **audioplayers**: ^6.4.0 - Audio playback
- **wiz**: ^0.0.5 - Smart bulb SDK
- **shared_preferences**: ^2.5.2 - Local storage
- **animate_do**: ^4.2.0 - Animations
- **avatar_glow**: ^2.0.2 - Avatar effects

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
