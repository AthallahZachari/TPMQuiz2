import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tpm_kelompok/pages/triangle_calculator_page.dart';
import '../widgets/menu_item_widgets.dart';
import 'help_page.dart';
import 'login_page.dart';
import 'team_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetStorage checkLogin = GetStorage('checkLogin');
  int currentPageIndex = 0;

  final Stopwatch _stopwatch = Stopwatch();
  final Stopwatch _stopwatchLap = Stopwatch();
  late ValueNotifier<String> _elapsedTime;
  late ValueNotifier<String> _elapsedLaps;
  List<String> laps = [];
  List<String> overallLaps = [];
  Duration lastDuration =
      const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0);
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    _elapsedTime = ValueNotifier<String>('00:00:00.00');
    _elapsedLaps = ValueNotifier<String>('00:00:00.00');
  }

  @override
  void dispose() {
    _stopStopwatch();
    _elapsedLaps.dispose();
    _elapsedTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String username = checkLogin.read('username');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 64,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 42,
                  color: Color(0xFF00458B),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Welcome, $username!',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Try out our features.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          elevation: 0,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: const Color(0xFF00458B),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home_sharp,
                color: Colors.white,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.timer_rounded,
                color: Colors.white,
              ),
              icon: Icon(Icons.timer_outlined),
              label: 'Stopwatch',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.help_outlined,
                color: Colors.white,
              ),
              icon: Icon(Icons.help_outline_outlined),
              label: 'Help',
            ),
          ],
        ),
        body: currentPageIndex == 0
            ? _menuList()
            : currentPageIndex == 1
                ? _stopwatchDisplay()
                : _helpDisplay(),
      ),
    );
  }

  Widget _menuList() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              menuItem(
                context,
                'Kalkulator Trapesium',
                'Menghitung luas dan keliling bangun ruang Trapesium.',
                const TriangleCalculatorPage(type: 'Right'),
              ),
              menuItem(
                context,
                'Kalkulator Kubus',
                'Menghitung luas dan keliling bangun ruang Kubus.',
                const TriangleCalculatorPage(type: 'Cube'),
              ),
              menuItem(
                context,
                'Data Diri',
                'Biodata pembuat.',
                const TeamPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stopwatchDisplay() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return width < height
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                _mainTimeDisplay(),
                _lapTimeDisplay(),
                const SizedBox(height: 35),
                _lapList(),
                const SizedBox(height: 15),
                _buttonGroup(),
                const SizedBox(height: 30),
              ],
            ),
          )
        : Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _mainTimeDisplay(),
                    _lapTimeDisplay(),
                    const SizedBox(height: 20),
                    _buttonGroup()
                  ],
                ),
                _lapList(),
              ],
            ),
          );
  }

  Widget _buttonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stopwatchButton('Stop/Start'),
        const SizedBox(width: 20),
        _stopwatchButton('Lap'),
        const SizedBox(width: 20),
        _stopwatchButton('Reset'),
      ],
    );
  }

  Widget _mainTimeDisplay() {
    return ValueListenableBuilder<String>(
      valueListenable: _elapsedTime,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _timeContainer(value.substring(0, 2), 48, Colors.black, 70, 68),
            const Text(':', style: TextStyle(fontSize: 48)),
            _timeContainer(value.substring(3, 5), 48, Colors.black, 70, 68),
            const Text(':', style: TextStyle(fontSize: 48)),
            _timeContainer(value.substring(6, 8), 48, Colors.black, 70, 68),
            const Text('.', style: TextStyle(fontSize: 48)),
            _timeContainer(value.substring(9), 48, Colors.black, 70, 68),
          ],
        );
      },
    );
  }

  Widget _lapTimeDisplay() {
    return laps.isNotEmpty
        ? ValueListenableBuilder<String>(
            valueListenable: _elapsedLaps,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _timeContainer(
                      value.substring(0, 2), 24, Colors.grey.shade600, 40, 33),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  _timeContainer(
                      value.substring(3, 5), 24, Colors.grey.shade600, 40, 33),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  _timeContainer(
                      value.substring(6, 8), 24, Colors.grey.shade600, 40, 33),
                  Text(
                    '.',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  _timeContainer(
                      value.substring(9), 24, Colors.grey.shade600, 40, 33),
                ],
              );
            },
          )
        : Container();
  }

  Widget _stopwatchButton(String text) {
    bool isEnabled = false;
    String buttonText = '';

    switch (text) {
      case 'Lap':
        isEnabled = isStart;
        buttonText = text;
        break;
      case 'Stop/Start':
        isEnabled = true;
        buttonText = isStart ? 'Stop' : 'Start';
        break;
      default:
        isEnabled = !isStart;
        buttonText = text;
    }

    return ElevatedButton(
      onPressed: isEnabled ? () => _onButtonPressed(text) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00458B),
        foregroundColor: Colors.white,
      ),
      child: Text(buttonText),
    );
  }

  void _onButtonPressed(String text) {
    switch (text) {
      case 'Lap':
        if (isStart) {
          _lapStopwatch();
        }
        break;
      case 'Stop/Start':
        if (isStart) {
          _stopStopwatch();
        } else {
          _startStopwatch();
        }
        break;
      default:
        _resetStopwatch();
    }
  }

  Widget _timeContainer(
      String time, double size, Color color, double width, double height) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Text(
        time,
        style: TextStyle(fontSize: size, color: color),
      ),
    );
  }

  void _startLap() {
    _stopwatchLap.start();
    Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      if (!_stopwatchLap.isRunning) {
        timer.cancel();
      } else {
        final elapsedLap = _formatTime(_stopwatchLap.elapsed);
        _elapsedLaps.value = elapsedLap;
      }
    });
  }

  void _lapStopwatch() {
    _stopwatchLap.reset();
    _startLap();
    final Duration now = _stopwatch.elapsed;
    setState(() {
      laps.add(_formatTime(now - lastDuration));
      overallLaps.add(_formatTime(now));
      lastDuration = now;
    });
  }

  void _startStopwatch() {
    setState(() {
      isStart = true;
    });
    _stopwatch.start();
    if (laps.isNotEmpty) {
      _startLap();
    }
    Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      if (!_stopwatch.isRunning) {
        timer.cancel();
      } else {
        final elapsedTime = _formatTime(_stopwatch.elapsed);
        _elapsedTime.value = elapsedTime;
      }
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _stopwatchLap.stop();
    setState(() {
      isStart = false;
    });
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime.value = '00:00:00.00';
      _elapsedLaps.value = '00:00:00.00';
      laps.clear();
      overallLaps.clear();
      lastDuration =
          const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0);
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds';
  }

  Widget _lapList() {
    return laps.isNotEmpty
        ? Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                child: SingleChildScrollView(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(35),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Text(
                                'Lap',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                'Lap times',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                'Overall Time',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const TableRow(
                        children: [
                          TableCell(
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          TableCell(
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          TableCell(
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(laps.length, (index) => index)
                          .reversed
                          .map(
                            (index) => TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        (index + 1).toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Center(
                                      child: Text(laps[index]),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(overallLaps[index]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _helpDisplay() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Help',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Click on each menu to see guides.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const HelpPage(),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                checkLogin.write('isLoggedIn', false);
                checkLogin.write('username', '');
                return const LoginPage();
              },
            ),
          );
        },
        style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.grey.shade600,
            side: BorderSide(color: Colors.grey.shade600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(15)),
        child: const Text(
          'Logout',
        ),
      ),
    );
  }
}
