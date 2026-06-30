import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/features/common_code/providers/common_code_provider.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commonCodeAsync = ref.watch(commonCodeProvider);

    return Scaffold(
      body: commonCodeAsync.when(
        data: (codes) {
          return ListView(
            children: codes.entries.map((entry) {
              return ExpansionTile(
                title: Text(entry.key),
                children: entry.value
                    .map((c) => Text('${c.code} (${c.ref1 ?? ''})'))
                    .toList(),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러: $err')),
      ),
    );
  }
}
