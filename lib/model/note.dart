import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  const Note({required this.id, required this.createdAt, required this.title, required this.body});

  Note copyWith({String? id, String? title, String? body, DateTime? createdAt}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title];
}
