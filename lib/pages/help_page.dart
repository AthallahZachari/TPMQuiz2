import 'package:flutter/material.dart';
import 'package:tpm_kelompok/data/help_data.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<HelpItem> _data = helpList;

  @override
  Widget build(BuildContext context) {
    return _buildPanel();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((HelpItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.title!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          },
          body: Column(
            children: [
              ListTile(
                title: Text(
                  item.description!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
