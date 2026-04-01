import 'package:flutter_bloc/flutter_bloc.dart';

class AboutCardCubit extends Cubit<bool> {
  AboutCardCubit() : super(false); 

  void toggle() => emit(!state);
}