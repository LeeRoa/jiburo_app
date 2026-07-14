import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiburo_app/core/provider/locale_provider.dart';

String formatDate(DateTime date, WidgetRef ref) =>
    DateFormat('yyyy-MM-dd', ref.watch(localeProvider)).format(date);

String formatCurrency(num amount) => NumberFormat('#,###').format(amount);
