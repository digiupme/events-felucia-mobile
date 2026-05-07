class Session {
  final String id;
  final String name;
  final DateTime startAt;
  final DateTime endAt;

  const Session({
    required this.id,
    required this.name,
    required this.startAt,
    required this.endAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        name: json['name'] as String,
        startAt: DateTime.parse(json['start_at'] as String).toLocal(),
        endAt: DateTime.parse(json['end_at'] as String).toLocal(),
      );
}
