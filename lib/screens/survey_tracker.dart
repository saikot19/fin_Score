import 'package:flutter/material.dart';

class SurveyTracker extends StatelessWidget {
  final int currentSegment;
  final int totalSegments;
  final Map<int, String> segmentNames;

  const SurveyTracker({
    Key? key,
    required this.currentSegment,
    required this.totalSegments,
    required this.segmentNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentSegment / totalSegments;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survey Progress",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 12,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSegments, (index) {
              final segmentIndex = index + 1;
              final isCurrentSegment = currentSegment == segmentIndex;
              final segmentName =
                  segmentNames[segmentIndex] ?? "Segment $segmentIndex";

              return AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 500),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isCurrentSegment ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentSegment
                      ? const Color.fromARGB(255, 8, 2, 32)
                      : Colors.green[800],
                ),
                child: Text(segmentName),
              );
            }),
          ),
        ],
      ),
    );
  }
}
