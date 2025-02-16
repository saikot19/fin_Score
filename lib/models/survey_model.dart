class Question {
  final int id;
  final String questionName;
  final String questionNameEng;
  final int segmentId;
  final int dependency;
  final double weightInPer;
  final double weightInNum;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionName,
    required this.questionNameEng,
    required this.segmentId,
    required this.dependency,
    required this.weightInPer,
    required this.weightInNum,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionName: json['question_name'] ?? 'Unknown',
      questionNameEng: json['question_name_eng'] ?? 'Unknown',
      segmentId: json['segment_id'] ?? 0,
      dependency: json['dependency'] ?? 0,
      weightInPer: double.tryParse(json['weight_in_per'].toString()) ?? 0.0,
      weightInNum: double.tryParse(json['weight_in_num'].toString()) ?? 0.0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((answer) => Answer.fromJson(answer))
              .toList() ??
          [],
    );
  }
}

class Answer {
  final int id;
  final String answerBangla;
  final String answerEnglish;
  final int questionId;
  final double mark;
  final double score;

  Answer({
    required this.id,
    required this.answerBangla,
    required this.answerEnglish,
    required this.questionId,
    required this.mark,
    required this.score,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] ?? 0,
      answerBangla: json['answer_bangla'] ?? 'Unknown',
      answerEnglish: json['answer_english'] ?? 'Unknown',
      questionId: json['question_id'] ?? 0,
      mark: double.tryParse(json['mark'].toString()) ?? 0.0,
      score: double.tryParse(json['score'].toString()) ?? 0.0,
    );
  }
}

class Survey {
  final int memberId;
  final int branchId;
  final double appliedLoanAmount;
  final String startDate;
  final Map<int, int> responses; // Key: questionId, Value: answerId
  final double totalScore; // Added total score tracking

  Survey({
    required this.memberId,
    required this.branchId,
    required this.appliedLoanAmount,
    required this.startDate,
    required this.responses,
    required this.totalScore,
  });

  // Convert Survey object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'member_id': memberId,
      'branch_id': branchId,
      'applied_loan_amount': appliedLoanAmount,
      'start_date': startDate,
      'responses': responses,
      'total_score': totalScore,
    };
  }

  // Create a Survey object from a JSON map
  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      memberId: json['member_id'],
      branchId: json['branch_id'],
      appliedLoanAmount: json['applied_loan_amount'],
      startDate: json['start_date'],
      responses: Map<int, int>.from(json['responses']),
      totalScore: json['total_score'] ?? 0.0,
    );
  }
}
