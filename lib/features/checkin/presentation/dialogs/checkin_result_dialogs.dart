import 'package:event_checkin/utils/colors.dart';
import 'package:event_checkin/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String _formatDateTime(DateTime dt) {
  final d = dt.toLocal();
  final date =
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  final time =
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '$date às $time';
}

class CheckinSuccessDialog extends StatelessWidget {
  final String attendeeName;
  final DateTime checkedInAt;

  const CheckinSuccessDialog({
    super.key,
    required this.attendeeName,
    required this.checkedInAt,
  });

  @override
  Widget build(BuildContext context) {
    return _CheckinResultDialog(
      backgroundColor: greenBackgroundColor,
      icon: Icons.check,
      title: Strings.dialogs.successTitle,
      description: Strings.dialogs.successDescription(_formatDateTime(checkedInAt)),
      iconColor: greenColor,
    );
  }
}

class CheckinAlreadyCheckedInDialog extends StatelessWidget {
  final String attendeeName;
  final DateTime checkedInAt;

  const CheckinAlreadyCheckedInDialog({
    super.key,
    required this.attendeeName,
    required this.checkedInAt,
  });

  @override
  Widget build(BuildContext context) {
    return _CheckinResultDialog(
      backgroundColor: orangeBackgroundColor,
      icon: Icons.info_outline,
      title: Strings.dialogs.alreadyTitle,
      description: Strings.dialogs.alreadyDescription(_formatDateTime(checkedInAt)),
      iconColor: orangeColor,
    );
  }
}

class CheckinFailureDialog extends StatelessWidget {
  final String? message;

  const CheckinFailureDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return _CheckinResultDialog(
      backgroundColor: redBackgroundColor,
      icon: Icons.error_outline,
      title: Strings.dialogs.failureTitle,
      description: message ?? Strings.dialogs.failureFallback,
      iconColor: redColor,
    );
  }
}

class _CheckinResultDialog extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;

  const _CheckinResultDialog({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      context.pop();
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.black,
                      size: 24,
                    ),
                    label: Text(
                      Strings.dialogs.scannerButton,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.people_alt_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                    label: Text(
                      Strings.dialogs.listButton,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
