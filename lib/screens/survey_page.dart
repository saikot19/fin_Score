import 'package:flutter/material.dart';
import '../models/survey_segment.dart';
import '../widgets/question_widget.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int _currentSegment = 0;

  final List<SurveySegment> _surveySegments = [
    SurveySegment(
      title: 'Personal Demography',
      questions: [
        {
          'question': 'আপনার বয়সের পরিসর কী?',
          'options': ['১৮-২৫', '২৬-৩৫', '৩৬-৫০', '৫০+']
        },
        {
          'question': 'আপনার লিঙ্গ কী?',
          'options': ['পুরুষ', 'মহিলা', 'অন্যান্য']
        },
      ],
    ),
    SurveySegment(
      title: 'Business Demography',
      questions: [
        {
          'question': 'আপনার কি কোনো ব্যবসা রয়েছে?',
          'options': ['হ্যাঁ', 'না']
        },
        {
          'question': 'আপনার ব্যবসার আকার কী?',
          'options': ['ছোট', 'মাঝারি', 'বড়']
        },
      ],
    ),
    SurveySegment(
      title: 'Assets',
      questions: [
        {
          'question': 'আপনার কি কোনো স্থাবর সম্পত্তি রয়েছে?',
          'options': ['হ্যাঁ', 'না']
        },
        {
          'question': 'আপনার কি কোনো যানবাহন রয়েছে?',
          'options': ['হ্যাঁ', 'না']
        },
      ],
    ),
    SurveySegment(
      title: 'Financial Demography',
      questions: [
        {
          'question': 'আপনার বার্ষিক আয়ের পরিসর কী?',
          'options': ['< \$১০,০০০', '\$১০,০০০-\$৫০,০০০', '> \$৫০,০০০']
        },
        {
          'question': 'আপনার কি কোনো বিদ্যমান ঋণ রয়েছে?',
          'options': ['হ্যাঁ', 'না']
        },
      ],
    ),
  ];

  final Map<int, Map<String, String>> _responses = {};

  @override
  Widget build(BuildContext context) {
    final segment = _surveySegments[_currentSegment];

    return Scaffold(
      appBar: AppBar(title: Text(segment.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: segment.questions.length,
              itemBuilder: (context, index) {
                final question = segment.questions[index];
                return QuestionWidget(
                  question: question['question'],
                  options: question['options'],
                  selectedOption: _responses[_currentSegment]
                      ?[question['question']],
                  onChanged: (value) {
                    setState(() {
                      _responses[_currentSegment] ??= {};
                      _responses[_currentSegment]![question['question']] =
                          value!;
                    });
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentSegment > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentSegment--;
                    });
                  },
                  child: Text('Previous'),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_currentSegment < _surveySegments.length - 1) {
                    setState(() {
                      _currentSegment++;
                    });
                  } else {
                    print('Survey responses: $_responses');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Survey Complete'),
                        content: Text('Thank you for completing the survey!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(_currentSegment < _surveySegments.length - 1
                    ? 'Next'
                    : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
