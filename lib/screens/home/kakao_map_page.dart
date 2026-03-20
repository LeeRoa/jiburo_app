import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiburo_app/state/location_state.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/widgets/my_location_marker.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

class KakaoMapPage extends StatefulWidget {
  final void Function() onTap;
  final void Function() onTapReset;
  const KakaoMapPage({
    super.key,
    required this.onTap,
    required this.onTapReset,
  });

  @override
  State<KakaoMapPage> createState() => _KakaoMapPageState();
}

class _KakaoMapPageState extends State<KakaoMapPage> {
  bool isMapReady = false;
  KakaoMapController? mapController;
  LatLng? myPos;
  LatLng initialPos = LatLng(
    LocationState.lat ?? 37.5665,
    LocationState.lng ?? 126.9780,
  );
  double _heading = 0;
  Poi? myLocationPoi;

  double _smoothHeading = 0; // 부드러운 값
  DateTime? _lastRotateTime;

  // 저역통과 필터 (튀는 값 완화)
  double _lowPassFilter(
    double newValue,
    double oldValue, {
    double alpha = 0.05,
  }) {
    // 360도 경계 처리 (359 → 1 튀는 현상 방지)
    double diff = newValue - oldValue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return oldValue + alpha * diff;
  }

  Future<void> _initLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final newPos = LatLng(position.latitude, position.longitude);

    setState(() {
      myPos = newPos;
    });

    final cameraUpdate = CameraUpdate.newCenterPosition(newPos);
    await mapController?.moveCamera(cameraUpdate);
  }

  void _updateLocation({required LatLng pos, required double heading}) async {
    if (mapController == null) return;

    if (myLocationPoi == null) {
      // 1. 처음 한 번만 생성
      myLocationPoi = await mapController!.labelLayer.addPoi(
        pos,
        style: PoiStyle(
          icon: await KImage.fromWidget(MyLocationMarker(), Size(80, 80)),
          anchor: KPoint(0.5, 0.5),
        ),
      );
      myLocationPoi!.rotate(heading);
    } else {
      // 2. 위치와 각도를 동시에 업데이트
      myLocationPoi!.move(pos);
      myLocationPoi!.rotate(heading);
    }
  }

  @override
  void initState() {
    super.initState();

    // GPS 실시간 스트림
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((position) async {
      final newPos = LatLng(position.latitude, position.longitude);
      setState(() => myPos = newPos);
    });

    FlutterCompass.events?.listen((event) {
      if (!mounted) return;
      double raw = event.heading ?? 0;

      // 200ms마다만 업데이트
      final now = DateTime.now();
      if (_lastRotateTime != null &&
          now.difference(_lastRotateTime!).inMilliseconds < 200) {
        return;
      }
      _lastRotateTime = now;
      _smoothHeading = _lowPassFilter(raw, _smoothHeading);
      if ((_smoothHeading - _heading).abs() < 2.0) return;

      setState(() => _heading = _smoothHeading);
      myLocationPoi?.rotate(_heading);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: !isMapReady,
              child: KakaoMap(
                option: KakaoMapOption(position: initialPos, zoomLevel: 16),

                onMapReady: (controller) async {
                  mapController = controller;

                  _updateLocation(pos: initialPos, heading: _heading);

                  // 카메라 이동완료 후 딜레이, 딜레이 되는 동안 지도 준비
                  Future.delayed(Duration(milliseconds: 800), () {
                    if (mounted) setState(() => isMapReady = true);
                  });

                  // 현재 위치 추적
                  await _initLocation();
                },

                // onMapClick: (point, position) => widget.onTap.call(),
                onCameraMoveStart: (gestureType) {
                  if (gestureType == GestureType.pan) {
                    widget.onTap.call();
                  }
                },
                onCameraMoveEnd: (position, gestureType) {
                  if (gestureType == GestureType.pan) {
                    widget.onTapReset.call();
                  }
                },
              ),
            ),
            if (!isMapReady)
              Container(
                color: AppColors.blue,
                width: double.infinity,
                height: double.infinity,
              ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            onPressed: _initLocation,
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            child: Icon(Icons.my_location, color: AppColors.blue, size: 20),
          ),
        ),
      ),
    );
  }
}
