import 'package:flutter_bloc/flutter_bloc.dart';

class FaqItemCubit extends Cubit<bool> {
  FaqItemCubit() : super(false); // false = collapsed

  void toggle() => emit(!state);
}