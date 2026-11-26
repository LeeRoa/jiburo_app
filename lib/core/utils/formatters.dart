import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiburo_app/core/provider/locale_provider.dart';

String formatDate(DateTime date, WidgetRef ref) =>
    DateFormat('yyyy-MM-dd', ref.watch(localeProvider)).format(date);

String formatCurrency(num amount) => NumberFormat('#,###').format(amount);

/// 두 좌표 사이 거리(km, 하버사인)
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}

/// 게시글 카드의 거리 문구: 내 위치에서 5km 이내 (1km 미만은 1km)
String formatNearby(double km) => '내 위치에서 ${km.ceil().clamp(1, 9999)}km 이내';

/// 채팅 말풍선 옆 시간: 오전 09:05
String formatChatTime(DateTime? t) {
  if (t == null) return '';
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final ampm = t.hour < 12 ? '오전' : '오후';
  return '$ampm ${hour12.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// 채팅 날짜 구분선: 2026년 11월 26일
String formatChatDate(DateTime t) => '${t.year}년 ${t.month}월 ${t.day}일';

/// 채팅방 목록의 상대 시간: 방금 / N분 전 / N시간 전 / N일 전 / M월 d일
String formatRelativeTime(DateTime? t, {DateTime? now}) {
  if (t == null) return '';
  final diff = (now ?? DateTime.now()).difference(t);
  if (diff.inMinutes < 1) return '방금';
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';
  if (diff.inDays < 7) return '${diff.inDays}일 전';
  return '${t.month}월 ${t.day}일';
}
