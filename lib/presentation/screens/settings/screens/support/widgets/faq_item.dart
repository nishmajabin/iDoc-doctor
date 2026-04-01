import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/faq_item/faq_item_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/faq.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/faq_item_body.dart';

class FaqItem extends StatelessWidget {
  final Faq faq;
  const FaqItem({required this.faq, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqItemCubit(),
      child: FaqItemBody(faq: faq),
    );
  }
}
