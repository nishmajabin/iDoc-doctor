class PrescriptionMedication {
  final String medication;
  final int dosage;
  final int duration;
  final String durationUnit;
  final String repeat;
  final String timeOfDay;
  final String beTaken;

  PrescriptionMedication({
    required this.medication,
    required this.dosage,
    required this.duration,
    required this.durationUnit,
    required this.repeat,
    required this.timeOfDay,
    required this.beTaken,
  });

  Map<String, dynamic> toMap() => {
        'medication': medication,
        'dosage': dosage,
        'duration': duration,
        'durationUnit': durationUnit,
        'repeat': repeat,
        'timeOfDay': timeOfDay,
        'beTaken': beTaken,
      };

  factory PrescriptionMedication.fromMap(Map<String, dynamic> map) =>
      PrescriptionMedication(
        medication: map['medication'] ?? '',
        dosage: map['dosage'] ?? 1,
        duration: map['duration'] ?? 1,
        durationUnit: map['durationUnit'] ?? 'Week',
        repeat: map['repeat'] ?? 'Everyday',
        timeOfDay: map['timeOfDay'] ?? 'Morning',
        beTaken: map['beTaken'] ?? 'After Food',
      );
}

class PrescriptionRecord {
  final String id;
  final String name;
  final String docNote;
  final String userId;
  final DateTime timestamp;
  final List<PrescriptionMedication> medications;

  PrescriptionRecord({
    required this.id,
    required this.name,
    required this.docNote,
    required this.userId,
    required this.timestamp,
    required this.medications,
  });

  factory PrescriptionRecord.fromFirestore(
      String docId, Map<String, dynamic> data) {
    final rawList = data['prescriptions'] as List<dynamic>? ?? [];
    return PrescriptionRecord(
      id: docId,
      name: data['name'] ?? '',
      docNote: data['docnote'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] != null)
          ? (data['timestamp'] as dynamic).toDate()
          : DateTime.now(),
      medications:
          rawList.map((e) => PrescriptionMedication.fromMap(e)).toList(),
    );
  }
}