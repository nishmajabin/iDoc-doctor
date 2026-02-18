// import 'package:equatable/equatable.dart';
// import 'package:idoc_doctor_side/data/models/chat_room_model.dart';

// abstract class ChatRoomListEvent extends Equatable {
//   const ChatRoomListEvent();
//   @override
//   List<Object?> get props => [];
// }

// class WatchDoctorChatRooms extends ChatRoomListEvent {
//   final String doctorId;
//   const WatchDoctorChatRooms(this.doctorId);
//   @override
//   List<Object?> get props => [doctorId];
// }

// class ChatRoomsUpdated extends ChatRoomListEvent {
//   final List<ChatRoomModel> rooms;
//   const ChatRoomsUpdated(this.rooms);
//   @override
//   List<Object?> get props => [rooms];
// }

// class DisposeChatRoomList extends ChatRoomListEvent {
//   const DisposeChatRoomList();
// }