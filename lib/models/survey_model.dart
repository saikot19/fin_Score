class Answer {
  final int id;
  final String answerBangla;

  final int questionId;
  final String? linkedQuestions;
  final double mark;
  final double score;

  Answer({
    required this.id,
    required this.answerBangla,
    required this.questionId,
    this.linkedQuestions,
    required this.mark,
    required this.score,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerBangla: json['answer_bangla'],
      questionId: json['question_id'],
      linkedQuestions: json['linked_questions'],
      mark: double.parse(json['mark']),
      score: json['score'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_bangla': answerBangla,
      'question_id': questionId,
      'linked_questions': linkedQuestions,
      'mark': mark.toString(),
      'score': score,
    };
  }
}

class Question {
  final int id;
  final String questionName;

  final int segmentId;
  final int dependency;
  final String weightInPer;
  final double weightInNum;
  final int? questionId;
  final int? answerId;
  final int status;

  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionName,
    required this.segmentId,
    required this.dependency,
    required this.weightInPer,
    required this.weightInNum,
    this.questionId,
    this.answerId,
    required this.status,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var answersList = json['answers'] as List;
    List<Answer> answers = answersList.map((i) => Answer.fromJson(i)).toList();

    return Question(
      id: json['id'],
      questionName: json['question_name'],
      segmentId: json['segment_id'],
      dependency: json['dependency'],
      weightInPer: json['weight_in_per'],
      weightInNum: json['weight_in_num'].toDouble(),
      questionId: json['question_id'],
      answerId: json['answer_id'],
      status: json['status'],
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_name': questionName,
      'segment_id': segmentId,
      'dependency': dependency,
      'weight_in_per': weightInPer,
      'weight_in_num': weightInNum,
      'question_id': questionId,
      'answer_id': answerId,
      'status': status,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}
