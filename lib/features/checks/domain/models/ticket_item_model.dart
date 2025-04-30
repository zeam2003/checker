class TicketItemModel {
  final int? statusCode;
  final String? message;
  final List<TicketItemData> items;

  TicketItemModel({
    this.statusCode,
    this.message,
    required this.items,
  });

  factory TicketItemModel.fromJson(Map<String, dynamic> json) {
    if (json['statusCode'] != null) {
      return TicketItemModel(
        statusCode: json['statusCode'],
        message: json['message'],
        items: [],
      );
    }

    final itemsList = (json['items'] as List<dynamic>?)?.map(
      (item) => TicketItemData.fromJson(item),
    ).toList() ?? [];

    return TicketItemModel(
      items: itemsList,
    );
  }
}

class TicketItemData {
  final String itemtype;  // Cambiado de itemType a itemtype para coincidir con la respuesta del API
  final String name;      // Cambiado de itemName a name para coincidir con la respuesta del API
  final int id;          // Cambiado de itemId a id para coincidir con la respuesta del API

  TicketItemData({
    required this.itemtype,
    required this.name,
    required this.id,
  });

  factory TicketItemData.fromJson(Map<String, dynamic> json) {
    return TicketItemData(
      itemtype: json['itemtype'] ?? '',
      name: json['items_id'] ?? '',  // Usamos 'items_id' que es el campo que contiene el nombre/código del dispositivo
      id: json['id'] ?? 0,
    );
  }
}