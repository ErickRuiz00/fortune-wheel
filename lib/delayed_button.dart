import 'package:flutter/material.dart';
import 'package:ruleta/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';

class DelayedButton extends StatefulWidget {
  final int delay;
  final String winner;

  const DelayedButton({this.delay = 2, required this.winner, super.key});

  @override
  State<DelayedButton> createState() => _DelayedButtonState();
}

class _DelayedButtonState extends State<DelayedButton> {
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    isButtonActive = false;
  }

  void _checkActive() async {
    if (isButtonActive == false) {
      await Future.delayed(Duration(seconds: widget.delay));
      setState(() {
        isButtonActive = true;
      });
    }
  }

  Future<void> _sendData() async {
    String message = "${constants.whatsAppMsg} ${widget.winner}";
    final Uri url = Uri.parse(
        "https://wa.me/${constants.whatsAppNum}?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw constants.whatsAppErr;
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkActive();

    return isButtonActive
        ? FilledButton.tonal(
            onPressed: () async {
              try {
                await _sendData();
                isButtonActive = false;
                Navigator.of(context).pop();
              } catch (e) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text(constants.whatsAppFailTitle),
                    content: const Text(constants.whatsAppFailContent),
                    actions: [
                      FilledButton.tonal(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          child: const Text("Aceptar"))
                    ],
                  ),
                );
              }
            },
            child: const Text(constants.claimRewardButton))
        : const SizedBox();
  }
}
