import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SlotModel extends Equatable {
  final String slotId;
  final String doctorId;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime;   // Format: "HH:mm"
  final String status;    // 'available', 'booked', 'blocked'
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SlotModel({
    required this.slotId,
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create SlotModel from Firestore document
  factory SlotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SlotModel(
      slotId: doc.id,
      doctorId: data['doctorId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      status: data['status'] ?? 'available',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert SlotModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'doctorId': doctorId,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Create a copy with modified fields
  SlotModel copyWith({
    String? slotId,
    String? doctorId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SlotModel(
      slotId: slotId ?? this.slotId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        slotId,
        doctorId,
        date,
        startTime,
        endTime,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}