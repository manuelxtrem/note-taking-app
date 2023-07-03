import 'package:flutter/material.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/empty_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.grey,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
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
      // body: NotesList(),
      body: EmptyList(
        image: Image.asset('assets/image/cuate.png'),
        text: 'File not found. Try searching again.',
      ),
    );
  }
}
