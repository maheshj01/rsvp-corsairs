class Attendee {
  final String? id;
  final String event_id;
  final String user_id;
  final String? createdAt;

  Attendee({
    this.id,
    required this.event_id,
    required this.user_id,
    this.createdAt,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        id: json['id'],
        event_id: json['event_id'],
        user_id: json['user_id'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_id': event_id,
        'user_id': user_id,
        'created_at': createdAt,
      };
}
