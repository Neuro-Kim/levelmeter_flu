import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

void main() {
  // 앱 시작 시 landscape 모드 강제 설정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const LevelApp());
  });
}

class LevelApp extends StatelessWidget {
  const LevelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelScreen(),
    );
  }
}

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  double _zAngle = 0.0;

  @override
  void initState() {
    super.initState();
    // 가속도계 데이터 수신
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Z 축의 각도 계산 (라디안 -> 도)
        _zAngle = atan2(event.y, event.x) * 180 / pi;
      });
    });
  }

  // Z축 각도를 -180 ~ 180 범위로 변환하는 함수
  double _normalizeZAngle(double angle) {
    double normalizedAngle = angle + 180; //0 ~360
    if (normalizedAngle > 180) {
      normalizedAngle -= 360; // -180 ~ 180
    }
    return normalizedAngle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 45, 68),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              '${_normalizeZAngle(_zAngle).toStringAsFixed(2)}°',
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
