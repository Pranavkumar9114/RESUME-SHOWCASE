import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  SpeechRecognitionService() {
    _speech = stt.SpeechToText();
  }

  Future<void> initialize() async {
    bool available = await _speech.initialize(
      // ignore: avoid_print
      onStatus: (val) => print('onStatus: $val'),
      // ignore: avoid_print
      onError: (val) => print('onError: $val'),
    );

    if (!available) {
      // ignore: avoid_print
      print('Speech recognition not available');
    }
  }

  void listen(BuildContext context, TextEditingController searchController) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        // ignore: avoid_print
        onStatus: (val) => print('onStatus: $val'),
        // ignore: avoid_print
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _isListening = true;
        // ignore: use_build_context_synchronously
        _showListeningDialog(context, searchController);
        _speech.listen(
          onResult: (val) {
            _text = val.recognizedWords;
            searchController.text = _text;
            
            setStateInDialog(context, () {});
            if (val.finalResult) {
              stopListening();
              Navigator.of(context).pop(); 
            }
          },
        );
      }
    } else {
      _isListening = false;
      _speech.stop();
    }
  }

  void stopListening() {
    if (_isListening) {
      _isListening = false;
      _speech.stop();
    }
  }

  void _showListeningDialog(BuildContext context, TextEditingController searchController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return _BlinkingListeningDialog(
              isListening: _isListening,
              searchController: searchController,
              stopListening: stopListening,
              toggleListening: () {
                if (_isListening) {
                  stopListening();
                  setState(() {
                    _isListening = false;
                  });
                } else {
                  listen(context, searchController);
                  setState(() {
                    _isListening = true;
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  
  void setStateInDialog(BuildContext context, void Function() callback) {
    if (context is StatefulElement && context.state.mounted) {
      // ignore: invalid_use_of_protected_member
      context.state.setState(callback);
    }
  }
}

class _BlinkingListeningDialog extends StatefulWidget {
  final bool isListening;
  final TextEditingController searchController;
  final VoidCallback stopListening;
  final VoidCallback toggleListening;

  const _BlinkingListeningDialog({
    required this.isListening,
    required this.searchController,
    required this.stopListening,
    required this.toggleListening,
  });

  @override
  __BlinkingListeningDialogState createState() => __BlinkingListeningDialogState();
}

class __BlinkingListeningDialogState extends State<_BlinkingListeningDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Speak Now'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.isListening ? 100 : 60,
                height: widget.isListening ? 100 : 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
             
              IconButton(
                icon: Icon(widget.isListening ? Icons.mic : Icons.mic_none, size: 48.0),
                onPressed: widget.toggleListening,
                color: widget.isListening ? Colors.red : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
       
          FadeTransition(
            opacity: _animation,
            child: Text(
              widget.searchController.text.isNotEmpty
                  ? widget.searchController.text
                  : 'Listening...',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.stopListening();
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
