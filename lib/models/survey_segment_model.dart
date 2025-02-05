import 'survey_model.dart';

class SurveySegmentModel {
  final String title;
  final List<SurveyQuestion> questions;

  SurveySegmentModel(SurveySegmentModel segmentmodel,
      {required this.title, required this.questions});
}
