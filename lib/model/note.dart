import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;

  final String body;

  const Note({required this.title, required this.body});

  @override
  List<Object?> get props => [title, body];
}
