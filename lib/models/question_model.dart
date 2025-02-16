/*class Question {
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

  /// Factory constructor to parse JSON safely
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionName: json['question_name'] ?? 'Unknown',
      questionNameEng: json['question_name_eng'] ?? 'Unknown',
      segmentId: json['segment_id'] ?? 0,
      dependency: json['dependency'] ?? 0,
      weightInPer: (json['weight_in_per'] is num)
          ? json['weight_in_per'].toDouble()
          : 0.0,
      weightInNum: (json['weight_in_num'] is num)
          ? json['weight_in_num'].toDouble()
          : 0.0,
      answers: (json['answers'] != null && json['answers'] is List)
          ? (json['answers'] as List<dynamic>)
              .map((answer) => Answer.fromJson(answer))
              .toList()
          : [],
    );
  }

  /// Returns the question text to display
  String get text => questionNameEng;

  /// Converts object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_name': questionName,
      'question_name_eng': questionNameEng,
      'segment_id': segmentId,
      'dependency': dependency,
      'weight_in_per': weightInPer,
      'weight_in_num': weightInNum,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
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

  /// Factory constructor to parse JSON safely
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] ?? 0,
      answerBangla: json['answer_bangla'] ?? 'Unknown',
      answerEnglish: json['answer_english'] ?? 'Unknown',
      questionId: json['question_id'] ?? 0,
      mark: (json['mark'] is num) ? json['mark'].toDouble() : 0.0,
      score: (json['score'] is num) ? json['score'].toDouble() : 0.0,
    );
  }

  /// Returns the answer text
  String get text => answerBangla;

  /// Converts object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_bangla': answerBangla,
      'answer_english': answerEnglish,
      'question_id': questionId,
      'mark': mark,
      'score': score,
    };
  }
}*/
class Question {
  final int id;
  final String questionName;
  final String questionNameEng;
  final int segmentId;
  final int dependency;
  final double weightInPer;
  final double weightInNum;
  final List<Answer> answers;
  Answer? selectedAnswer; // Stores the selected answer for this question

  Question({
    required this.id,
    required this.questionName,
    required this.questionNameEng,
    required this.segmentId,
    required this.dependency,
    required this.weightInPer,
    required this.weightInNum,
    required this.answers,
    this.selectedAnswer, // Optional: Holds selected answer
  });

  /// Factory constructor to parse JSON safely
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionName: json['question_name'] ?? 'Unknown',
      questionNameEng: json['question_name_eng'] ?? 'Unknown',
      segmentId: json['segment_id'] ?? 0,
      dependency: json['dependency'] ?? 0,
      weightInPer: (json['weight_in_per'] is num)
          ? json['weight_in_per'].toDouble()
          : 0.0,
      weightInNum: (json['weight_in_num'] is num)
          ? json['weight_in_num'].toDouble()
          : 0.0,
      answers: (json['answers'] != null && json['answers'] is List)
          ? (json['answers'] as List<dynamic>)
              .map((answer) => Answer.fromJson(answer))
              .toList()
          : [],
    );
  }

  /// Returns the question text to display
  String get text => questionNameEng;

  get linkedQuestion => null;

  /// Converts object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_name': questionName,
      'question_name_eng': questionNameEng,
      'segment_id': segmentId,
      'dependency': dependency,
      'weight_in_per': weightInPer,
      'weight_in_num': weightInNum,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'selected_answer': selectedAnswer?.toJson(), // Serialize selected answer
    };
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

  /// Factory constructor to parse JSON safely
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] ?? 0,
      answerBangla: json['answer_bangla'] ?? 'Unknown',
      answerEnglish: json['answer_english'] ?? 'Unknown',
      questionId: json['question_id'] ?? 0,
      mark: (json['mark'] is num) ? json['mark'].toDouble() : 0.0,
      score: (json['score'] is num) ? json['score'].toDouble() : 0.0,
    );
  }

  /// Returns the answer text
  String get text => answerBangla;

  get linkedQuestions => null;

  /// Converts object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_bangla': answerBangla,
      'answer_english': answerEnglish,
      'question_id': questionId,
      'mark': mark,
      'score': score,
    };
  }
}
