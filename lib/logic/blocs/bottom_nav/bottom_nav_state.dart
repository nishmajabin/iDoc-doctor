abstract class BottomNavState {
  final int currentIndex;
  final int previousIndex;

  const BottomNavState({
    required this.currentIndex,
    this.previousIndex = 0,
  });
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(currentIndex: 0, previousIndex: 0);
}

class BottomNavChanged extends BottomNavState {
  const BottomNavChanged({
    required super.currentIndex,
    super.previousIndex,
  });
}