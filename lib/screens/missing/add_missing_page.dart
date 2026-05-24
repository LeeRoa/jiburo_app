import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/missing/widget/add_missing/add_step.dart';
import 'package:jiburo_app/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

class AddMissingPage extends StatefulWidget {
  const AddMissingPage({super.key});

  @override
  State<AddMissingPage> createState() => _AddMissingPageState();
}

class _AddMissingPageState extends State<AddMissingPage> {
  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.notify, title: '실종정보 등록'),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [AddStep()],
          ),
        ),
      ),
    );
  }
}
