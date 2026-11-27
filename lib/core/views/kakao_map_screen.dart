import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/my_location_marker.dart';
import 'package:jiburo_app/core/views/widgets/post_pin_marker.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_state.dart';
import 'package:jiburo_app/features/lost_post/providers/location_state.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

class KakaoMapScreen extends ConsumerStatefulWidget {
  final void Function() onTap;
  final void Function() onTapReset;
  final double floatingBottom;
  final bool hasPin;

  /// 지도에 표시할 게시글 마커
  final List<PostSummary> pins;

  /// 마커를 눌렀을 때 (게시글 ID)
  final void Function(String postId)? onPinTap;

  /// 지도 화면 영역이 바뀌었을 때 (이동·확대 후) 마커를 다시 불러오기 위한 알림
  final void Function(
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
  )?
  onViewportChanged;

  const KakaoMapScreen({
    super.key,
    required this.onTap,
    required this.onTapReset,
    this.floatingBottom = 75,
    this.hasPin = false,
    this.pins = const [],
    this.onPinTap,
    this.onViewportChanged,
  });

  @override
  ConsumerState<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends ConsumerState<KakaoMapScreen> {
  bool isMapReady = false;
  KakaoMapController? mapController;
  LatLng? myPos;
  LatLng initialPos = LatLng(
    LocationState.lat ?? 37.5665,
    LocationState.lng ?? 126.9780,
  );
  double _heading = 0;
  Poi? myLocationPoi;

  // 게시글 마커 (게시글 ID → 지도에 그려진 Poi)
  final Map<String, Poi> _pinPois = {};
  PoiStyle? _pinStyle;
  bool _syncingPins = false;
  bool _pinsDirty = false;
  Timer? _viewportDebounce;

  StreamSubscription? _positionStream;
  StreamSubscription? _compassStream;

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
  void didUpdateWidget(covariant KakaoMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.pins, widget.pins)) _syncPins();
  }

  /// 현재 보이는 영역을 알려 마커를 다시 불러오게 함 (연속 이동은 0.4초 후 한 번만)
  void _notifyViewport() {
    _viewportDebounce?.cancel();
    _viewportDebounce = Timer(const Duration(milliseconds: 400), () async {
      final callback = widget.onViewportChanged;
      if (!mounted || callback == null || mapController == null) return;
      final bounds = await mapController!.getBounds(context);
      if (!mounted || bounds == null) return;
      callback(
        bounds.sw.latitude,
        bounds.ne.latitude,
        bounds.sw.longitude,
        bounds.ne.longitude,
      );
    });
  }

  /// 목록과 지도 마커를 일치시킴: 사라진 건 지우고 새로 생긴 건 추가
  Future<void> _syncPins() async {
    if (mapController == null) return;
    if (_syncingPins) {
      _pinsDirty = true; // 진행 중이면 끝난 뒤 한 번 더
      return;
    }
    _syncingPins = true;
    try {
      do {
        _pinsDirty = false;
        final controller = mapController!;
        final wanted = {for (final p in widget.pins) p.id: p};

        for (final id in _pinPois.keys.toList()) {
          if (!wanted.containsKey(id)) {
            await controller.labelLayer.removePoi(_pinPois.remove(id)!);
          }
        }

        _pinStyle ??= PoiStyle(
          icon: await KImage.fromWidget(
            const PostPinMarker(),
            const Size(48, 56),
          ),
          anchor: KPoint(0.5, 1.0),
        );

        for (final post in wanted.values) {
          final lat = post.latitude;
          final lng = post.longitude;
          if (_pinPois.containsKey(post.id) || lat == null || lng == null) {
            continue;
          }
          _pinPois[post.id] = await controller.labelLayer.addPoi(
            LatLng(lat, lng),
            style: _pinStyle!,
            id: 'pin_${post.id}',
            onClick: () => widget.onPinTap?.call(post.id),
          );
        }
      } while (_pinsDirty && mounted);
    } catch (_) {
      // 마커 표시 실패는 지도 사용을 막지 않음
    } finally {
      _syncingPins = false;
    }
  }

  @override
  void initState() {
    super.initState();

    // GPS 실시간 스트림
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).listen((position) async {
          if (!mounted) {
            final newPos = LatLng(position.latitude, position.longitude);
            setState(() => myPos = newPos);
          }
        });

    _compassStream = FlutterCompass.events?.listen((event) {
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
    _viewportDebounce?.cancel();
    _positionStream?.cancel();
    _compassStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addPost = ref.watch(addPostProvider);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: AbsorbPointer(
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
                  _notifyViewport();
                  _syncPins();
                },

                // onMapClick: (point, position) => widget.onTap.call(),
                onCameraMoveStart: (gestureType) {
                  if (gestureType == GestureType.pan) {
                    widget.onTap.call();
                  }
                },
                onCameraMoveEnd: (position, gestureType) {
                  _notifyViewport();
                  if (gestureType == GestureType.pan) {
                    widget.onTapReset.call();
                  }
                },
              ),
            ),
          ),

          if (widget.hasPin)
            Positioned(
              top: 280,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.point50,
                      ),
                      child: Text(
                        addPost.locationName ?? '서울시청',
                        style: AppFonts.l1nM.copyWith(color: AppColors.white),
                      ),
                    ),
                    SvgPicture.asset('assets/images/balloon_tail.svg'),
                  ],
                ),
              ),
            ),

          if (!isMapReady)
            Positioned.fill(
              child: Image.asset(
                'assets/images/map_skeleton.png',
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: widget.floatingBottom),
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
