import 'dart:convert'; // Import the dart:convert library for JSON encoding
import 'package:finscore/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import '../services/api_service.dart';
import '../screens/score_summary_screen.dart';
import '../screens/survey_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class SurveyScreen extends StatefulWidget {
  final String memberId;
  final String memberName;
  final int branchId;
  final double loanAmount;
  final String loanDate;
  final int initialSegmentId;

  const SurveyScreen({
    Key? key,
    required this.memberId,
    required this.memberName,
    required this.branchId,
    required this.loanAmount,
    required this.loanDate,
    required this.initialSegmentId,
  }) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late int currentSegment;

  final Map<int, String> segmentNames = {
    1: "Personal & Demographic",
    2: "Business Demographics",
    3: "Asset",
    4: "Financial",
  };

  @override
  void initState() {
    super.initState();
    currentSegment = widget.initialSegmentId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSurveyProgress();
    });
  }

  List<Question> _filterQuestions(
      List<Question> questions, Map<int, String> responses) {
    List<Question> filteredQuestions = [];
    for (var question in questions) {
      if (question.dependency == 1) {
        filteredQuestions.add(question);
      } else if (question.dependency == 2 && question.linkedQuestion != null) {
        if (responses.containsKey(question.linkedQuestion) &&
            responses[question.linkedQuestion] != null) {
          filteredQuestions.add(question);
        }
      }
    }
    return filteredQuestions;
  }

  void _handleAnswerSelected(
      int questionId, String selectedOption, SurveyProvider surveyProvider) {
    surveyProvider.selectAnswer(questionId, selectedOption);
    final question =
        surveyProvider.questions.firstWhere((q) => q.id == questionId);
    final selectedAnswer =
        question.answers.firstWhere((a) => a.answerBangla == selectedOption);

    if (selectedAnswer.linkedQuestions != null &&
        selectedAnswer.linkedQuestions!.isNotEmpty) {
      for (var linkedQuestionId in selectedAnswer.linkedQuestions!) {
        surveyProvider.fetchLinkedQuestion(linkedQuestionId);
      }
    }

    setState(() {});
  }

  Future<void> _submitSurvey(SurveyProvider surveyProvider) async {
    await surveyProvider.submitSurvey(
      widget.memberId,
      widget.memberName,
      widget.loanAmount,
      widget.loanDate,
      widget.loanDate,
    );

    if (!surveyProvider.hasIncompleteSurvey) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ScoreSummaryScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to submit survey. Please try again.")),
      );
    }
  }

  Future<void> _loadSurveyProgress() async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    await surveyProvider.loadIncompleteSurvey();

    if (surveyProvider.hasIncompleteSurvey) {
      setState(() {
        currentSegment = 1; // Start from the first segment
      });
    } else {
      surveyProvider.fetchSurveyQuestions(currentSegment);
    }
  }

  Future<bool> _showExitConfirmationDialog(
      SurveyProvider surveyProvider) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit Survey"),
          content: const Text(
              "Do you want to exit the survey? Your progress will be cleared."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await surveyProvider.clearIncompleteSurvey();
                surveyProvider.clearResponses(); // Clear form responses
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final segmentQuestions = surveyProvider.questions
        .where((q) => q.segmentId == currentSegment)
        .toList();
    final filteredQuestions =
        _filterQuestions(segmentQuestions, surveyProvider.responses);

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(surveyProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(segmentNames[currentSegment]!),
          backgroundColor: const Color(0xFF01102B),
        ),
        body: surveyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SurveyTracker(
                    currentSegment: currentSegment,
                    totalSegments: segmentNames.length,
                    segmentNames: segmentNames,
                  ),
                  Expanded(
                    child: filteredQuestions.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredQuestions.length,
                            itemBuilder: (context, index) {
                              final question = filteredQuestions[index];
                              int questionNumber = index + 1;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  QuestionWidget(
                                    question: question,
                                    questionNumber: questionNumber.toString(),
                                    selectedAnswer:
                                        surveyProvider.responses[question.id],
                                    onAnswerSelected: (selectedOption) {
                                      _handleAnswerSelected(question.id,
                                          selectedOption, surveyProvider);
                                    },
                                  ),
                                  if (surveyProvider.responses
                                      .containsKey(question.id))
                                    ...question.answers
                                        .where((answer) =>
                                            answer.answerBangla ==
                                            surveyProvider
                                                .responses[question.id])
                                        .expand((answer) =>
                                            answer.linkedQuestions ?? [])
                                        .map((linkedQuestionId) {
                                      final linkedQuestion =
                                          surveyProvider.questions.firstWhere(
                                              (q) => q.id == linkedQuestionId);
                                      final subQuestionNumber =
                                          '$questionNumber.${linkedQuestion.id}';
                                      return QuestionWidget(
                                        question: linkedQuestion,
                                        questionNumber: subQuestionNumber,
                                        selectedAnswer: surveyProvider
                                            .responses[linkedQuestion.id],
                                        onAnswerSelected: (selectedOption) {
                                          _handleAnswerSelected(
                                              linkedQuestion.id,
                                              selectedOption,
                                              surveyProvider);
                                        },
                                      );
                                    }).toList(),
                                ],
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "No questions available for this segment.",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentSegment > 1)
                          ElevatedButton.icon(
                              onPressed: () async {
                                await surveyProvider.saveIncompleteSurvey();
                                setState(() {
                                  currentSegment--;
                                });
                                surveyProvider
                                    .fetchSurveyQuestions(currentSegment);
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              label: const Text(
                                "Previous",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF004d00), // Dark green
                              )),
                        if (currentSegment < 4)
                          ElevatedButton.icon(
                            onPressed: () {
                              if (filteredQuestions.any((q) => !surveyProvider
                                  .responses
                                  .containsKey(q.id))) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please answer all questions before proceeding.")),
                                );
                                return;
                              }
                              surveyProvider.saveIncompleteSurvey();
                              setState(() {
                                currentSegment++;
                              });
                              surveyProvider
                                  .fetchSurveyQuestions(currentSegment);
                            },
                            icon: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                            label: const Text("Next",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF004d00), // Dark green
                            ),
                          ),
                        if (currentSegment == 4)
                          ElevatedButton.icon(
                            onPressed: () {
                              if (filteredQuestions.any((q) => !surveyProvider
                                  .responses
                                  .containsKey(q.id))) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please answer all questions before submitting.")),
                                );
                                return;
                              }
                              _submitSurvey(surveyProvider);
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("Submit",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF004d00), // Dark green
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final Question question;
  final String questionNumber;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 209, 238, 216),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$questionNumber. ${question.questionName}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Column(
              children: question.answers.map((answer) {
                return ListTile(
                  title: Text(
                    answer.answerBangla,
                    style: const TextStyle(color: Colors.black),
                  ),
                  leading: Radio<String>(
                    value: answer.answerBangla,
                    groupValue: selectedAnswer,
                    activeColor: const Color.fromARGB(255, 4, 14, 4),
                    // Change this to Colors.green if you prefer dark green
                    onChanged: (value) {
                      if (value != null) {
                        onAnswerSelected(value);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
