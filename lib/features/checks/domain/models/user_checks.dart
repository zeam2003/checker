class CheckDetail {
  final String id;
  final int checkId;
  final String componentType;
  final String status;
  final String comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  CheckDetail({
    required this.id,
    required this.checkId,
    required this.componentType,
    required this.status,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckDetail.fromJson(Map<String, dynamic> json) {
    return CheckDetail(
      id: json['_id'],
      checkId: json['checkId'],
      componentType: json['componentType'],
      status: json['status'],
      comments: json['comments'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Check {
  final String id;
  final int ticketId;
  final int createdBy;
  final int modifiedBy;
  final String status;
  final int stage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int checkId;
  final List<CheckDetail> details;

  Check({
    required this.id,
    required this.ticketId,
    required this.createdBy,
    required this.modifiedBy,
    required this.status,
    required this.stage,
    required this.createdAt,
    required this.updatedAt,
    required this.checkId,
    required this.details,
  });

  factory Check.fromJson(Map<String, dynamic> json) {
    return Check(
      id: json['check']['_id'],
      ticketId: json['check']['ticketId'],
      createdBy: json['check']['createdBy'],
      modifiedBy: json['check']['modifiedBy'],
      status: json['check']['status'],
      stage: json['check']['stage'],
      createdAt: DateTime.parse(json['check']['createdAt']),
      updatedAt: DateTime.parse(json['check']['updatedAt']),
      checkId: json['check']['checkId'],
      details: (json['details'] as List)
          .map((detail) => CheckDetail.fromJson(detail))
          .toList(),
    );
  }
}

class UserChecks {
  final List<Check> checks;

  UserChecks({
    required this.checks,
  });

  factory UserChecks.fromJson(List<dynamic> json) {
    return UserChecks(
      checks: json.map((check) => Check.fromJson(check)).toList(),
    );
  }

  int get totalChecks => checks.length;
  
  int get weeklyChecks {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return checks.where((check) => check.createdAt.isAfter(weekAgo)).length;
  }
  
  int get monthlyChecks {
    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return checks.where((check) => check.createdAt.isAfter(monthAgo)).length;
  }
}