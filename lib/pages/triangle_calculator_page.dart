import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TriangleCalculatorPage extends StatefulWidget {
  final String type;
  const TriangleCalculatorPage({super.key, required this.type});

  @override
  State<TriangleCalculatorPage> createState() => _TriangleCalculatorPageState();
}

class _TriangleCalculatorPageState extends State<TriangleCalculatorPage> {
  late TextEditingController _baseController,
      _heightController,
      _bodyHeightController,
      _sideAController,
      _sideBController,
      _sideCController,
      _areaController,
      _perimeterController;
  late Map<String, List<Map<String, dynamic>>> widgetList = {
    'Right': [
      {
        'label': 'Body Height',
        'textfield': _textField(_bodyHeightController, false),
      },
      {
        'label': 'Base Height',
        'textfield': _textField(_heightController, false),
      },
      {
        'label': 'Base Width',
        'textfield': _textField(_baseController, false),
      },
    ],
    'Cube': [
      {
        'label': 'Side',
        'textfield': _textField(_baseController, false),
      }
    ]
  };

  late Map<String, Function()> returnFunction = {
    'Right': trapesiumCalculator,
    'Cube': rightTriangle,
  };

  @override
  void initState() {
    super.initState();
    _baseController = TextEditingController();
    _heightController = TextEditingController();
    _bodyHeightController = TextEditingController();
    _areaController = TextEditingController();
    _perimeterController = TextEditingController();
    _sideAController = TextEditingController();
    _sideBController = TextEditingController();
    _sideCController = TextEditingController();
  }

  @override
  void dispose() {
    _baseController.dispose();
    _heightController.dispose();
    _bodyHeightController.dispose();
    _areaController.dispose();
    _perimeterController.dispose();
    _sideAController.dispose();
    _sideBController.dispose();
    _sideCController.dispose();
    super.dispose();
  }

  void calculateResult() {
    try {
      Map<String, String> result = returnFunction[widget.type]!();
      setState(() {
        _areaController.text = result['area']!;
        _perimeterController.text = result['perimeter']!;
      });
    } catch (error) {
      SnackBar snackbar = SnackBar(
        content: Text(
          error.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  void resetDigit() {
    setState(() {
      _bodyHeightController.text = '';
      _heightController.text = '';
      _baseController.text = '';
      _areaController.text = '';
      _perimeterController.text = '';
      _sideAController.text = '';
      _sideBController.text = '';
      _sideCController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(
              'Calculator',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Input',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    _inputList(),
                    const SizedBox(height: 15),
                    _calculateButton(),
                    const SizedBox(height: 30),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Result',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    _outputList(),
                    const SizedBox(height: 15),
                    _resetButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _inputList() {
    return Table(
      columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: widgetList[widget.type]!.map<TableRow>((item) {
        return _tableRow(item['label'] as String, item['textfield']);
      }).toList(),
    );
  }

  Widget _outputList() {
    return Table(
      columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const TableCell(
              child: Text(
                'Volume',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TableCell(child: _textField(_areaController, true)),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Text(
                'Perimeter',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TableCell(child: _textField(_perimeterController, true)),
          ],
        ),
      ],
    );
  }

  TableRow _tableRow(String label, dynamic textfield) {
    return TableRow(
      children: [
        TableCell(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        TableCell(child: textfield),
      ],
    );
  }

  Widget _textField(TextEditingController controller, bool readOnly) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 7.5, bottom: 7.5),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        onTapOutside: (event) {
          if (controller.text.endsWith('.')) {
            setState(() {
              controller.text = '${controller.text}0';
            });
          }
          if (controller.text.startsWith('.')) {
            setState(() {
              controller.text = '0${controller.text}';
            });
          }
        },
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        onChanged: (value) {},
      ),
    );
  }

  Map<String, String> rightTriangle() {
    if (_baseController.text.isEmpty) {
      _baseController.text = '0';
    }
    if (_heightController.text.isEmpty) {
      _heightController.text = '0';
    }
    double cubeSide = double.parse(_baseController.text);

    String perimeter = (cubeSide*cubeSide*cubeSide).toString();
    String area = ((cubeSide*cubeSide)*6).toString(); 
    return {
      'perimeter': perimeter,
      'area': area,
    };
  }

  Map<String, String> trapesiumCalculator() {
    if (_baseController.text.isEmpty) {
      _baseController.text = '0';
    }
    if (_sideAController.text.isEmpty) {
      _sideAController.text = '0';
    }
    double tSide = double.parse(_sideAController.text);
    double tBase = double.parse(_baseController.text);
    if (tSide > double.maxFinite || tBase > double.maxFinite) {
      throw Exception(
          'Input exceeds maximum allowed value (${double.maxFinite}).');
    }
    if (tBase > 2 * tSide) {
      throw Exception('Invalid triangle!');
    }
    double tHeight = sqrt(pow(tSide, 2) - pow(tBase / 2, 2));
    String perimeter = (2 * tSide + tBase).toString();
    String area = (0.5 * tBase * tHeight).toString();
    return {
      'perimeter': perimeter,
      'area': area,
    };
  }

  Map<String, String> cubeVolume() {
    if (_baseController.text.isEmpty) {
      _baseController.text = '0';
    }
    double cubeSide = double.parse(_baseController.text);
    if (cubeSide > double.maxFinite) {
      throw Exception(
          'Input exceeds maximum allowed value (${double.maxFinite}).');
    }
    double perimeter = (6*(cubeSide*cubeSide));
    double volume = cubeSide * cubeSide * cubeSide;
    return {
      'perimeter': perimeter.toString(),
      'volume': volume.toString(),
    };
  }

  Widget _calculateButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          calculateResult();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(15),
        ),
        child: const Text(
          'Calculate',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _resetButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: () {
          resetDigit();
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
          'Reset',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
