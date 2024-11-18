import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentDay = _currentDateTime.day;
    int lastDay = DateTime(_currentDateTime.year, _currentDateTime.month + 1, 0).day;
    double progress = (currentDay / lastDay) * 100;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width * 0.9, // 90% ширины экрана
                  MediaQuery.of(context).size.height * 0.5, // 50% высоты экрана
                ),
                painter: ClockPainter(currentDay, lastDay),
              ),
              Positioned(
                child: Text(
                  '${progress.toStringAsFixed(1)}%',  // Процент прогресса месяца
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int currentDay;
  final int lastDay;

  ClockPainter(this.currentDay, this.lastDay);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Рисуем круг
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // Рисуем цифры по кругу
    double angleStep = 2 * pi / lastDay;
    for (int i = 1; i <= lastDay; i++) {
      double angle = angleStep * (i - 1);
      double x = size.width / 2 + (size.width / 2 - 20) * cos(angle);
      double y = size.height / 2 + (size.height / 2 - 20) * sin(angle);

      // Определяем цвет цифры
      Color numberColor = (i <= currentDay) ? Colors.grey : Colors.white;

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(fontSize: 16, color: numberColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Рисуем стрелку, которая указывает на текущий день
    double angle = (currentDay / lastDay) * 2 * pi; // Угол для стрелки
    paint.color = Colors.blue;
    paint.strokeWidth = 6;
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(size.width / 2 + (size.width / 2 - 20) * cos(angle),
             size.height / 2 + (size.height / 2 - 20) * sin(angle)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Список экранов, которые будут переключаться
  final List<Widget> _screens = [
    HomeScreen(),  // Главный экран с часами
    EventScreen(), // Экран для событий
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
        type: BottomNavigationBarType.fixed, // Для фиксированных кнопок
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
          // Разделитель между кнопками
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'События',
          ),
        ],
      ),
    );
  }
}

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
