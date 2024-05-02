import 'package:flutter/material.dart';
import 'triangle_calculator_page.dart';
import '../widgets/menu_item_widgets.dart';

class TriangleMenuPage extends StatefulWidget {
  const TriangleMenuPage({super.key});

  @override
  State<TriangleMenuPage> createState() => _TriangleMenuPageState();
}

class _TriangleMenuPageState extends State<TriangleMenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'Choose Triangle Type',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: Center(
          child: _menuList(),
        ),
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
                'Trapesium',
                'A triangle that has at least one 90° angle.',
                const TriangleCalculatorPage(type: 'Right'),
              ),
              menuItem(
                context,
                'Cube',
                'A triangle that has at least one 90° angle.',
                const TriangleCalculatorPage(type: 'Scalene'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
