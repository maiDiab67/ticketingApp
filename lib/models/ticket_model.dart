class Ticket {
  final int id;
  final String name;
  final int priority;
  final String stageName;
  final String typeName;
  final String requestText;
  final String authorName;
  final String dateCreated;
  final String? dateClosed;
  final bool closed;
  final dynamic serviceId;
  final dynamic type;

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
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      name: json['name'],
      priority: int.parse(json['priority']),
      stageName: json['stage_name'],
      typeName: json['type_name'],
      requestText: json['request_text'],
      authorName: json['author_name'],
      dateCreated: json['date_created'],
      dateClosed: json['date_closed']?.toString(),
      closed: json['closed'],
      serviceId: json['service_id'],
            type: json['type'],
    );
  }
}
