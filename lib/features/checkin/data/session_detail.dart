class SessionDetail {
  final String id;
  final String name;
  final int? capacity;
  final int attendeeSessionsCount;

  const SessionDetail({
    required this.id,
    required this.name,
    this.capacity,
    required this.attendeeSessionsCount,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) => SessionDetail(
    id: json['id'] as String,
    name: json['title'] as String,
    capacity: json['capacity'] as int?,
    attendeeSessionsCount: json['attendee_sessions_count'] as int,
  );
}
