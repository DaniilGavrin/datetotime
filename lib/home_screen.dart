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
                  MediaQuery.of(context).size.width * 0.8,
                  MediaQuery.of(context).size.width * 0.8,
                ),
                painter: ClockPainter(currentDay, lastDay),
              ),
              Positioned(
                child: Text(
                  '${progress.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paintCircle = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint paintArrow = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Draw outer circle
    canvas.drawCircle(center, radius, paintCircle);

    // Draw day numbers
    final double angleStep = 2 * pi / lastDay;
    final double numberRadius = radius - 20;
    for (int i = 1; i <= lastDay; i++) {
      double angle = angleStep * (i - 1);
      double x = center.dx + numberRadius * cos(angle - pi / 2);
      double y = center.dy + numberRadius * sin(angle - pi / 2);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            fontSize: 14,
            color: i <= currentDay ? Colors.grey : Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw progress arrow
    final double progressAngle = (currentDay / lastDay) * 2 * pi - pi / 2;
    final double arrowLength = radius - 30;
    canvas.drawLine(
      center,
      Offset(
        center.dx + arrowLength * cos(progressAngle),
        center.dy + arrowLength * sin(progressAngle),
      ),
      paintArrow,
    );
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return currentDay != oldDelegate.currentDay || lastDay != oldDelegate.lastDay;
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    HomeScreen(), // Main screen
    EventScreen(), // Events screen
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date to Time'),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Добавить событие'),
                      content: Text('Форма для добавления события.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Закрыть'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Список событий!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: MainScreen(),
  ));
}
