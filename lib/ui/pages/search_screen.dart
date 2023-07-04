import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/res/utils.dart';
import 'package:note_taking_app/ui/common/empty_list.dart';
import 'package:note_taking_app/ui/common/note_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late NotesBloc _notesBloc;
  final _filterCtrl = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  final _mainFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // search debouncer
    _filterCtrl.addListener(_onFilterText);

    // delay focus so animations can finish smoothly
    _requestFocus();
  }

  void _onFilterText() {
    _debouncer.run(() {
      log('filtering :: ${_filterCtrl.text}');
      // delay and perform search
      _notesBloc.add(FilterNotesEvent(_filterCtrl.text));
    });
  }

  @override
  void dispose() {
    _filterCtrl.removeListener(_onFilterText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notesBloc = context.read();

    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            leading: const SizedBox(),
            leadingWidth: 0,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.grey,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: '_search',
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          controller: _filterCtrl,
                          focusNode: _mainFocus,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            hintText: 'Search by the keyword...',
                            hintStyle: AppStyle.body3.copyWith(color: AppColors.textMuted),
                          ),
                          cursorColor: AppColors.textMuted,
                          style: AppStyle.body3.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
          body: () {
            log('state is $state');
            if (state is FilteredNotesState) {
              if (state.results.isEmpty && _filterCtrl.text.isNotEmpty) {
                return EmptyList(
                  image: Image.asset('assets/image/cuate.png'),
                  text: 'File not found. Try searching again.',
                );
              }

              if (state.results.isNotEmpty) {
                return NotesList(items: state.results);
              }
            }

            return const SizedBox();
          }(),
        );
      },
    );
  }

  void _requestFocus() {
    Future.delayed(const Duration(milliseconds: 600), () {
      _mainFocus.requestFocus();
    });
  }
}
