import 'package:finscore/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import '../services/api_service.dart';
import '../screens/score_summary_screen.dart';
import '../screens/survey_tracker.dart';

class SurveyScreen extends StatefulWidget {
  final String memberId;
  final int branchId;
  final double loanAmount;
  final String loanDate;
  final int initialSegmentId;

  const SurveyScreen({
    Key? key,
    required this.memberId,
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
      Provider.of<SurveyProvider>(context, listen: false)
          .fetchSurveyQuestions(currentSegment);
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
    int totalScore = surveyProvider.calculateTotalScore();
    Map<String, dynamic> surveyResponse = {
      "member_id": widget.memberId,
      "branch_id": widget.branchId,
      "applied_loan_amount": widget.loanAmount,
      "check": true,
      "questions": surveyProvider.responses.entries.map((entry) {
        final question =
            surveyProvider.questions.firstWhere((q) => q.id == entry.key);
        final answer =
            question.answers.firstWhere((a) => a.answerBangla == entry.value);
        return {
          "question_id": question.id,
          "answer_id": answer.id,
        };
      }).toList(),
    };

    // Log survey response
    debugPrint("Survey Response:");
    debugPrint(surveyResponse.toString());

    // Send survey response to server
    final apiService = ApiService();
    bool success = await apiService.storeSurvey(surveyResponse);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreSummaryScreen(
            totalScore: totalScore,
            responses: surveyProvider.responses
                .map((key, value) => MapEntry(key, int.parse(value))),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to submit survey. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final segmentQuestions = surveyProvider.questions
        .where((q) => q.segmentId == currentSegment)
        .toList();
    final filteredQuestions =
        _filterQuestions(segmentQuestions, surveyProvider.responses);

    return Scaffold(
      appBar: AppBar(
        title: Text(segmentNames[currentSegment]!),
      ),
      body: surveyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SurveyTracker(
                  currentSegment: currentSegment,
                  totalSegments: segmentNames.length,
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
                                          surveyProvider.responses[question.id])
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
                                        _handleAnswerSelected(linkedQuestion.id,
                                            selectedOption, surveyProvider);
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
                          onPressed: () {
                            setState(() {
                              currentSegment--;
                            });
                            surveyProvider.fetchSurveyQuestions(currentSegment);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Previous"),
                        ),
                      if (currentSegment < 4)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              currentSegment++;
                            });
                            surveyProvider.fetchSurveyQuestions(currentSegment);
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next"),
                        ),
                      if (currentSegment == 4)
                        ElevatedButton.icon(
                          onPressed: () => _submitSurvey(surveyProvider),
                          icon: const Icon(Icons.check),
                          label: const Text("Submit"),
                        ),
                    ],
                  ),
                ),
              ],
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
      color: const Color.fromARGB(255, 153, 182, 160),
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
