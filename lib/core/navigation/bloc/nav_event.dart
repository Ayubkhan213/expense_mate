abstract class NavEvent {}

class ChangeTabEvent extends NavEvent {
  final int index;
  ChangeTabEvent(this.index);
}
