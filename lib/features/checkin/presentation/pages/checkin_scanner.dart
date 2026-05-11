import 'package:event_checkin/core/router/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../cubit/checkin_cubit.dart';
import '../../cubit/checkin_state.dart';

class CheckinScanner extends StatefulWidget {
  const CheckinScanner({super.key, required this.sessionId});
  final String sessionId;

  @override
  State<CheckinScanner> createState() => _CheckinScannerState();
}

class _CheckinScannerState extends State<CheckinScanner> {
  final controller = MobileScannerController(autoStart: false);
  bool _scanningLocked = false;

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckinCubit, CheckinState>(
      listener: (context, state) {
        if (state is CheckinReady) {
          controller.start();
          return;
        }

        String? route;
        Map<String, dynamic>? extra;

        if (state is CheckinSuccess) {
          route = checkinSuccessRoute;
          extra = {'attendeeName': state.attendeeName};
        } else if (state is CheckinAlreadyCheckedIn) {
          route = checkinAlreadyCheckedInRoute;
          extra = {'attendeeName': state.attendeeName};
        } else if (state is CheckinFailure) {
          route = checkinFailureRoute;
          extra = {'message': state.message};
        }

        if (route == null) return;

        final cubit = context.read<CheckinCubit>();
        context.push(route, extra: extra).then((_) {
          cubit.reset();
          setState(() => _scanningLocked = false);
        });
      },
      builder: (context, state) {
        if (state is CheckinSessionLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CheckinSessionFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.read<CheckinCubit>().loadSession(widget.sessionId),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final session = context.read<CheckinCubit>().session!;

        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: Stack(
              children: [
                SizedBox.expand(
                  child: Image.asset(
                    'assets/images/scanner_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  session.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.people_alt_outlined, color: Colors.black),
                                    const SizedBox(width: 15),
                                    Text(
                                      session.capacity != null
                                          ? '${session.attendeeSessionsCount}/${session.capacity}'
                                          : '${session.attendeeSessionsCount}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          _buildScanner(context, state),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state is CheckinLoading
                                    ? 'A processar...'
                                    : 'Posicione o código no centro',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FilledButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                          ),
                        ),
                        onPressed: () async {
                          await controller.stop();
                          if (!context.mounted) return;
                          await context.push(
                            manualCheckinRoute,
                            extra: {
                              'sessionId': widget.sessionId,
                              'sessionName': session.name,
                            },
                          );
                          if (!context.mounted) return;
                          context.read<CheckinCubit>().loadSession(widget.sessionId);
                        },
                        child: const Text('check-in manual'),
                      ),
                    ],
                  ),
                ),
                if (state is CheckinLoading)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanner(BuildContext context, CheckinState state) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MobileScanner(
                controller: controller,
                scanWindow: const Rect.fromLTWH(40, 40, 220, 220),
                onDetect: (capture) async {
                  if (_scanningLocked) return;
                  if (state is! CheckinReady) return;
                  if (capture.barcodes.isEmpty) return;

                  final code = capture.barcodes.first.rawValue;
                  if (code == null) return;

                  setState(() => _scanningLocked = true);
                  final cubit = context.read<CheckinCubit>();
                  await controller.stop();
                  if (!mounted) return;

                  cubit.checkInByQr(code, widget.sessionId);
                },
              ),
            ),
            Positioned(top: 0, left: 0, child: _corner()),
            Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: _corner())),
            Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: _corner())),
            Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: _corner())),
            Align(
              alignment: Alignment.center,
              child: Container(width: 250, height: 2, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
          left: BorderSide(color: Colors.black, width: 4),
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18)),
      ),
    );
  }
}
