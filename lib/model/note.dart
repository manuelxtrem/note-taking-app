import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith(
      {String? id, String? title, String? body, DateTime? createdAt, DateTime? updatedAt}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isSynced(DateTime lastSync) {
    return updatedAt.isBefore(lastSync) || updatedAt.isAtSameMomentAs(lastSync);
  }

  @override
  List<Object?> get props => [id, title, updatedAt];
}
