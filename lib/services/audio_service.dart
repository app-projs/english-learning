import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static AudioService? _instance;
  late FlutterTts _flutterTts;
  bool _isInitialized = false;
  VoidCallback? _onComplete;

  AudioService._();

  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _flutterTts = FlutterTts();
    
    // Set default language to English (US)
    await _flutterTts.setLanguage("en-US");
    // Set default speech rate
    await _flutterTts.setSpeechRate(0.48); // Slightly slower rate sounds more natural
    // Set default volume
    await _flutterTts.setVolume(1.0);
    // Set default pitch
    await _flutterTts.setPitch(1.0);

    // Try to find a premium/natural sounding voice
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null && voices is List) {
        dynamic bestVoice;
        for (var voice in voices) {
          if (voice is Map) {
            final String? name = voice['name']?.toString().toLowerCase();
            final String? locale = voice['locale']?.toString().toLowerCase();
            
            // Filter English (US/GB)
            if (locale != null && (locale.startsWith('en-us') || locale.startsWith('en_us') || locale == 'en-gb' || locale == 'en_gb')) {
              // Priority 1: Siri / Enhanced / Premium / WaveNet / Neural voices
              if (name != null && (name.contains('siri') || name.contains('enhanced') || name.contains('premium') || name.contains('wavenet') || name.contains('neural'))) {
                bestVoice = voice;
                break;
              }
              // Priority 2: Google local voices (often high quality on Android)
              if (name != null && name.contains('google') && name.contains('local')) {
                bestVoice = voice;
              }
              // Priority 3: standard fallback
              bestVoice ??= voice;
            }
          }
        }
        if (bestVoice != null) {
          await _flutterTts.setVoice({
            "name": bestVoice["name"],
            "locale": bestVoice["locale"],
          });
        }
      }
    } catch (e) {
      // Fallback silently to system default
    }
    
    _flutterTts.setCompletionHandler(() {
      if (_onComplete != null) {
        _onComplete!();
      }
    });

    _flutterTts.setCancelHandler(() {
      if (_onComplete != null) {
        _onComplete!();
      }
    });

    _flutterTts.setErrorHandler((msg) {
      if (_onComplete != null) {
        _onComplete!();
      }
    });
    
    _isInitialized = true;
  }

  Future<void> speak(String text, {VoidCallback? onComplete}) async {
    await init();
    _onComplete = onComplete;
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    if (_isInitialized) {
      await _flutterTts.stop();
    }
  }
}
