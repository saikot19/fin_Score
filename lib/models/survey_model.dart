class SurveyQuestion {
  final int id;
  final String questionName;
  final String questionNameEng;
  final int segmentId;
  final int? dependency;
  final String weightInPer;
  final double weightInNum;
  final int? questionId;
  final int? answerId;
  final int status;
  final List<SurveyAnswer> answers;

  SurveyQuestion({
    required this.id,
    required this.questionName,
    required this.questionNameEng,
    required this.segmentId,
    this.dependency,
    required this.weightInPer,
    required this.weightInNum,
    this.questionId,
    this.answerId,
    required this.status,
    required this.answers,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'],
      questionName: json['question_name'],
      questionNameEng: json['question_name_eng'],
      segmentId: json['segment_id'],
      dependency: json['dependency'],
      weightInPer: json['weight_in_per'],
      weightInNum: double.parse(json['weight_in_num'].toString()),
      questionId: json['question_id'],
      answerId: json['answer_id'],
      status: json['status'],
      answers: (json['answers'] as List)
          .map((answerJson) => SurveyAnswer.fromJson(answerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_name': questionName,
      'question_name_eng': questionNameEng,
      'segment_id': segmentId,
      'dependency': dependency,
      'weight_in_per': weightInPer,
      'weight_in_num': weightInNum,
      'question_id': questionId,
      'answer_id': answerId,
      'status': status,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class SurveyAnswer {
  final int id;
  final String answerBangla;
  final String answerEnglish;
  final int questionId;
  final String? linkedQuestions;
  final String mark;
  final double score;

  SurveyAnswer({
    required this.id,
    required this.answerBangla,
    required this.answerEnglish,
    required this.questionId,
    this.linkedQuestions,
    required this.mark,
    required this.score,
  });

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) {
    return SurveyAnswer(
      id: json['id'],
      answerBangla: json['answer_bangla'],
      answerEnglish: json['answer_english'],
      questionId: json['question_id'],
      linkedQuestions: json['linked_questions'],
      mark: json['mark'],
      score: double.parse(json['score'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_bangla': answerBangla,
      'answer_english': answerEnglish,
      'question_id': questionId,
      'linked_questions': linkedQuestions,
      'mark': mark,
      'score': score,
    };
  }
}
