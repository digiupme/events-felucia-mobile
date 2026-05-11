class ManualCheckinResult {
  final String result;
  final String attendeeName;
  final DateTime checkedInAt;
  final String? denyReason;

  const ManualCheckinResult({
    required this.result,
    required this.attendeeName,
    required this.checkedInAt,
    this.denyReason,
  });

  bool get isGranted => result == 'granted';
  bool get isAlreadyCheckedIn => result == 'already_checked_in';

  factory ManualCheckinResult.fromJson(Map<String, dynamic> json) =>
      ManualCheckinResult(
        result: json['result'] as String,
        attendeeName: json['attendee_name'] as String,
        checkedInAt: DateTime.fromMillisecondsSinceEpoch(
          (json['checked_in_at'] as int) * 1000,
        ).toLocal(),
        denyReason: json['deny_reason'] as String?,
      );
}
