class Ticket {
  final int id;
  final String name;
  final String priority;
  final String stageName;
  final String typeName;
  final dynamic requestText;
  final String authorName;
  final dynamic dateCreated;
  final dynamic dateClosed;
  final bool closed;
  final dynamic serviceId;
  final dynamic type;
  final int stageId;

  Ticket({
    required this.id,
    required this.name,
    required this.priority,
    required this.stageName,
    required this.typeName,
    required this.requestText,
    required this.authorName,
    required this.dateCreated,
    this.dateClosed,
    required this.closed,
    this.serviceId,
    this.type,
    required this.stageId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      name: json['name'],
      priority: json['priority'].toString(),
      stageName: json['stage_name'],
      typeName: json['type_name'],
      requestText: json['request_text'],
      authorName: json['author_name'],
      dateCreated: json['date_created'],
      dateClosed: json['date_closed']?.toString(),
      closed: json['closed'],
      serviceId: json['service_id'],
      type: json['type'],
      stageId: json['stage_id'],
    );
  }
}
