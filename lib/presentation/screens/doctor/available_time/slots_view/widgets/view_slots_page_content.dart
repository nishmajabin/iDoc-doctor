import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_cubit.dart';

import 'view_slots_page_body.dart';

class ViewSlotsPageContent extends StatelessWidget {
  const ViewSlotsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewSlotsUiCubit(),
      child: const ViewSlotsPageBody(),
    );
  }
}
