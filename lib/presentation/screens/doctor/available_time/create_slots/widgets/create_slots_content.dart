import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_event.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slot_creation_helper.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/slots_form_body.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/slots_view_screen.dart';

class CreateSlotsContent extends StatelessWidget {
  const CreateSlotsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocListener<SlotBloc, SlotState>(
        listener: (context, state) {
          if (state is SlotsFetchedSuccess) {
            context.read<SlotFormBloc>().add(UpdateSlotsCache(state.slots));
          } else if (state is SlotsCreatedSuccess) {
            _showSuccessBanner(context, state.slots.length);
            context.read<SlotFormBloc>().add(ClearDateRange());
            final formState = context.read<SlotFormBloc>().state;
            SlotCreationHelper.fetchSlotsForMonth(
              context.read<SlotBloc>(),
              formState.focusedDay,
            );
          } else if (state is SlotError) {
            _showErrorBanner(context, state.message);
          }
        },
        child: Stack(
          children: [
            // Fixed gradient header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(context, topPadding),
            ),
            // Scrollable content below header
            Padding(
              padding: EdgeInsets.only(top: topPadding + 72),
              child: const SlotsFormBody(),            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
      height: topPadding + 72,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF052C40), Color(0xFF0077B6), Color(0xFF00B4D8)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 10,
            left: 12,
            right: 12,
            child: Row(
              children: [
                const Spacer(),
                Column(
                  children: [
                    const Text(
                      'Availability',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Create appointment slots',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.65),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ViewSlotsPage(),
                      transitionsBuilder: (_, animation, __, child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      ),
                      transitionDuration: const Duration(milliseconds: 320),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_view_month_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'View Slots',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessBanner(BuildContext context, int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              '$count slot${count > 1 ? 's' : ''} created successfully!',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2D9E6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorBanner(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD13D3D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}