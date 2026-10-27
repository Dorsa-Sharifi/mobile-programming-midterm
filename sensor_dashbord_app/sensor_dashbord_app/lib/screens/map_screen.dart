import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position _currentPosition = Position(
    longitude: 51.3890,
    latitude: 35.6892,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
  
  bool _isLoading = true;
  String _errorMsg = "";
  
  StreamSubscription<Position>? _positionStreamSubscription;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { 
          _errorMsg = "سرویس موقعیت‌یابی (GPS) خاموش است.\nلطفاً GPS گوشی را روشن کنید."; 
          _isLoading = false; 
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { 
            _errorMsg = "دسترسی موقعیت مکانی رد شد."; 
            _isLoading = false; 
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMsg = "دسترسی موقعیت به طور دائم رد شده است. لطفا از تنظیمات آن را فعال کنید.";
          _isLoading = false;
        });
        return;
      }

      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        _currentPosition = lastPosition;
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, 
          distanceFilter: 2,             
        ),
      ).listen(
        (Position position) {
          if (mounted) {
            setState(() {
              _currentPosition = position;
            });

            try {
              _mapController.move(
                LatLng(position.latitude, position.longitude),
                15.0, 
              );
            } catch (e) {
              debugPrint("تلاش برای جابجایی پیش از سوار شدن کامل نقشه: $e");
            }
          }
        },
        onError: (error) {
          debugPrint("خطای استریم موقعیت: $error");
        },
      );

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = "خطایی رخ داد: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Map"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_errorMsg, style: const TextStyle(fontSize: 15), textAlign: TextAlign.center),
                  ),
                )
              : FlutterMap(
                  mapController: _mapController, 
                  options: MapOptions(
                    initialCenter: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                    initialZoom: 15.0,
                    keepAlive: true, 
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.sensors.dashboard',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                          width: 50,
                          height: 50,
                          child: const Icon(Icons.location_on, color: Colors.red, size: 45),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
