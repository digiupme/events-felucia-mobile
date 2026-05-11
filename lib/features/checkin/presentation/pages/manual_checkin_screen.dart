import 'package:event_checkin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/manual_checkin_cubit.dart';
import '../../cubit/manual_checkin_state.dart';
import '../dialogs/checkin_result_dialogs.dart';

class ManualCheckinScreen extends StatefulWidget {
  const ManualCheckinScreen({super.key, required this.sessionName});
  final String sessionName;

  @override
  State<ManualCheckinScreen> createState() => _ManualCheckinScreenState();
}

class _ManualCheckinScreenState extends State<ManualCheckinScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManualCheckinCubit, ManualCheckinState>(
      listener: (context, state) {
        Widget? dialog;

        if (state is ManualCheckinSuccess) {
          dialog = CheckinSuccessDialog(
            attendeeName: state.attendeeName,
            checkedInAt: state.checkedInAt,
          );
        } else if (state is ManualCheckinAlreadyCheckedIn) {
          dialog = CheckinAlreadyCheckedInDialog(
            attendeeName: state.attendeeName,
            checkedInAt: state.checkedInAt,
          );
        } else if (state is ManualCheckinSubmitFailure) {
          dialog = CheckinFailureDialog(message: state.message);
        }

        if (dialog == null) return;

        final cubit = context.read<ManualCheckinCubit>();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => dialog!,
        ).then((_) => cubit.loadAttendees());
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Check-in Manual'),
            centerTitle: false,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 15,
                    horizontal: 5,
                  ),
                  child: Text(
                    widget.sessionName,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SearchBar(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    leading: Icon(Icons.search, color: Colors.grey),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    controller: _searchController,
                    hintText: 'Pesquisar',
                    onChanged: context.read<ManualCheckinCubit>().search,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ManualCheckinState state) {
    if (state is ManualCheckinLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ManualCheckinFailure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: context.read<ManualCheckinCubit>().loadAttendees,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final attendees = switch (state) {
      ManualCheckinLoaded s => s.filtered,
      ManualCheckinSubmitting s =>
        s.attendees
            .where(
              (a) =>
                  s.query.isEmpty ||
                  a.name.toLowerCase().contains(s.query.toLowerCase()),
            )
            .toList(),
      _ => [],
    };

    final isSubmitting = state is ManualCheckinSubmitting;

    if (attendees.isEmpty) {
      return const Center(child: Text('Nenhum participante encontrado.'));
    }

    final submittingId = state is ManualCheckinSubmitting
        ? state.attendeeId
        : null;

    return ListView.separated(
      itemCount: attendees.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final attendee = attendees[index];
        final isThisRowSubmitting = submittingId == attendee.id;

        return ListTile(
          minVerticalPadding: 20,
          trailing: isThisRowSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: redColor,
                  ),
                )
              : !attendee.isCheckedIn
              ? TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => context.read<ManualCheckinCubit>().checkIn(
                          attendee,
                        ),
                  child: const Text(
                    'check-in',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : Icon(Icons.check, color: greenColor),
          title: Text(attendee.name),
          onTap: isSubmitting || attendee.isCheckedIn
              ? null
              : () => context.read<ManualCheckinCubit>().checkIn(attendee),
        );
      },
    );
  }
}
