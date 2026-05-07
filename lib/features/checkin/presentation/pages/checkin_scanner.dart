import 'package:event_checkin/core/router/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../cubit/checkin_cubit.dart';
import '../../cubit/checkin_state.dart';

class CheckinScanner extends StatefulWidget {
  const CheckinScanner({super.key, required this.params});
  final Map params;

  @override
  State<CheckinScanner> createState() => _CheckinScannerState();
}

class _CheckinScannerState extends State<CheckinScanner> {
  final controller = MobileScannerController();
  bool _scanningLocked = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckinCubit, CheckinState>(
      listener: (context, state) {
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
          controller.start();
        });
      },
      builder: (context, state) {
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
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 100,
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.params['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_alt_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    '22/25',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          _buildScanner(context),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state is CheckinLoading
                                    ? 'A processar...'
                                    : 'Posicione o código no centro',
                                style: TextStyle(
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
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('check-in manual'),
                      ),
                    ],
                  ),
                ),
                if (state is CheckinLoading)
                  Container(
                    color: Colors.black45,
                    child: Center(
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

  Widget corner() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
          left: BorderSide(color: Colors.black, width: 4),
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18)),
      ),
    );
  }

  Widget _buildScanner(BuildContext context) {
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
                scanWindow: Rect.fromLTWH(40, 40, 220, 220),
                onDetect: (capture) async {
                  if (_scanningLocked) return;
                  if (capture.barcodes.isEmpty) return;

                  final code = capture.barcodes.first.rawValue;
                  if (code == null) return;

                  setState(() => _scanningLocked = true);
                  final cubit = context.read<CheckinCubit>();
                  await controller.stop();
                  if (!mounted) return;

                  cubit.checkInByQr(code, widget.params['sessionId'] as String);
                },
              ),
            ),
            Positioned(top: 0, left: 0, child: corner()),
            Positioned(
              top: 0,
              right: 0,
              child: RotatedBox(quarterTurns: 1, child: corner()),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: RotatedBox(quarterTurns: 3, child: corner()),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: RotatedBox(quarterTurns: 2, child: corner()),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(width: 250, height: 2, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
