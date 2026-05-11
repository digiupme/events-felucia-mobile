class Attendee {
  final String id;
  final String name;
  final String status;

  const Attendee({
    required this.id,
    required this.name,
    required this.status,
  });

  bool get isCheckedIn => status == 'checked_in';

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        id: json['id'] as String,
        name: json['name'] as String,
        status: json['status'] as String,
      );
}
