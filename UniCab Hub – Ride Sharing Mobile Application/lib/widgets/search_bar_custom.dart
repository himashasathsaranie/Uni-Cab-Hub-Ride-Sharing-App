import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchBarCustom extends StatefulWidget {
  String inputText;
  Function initSearch;

  SearchBarCustom({Key? key, required this.inputText, required this.initSearch});

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {
          widget.inputText = text;
        });
        widget.initSearch(text);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: const Color(0xFF0276B4),
          size: 30,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF0276B4), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF0276B4), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        fillColor: const Color(0xFFEAEAEA),
        filled: true,
        hintText: "Enter username...",
        hintStyle: TextStyle(color: const Color(0xFF528C9E), fontSize: 18),
      ),
    );
  }
}
