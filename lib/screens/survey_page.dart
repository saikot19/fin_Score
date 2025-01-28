import 'package:flutter/material.dart';
import '../models/survey_segment.dart';
import '../widgets/question_widget.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int _currentSegment = 0;

  final List<SurveySegment> _surveySegments = [
    SurveySegment(
      title: 'Personal Demography',
      questions: [
        {
          'question': 'What is your age group?',
          'options': ['18-25', '26-35', '36-50', '50+']
        },
        {
          'question': 'What is your gender?',
          'options': ['Male', 'Female', 'Other']
        },
        {
          'question': 'What is your marital status?',
          'options': ['Single', 'Married', 'Divorced']
        },
        {
          'question': 'What is your highest education level?',
          'options': ['High School', 'Bachelor', 'Master', 'PhD']
        },
        {
          'question': 'Do you have dependents?',
          'options': ['Yes', 'No']
        },
      ],
    ),
    SurveySegment(
      title: 'Business Demography',
      questions: [
        {
          'question': 'Do you own a business?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'What is the size of your business?',
          'options': ['Small', 'Medium', 'Large']
        },
        {
          'question': 'How many employees do you have?',
          'options': ['1-5', '6-20', '21-50', '50+']
        },
        {
          'question': 'What is your business sector?',
          'options': ['IT', 'Retail', 'Manufacturing', 'Other']
        },
        {
          'question': 'Do you have a business partner?',
          'options': ['Yes', 'No']
        },
      ],
    ),
    SurveySegment(
      title: 'Assets',
      questions: [
        {
          'question': 'Do you own any real estate?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you own any vehicles?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you have investments?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you own any machinery?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you own valuable collectibles?',
          'options': ['Yes', 'No']
        },
      ],
    ),
    SurveySegment(
      title: 'Financial Demography',
      questions: [
        {
          'question': 'What is your annual income range?',
          'options': ['< \$10,000', '\$10,000-\$50,000', '>\$50,000']
        },
        {
          'question': 'Do you have any existing loans?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you have a credit card?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you save monthly?',
          'options': ['Yes', 'No']
        },
        {
          'question': 'Do you have insurance?',
          'options': ['Yes', 'No']
        },
      ],
    ),
  ];

  final Map<int, Map<String, String>> _responses = {};

  void _submitSurvey() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Survey Submitted', style: TextStyle(color: Colors.green)),
        content: Text('Thank you for completing the survey!',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 2, 11, 51),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final segment = _surveySegments[_currentSegment];

    return Scaffold(
      appBar: AppBar(
        title: Text(segment.title),
        backgroundColor: Colors.green,
      ),
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
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      _currentSegment--;
                    });
                  },
                  child: Text('Previous'),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  if (_currentSegment < _surveySegments.length - 1) {
                    setState(() {
                      _currentSegment++;
                    });
                  } else {
                    _submitSurvey();
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
