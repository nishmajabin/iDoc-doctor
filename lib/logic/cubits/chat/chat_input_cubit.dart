import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputCubit extends Cubit<bool> {
  final TextEditingController controller = TextEditingController();

  ChatInputCubit() : super(false) {
    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    emit(controller.text.trim().isNotEmpty);
  }

  void send(void Function(String text) onSend) {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    onSend(text);
    controller.clear();
  }

  @override
  Future<void> close() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    return super.close();
  }
}