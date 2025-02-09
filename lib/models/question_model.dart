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
