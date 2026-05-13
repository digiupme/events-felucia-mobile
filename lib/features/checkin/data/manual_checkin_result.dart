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
  bool get isAlreadyCheckedIn => denyReason == 'already_checked';

  factory ManualCheckinResult.fromJson(Map<String, dynamic> json) =>
      ManualCheckinResult(
        result: json['result'] as String,
        attendeeName: json['attendee_name'] as String,
        checkedInAt: json['checked_in_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (json['checked_in_at'] as int) * 1000,
              ).toLocal()
            : DateTime.now(),
        denyReason: json['deny_reason'] as String?,
      );
}
