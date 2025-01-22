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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            dropdownColor: Colors.black,
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child:
                          Text(option, style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: onChanged,
            value: selectedOption,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
