/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import '../widgets/segment_widget.dart';

class SurveyQuestionScreen extends StatefulWidget {
  const SurveyQuestionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SurveyQuestionScreenState createState() => _SurveyQuestionScreenState();
}

class _SurveyQuestionScreenState extends State<SurveyQuestionScreen> {
  int currentSegment = 1;

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final questions = surveyProvider.questions != null
        ? surveyProvider.questions
            .where((q) => q.segmentId == currentSegment)
            .toList()
        : [];

    return Scaffold(
      appBar: AppBar(title: Text('Survey Questions')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return SegmentWidget(question: questions[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentSegment > 1)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentSegment--;
                    });
                  },
                  child: Text('Previous'),
                ),
              if (currentSegment < 4)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentSegment++;
                    });
                  },
                  child: Text('Next'),
                ),
              if (currentSegment == 4)
                ElevatedButton(
                  onPressed: () {
                    // Handle submit
                  },
                  child: Text('Submit'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on SurveyProvider {
  get questions => null;
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../state_management/survey_provider.dart';
import '../widgets/segment_widget.dart';

class SurveyQuestionScreen extends StatefulWidget {
  const SurveyQuestionScreen({super.key});

  @override
  _SurveyQuestionScreenState createState() => _SurveyQuestionScreenState();
}

class _SurveyQuestionScreenState extends State<SurveyQuestionScreen> {
  int currentSegment = 1;

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final questions = surveyProvider.questions != null
        ? surveyProvider.questions
            .where((q) => q.segmentId == currentSegment)
            .toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Survey Questions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.green.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return FadeInUp(
                    duration: Duration(milliseconds: 500),
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SegmentWidget(question: questions[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentSegment > 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          currentSegment--;
                        });
                      },
                      child: const Text('Previous'),
                    ),
                  if (currentSegment < 4)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          currentSegment++;
                        });
                      },
                      child: const Text('Next'),
                    ),
                  if (currentSegment == 4)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Handle submit
                      },
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
