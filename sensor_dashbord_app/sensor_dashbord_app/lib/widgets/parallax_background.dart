import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ParallaxBackground extends StatefulWidget {
  final Widget child;
  const ParallaxBackground({super.key, required this.child});

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  double x = 0.0;
  double y = 0.0;
  double lastX = 0.0;
  double lastY = 0.0;

  @override
  void initState() {
    super.initState();
    accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!mounted) return;

      double newX = (event.x * 3.5).clamp(-35.0, 35.0);
      double newY = (event.y * 3.5).clamp(-35.0, 35.0);

      if ((newX - lastX).abs() > 0.5 || (newY - lastY).abs() > 0.5) {
        setState(() {
          x = newX;
          y = newY;
          lastX = newX;
          lastY = newY;
        });
      }
    }, onError: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -45 + x,
          right: -45 - x,
          top: -45 + y,
          bottom: -45 - y,
          child: Image.asset(
            'assets/parallax_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.indigo.shade900);
            },
          ),
        ),
        Container(color: Colors.black.withOpacity(0.5)),
        widget.child,
      ],
    );
  }
}
