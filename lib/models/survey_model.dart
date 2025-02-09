class Survey {
  final int memberId;
  final int branchId;
  final double appliedLoanAmount;
  final String startDate;
  final Map<int, int> responses; // Key: questionId, Value: answerId

  Survey({
    required this.memberId,
    required this.branchId,
    required this.appliedLoanAmount,
    required this.startDate,
    required this.responses,
  });

  // Convert Survey object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'member_id': memberId,
      'branch_id': branchId,
      'applied_loan_amount': appliedLoanAmount,
      'start_date': startDate,
      'responses': responses,
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
    );
  }
}
