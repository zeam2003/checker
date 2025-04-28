class TicketModel {
  final int? statusCode;
  final int id;
  final String entitiesId;
  final String name;
  final String date;
  final String closedate;
  final String solvedate;
  final String takeintoaccountdate;
  final String dateModification;
  final String userLastUpdater;
  final int status;
  final String userRecipient;
  final String requestType;
  final String content;
  final int urgency;
  final int impact;
  final int priority;
  final String category;
  final int type;
  final int globalValidation;
  final String timeToResolve;
  final String dateCreation;
  final String slasTtr;
  final List<DocumentModel> documents;

  TicketModel({
    this.statusCode,
    required this.id,
    required this.entitiesId,
    required this.name,
    required this.date,
    required this.closedate,
    required this.solvedate,
    required this.takeintoaccountdate,
    required this.dateModification,
    required this.userLastUpdater,
    required this.status,
    required this.userRecipient,
    required this.requestType,
    required this.content,
    required this.urgency,
    required this.impact,
    required this.priority,
    required this.category,
    required this.type,
    required this.globalValidation,
    required this.timeToResolve,
    required this.dateCreation,
    required this.slasTtr,
    required this.documents,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    // Si recibimos un statusCode 404, retornamos un modelo con solo ese dato
    if (json['statusCode'] == 404) {
      return TicketModel(
        statusCode: json['statusCode'],
        id: 0,
        entitiesId: '',
        name: '',
        date: '',
        closedate: '',
        solvedate: '',
        takeintoaccountdate: '',
        dateModification: '',
        userLastUpdater: '',
        status: 0,
        userRecipient: '',
        requestType: '',
        content: '',
        urgency: 0,
        impact: 0,
        priority: 0,
        category: '',
        type: 0,
        globalValidation: 0,
        timeToResolve: '',
        dateCreation: '',
        slasTtr: '',
        documents: [],
      );
    }

    return TicketModel(
      statusCode: json['statusCode'],
      id: json['id'] ?? 0,
      entitiesId: json['entities_id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      closedate: json['closedate'] ?? '',
      solvedate: json['solvedate'] ?? '',
      takeintoaccountdate: json['takeintoaccountdate'] ?? '',
      dateModification: json['date_mod'] ?? '',
      userLastUpdater: json['users_id_lastupdater'] ?? '',
      status: json['status'] ?? 0,
      userRecipient: json['users_id_recipient'] ?? '',
      requestType: json['requesttypes_id'] ?? '',
      content: json['content'] ?? '',
      urgency: json['urgency'] ?? 0,
      impact: json['impact'] ?? 0,
      priority: json['priority'] ?? 0,
      category: json['itilcategories_id'] ?? '',
      type: json['type'] ?? 0,
      globalValidation: json['global_validation'] ?? 0,
      timeToResolve: json['time_to_resolve'] ?? '',
      dateCreation: json['date_creation'] ?? '',
      slasTtr: json['slas_id_ttr'] ?? '',
      documents: (json['_documents'] as List<dynamic>?)
          ?.map((doc) => DocumentModel.fromJson(doc))
          .toList() ?? [],
    );
  }

  // Método de ayuda para verificar si el ticket es válido
  bool get isValid => statusCode != 404;
}

class DocumentModel {
  final int id;
  final String name;
  final String filename;
  final String filepath;
  final String mime;
  final String dateModification;
  final String userId;
  final String sha1sum;
  final String tag;
  final String dateCreation;

  DocumentModel({
    required this.id,
    required this.name,
    required this.filename,
    required this.filepath,
    required this.mime,
    required this.dateModification,
    required this.userId,
    required this.sha1sum,
    required this.tag,
    required this.dateCreation,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      filename: json['filename'] ?? '',
      filepath: json['filepath'] ?? '',
      mime: json['mime'] ?? '',
      dateModification: json['date_mod'] ?? '',
      userId: json['users_id'] ?? '',
      sha1sum: json['sha1sum'] ?? '',
      tag: json['tag'] ?? '',
      dateCreation: json['date_creation'] ?? '',
    );
  }
}