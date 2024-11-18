import 'package:flutter/material.dart';
import 'package:datetotime/home_screen.dart' as home_screen;
import 'package:datetotime/event_screen.dart' as event_screen;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date to Time',
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Список экранов, которые будут переключаться
  final List<Widget> _screens = [
    home_screen.HomeScreen(),  // Главный экран с часами
    event_screen.EventScreen(), // Экран для событий
  ];

  int _currentIndex = 0; // Индекс текущего экрана

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date to Time'),
      ),
      body: _screens[_currentIndex], // Показываем текущий экран
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Текущий индекс
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Переключаем экран
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'События',
          ),
        ],
      ),
    );
  }
}
