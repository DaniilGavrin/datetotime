import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Список событий!',
            style: TextStyle(fontSize: 24),
          ),
          // Здесь будет список событий или форма добавления событий
        ],
      ),
    );
  }
}
