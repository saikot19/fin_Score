import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selectedOption;
  final Function(String?) onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            items: options
                .map<DropdownMenuItem<String>>((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: onChanged,
            value: selectedOption,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select an option',
            ),
          ),
        ],
      ),
    );
  }
}
