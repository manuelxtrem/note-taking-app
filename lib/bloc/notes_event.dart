part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitNotesEvent extends NotesEvent {}

class GetAllNotesEvent extends NotesEvent {}
