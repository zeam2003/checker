class CheckModel {
  final int? statusCode;
  final String? message;
  final int? id;
  final String? ticketId;
  final int? stage;
  final String? status;
  final String? type;    // Nuevo campo opcional
  final String? title;   // Nuevo campo opcional

  CheckModel({
    this.statusCode,
    this.message,
    this.id,
    this.ticketId,
    this.stage,
    this.status,
    this.type,
    this.title,
  });

  factory CheckModel.fromJson(Map<String, dynamic> json) {
    return CheckModel(
      statusCode: json['statusCode'],
      message: json['message'],
      id: json['id'],
      ticketId: json['ticketId'],
      stage: json['stage'],
      status: json['status'],
      type: json['type'],
      title: json['title'],
    );
  }

  // Método de utilidad para mapear itemtype a type
  static String mapItemTypeToType(String itemtype) {
    switch (itemtype.toLowerCase()) {
      case 'computer':
        return 'laptop';
      case 'phone':
        return 'celular';
      case 'monitor':
        return 'monitor';
      default:
        return 'otro';
    }
  }
}