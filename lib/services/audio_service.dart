import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

/// 统一超真实高保真语音服务 (Unified Natural Audio Service)
/// 支持: 谷歌 Google Neural TTS 神经网络发音、有道美音/英音原生原声 MP3 本地文件缓存、双引擎故障自动降级
class AudioService {
  static AudioService? _instance;
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;
  VoidCallback? _onComplete;
  Directory? _cacheDir;

  AudioService._();

  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  /// 初始化发音引擎与网络缓存目录
  Future<void> init() async {
    if (_isInitialized) return;
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();

    try {
      _cacheDir = await getTemporaryDirectory();
    } catch (e) {
      debugPrint('Cache dir init error: $e');
    }

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_onComplete != null) {
        final callback = _onComplete;
        _onComplete = null;
        callback!();
      }
    });

    // 1. 设置系统 Android 谷歌 TTS / iOS 官方自然引擎
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final engines = await _flutterTts.getEngines;
        if (engines != null && engines is List && engines.contains("com.google.android.tts")) {
          await _flutterTts.setEngine("com.google.android.tts");
        }
      } catch (e) {
        debugPrint('Google TTS engine setting ignored: $e');
      }
    }

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(Platform.isAndroid ? 0.45 : 0.48); // 更加平滑自然的语速
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // iOS 混音与扬声器支持
    try {
      if (!kIsWeb && Platform.isIOS) {
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
        );
      }
    } catch (e) {
      // Non-iOS or unsupported
    }

    // 2. 筛选系统最优神经网络高保真发音人 (Neural / Wavenet / Natural / Premium / Siri)
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null && voices is List && voices.isNotEmpty) {
        dynamic selectedVoice;
        for (var voice in voices) {
          if (voice is Map) {
            final String? name = voice['name']?.toString().toLowerCase();
            final String? locale = voice['locale']?.toString().toLowerCase();

            if (locale != null && (locale.startsWith('en-us') || locale.startsWith('en_us'))) {
              if (name != null &&
                  (name.contains('wavenet') ||
                      name.contains('neural') ||
                      name.contains('natural') ||
                      name.contains('premium') ||
                      name.contains('enhanced') ||
                      name.contains('siri') ||
                      name.contains('google'))) {
                selectedVoice = voice;
                break;
              }
              selectedVoice ??= voice;
            }
          }
        }
        if (selectedVoice != null && selectedVoice["name"] != null && selectedVoice["locale"] != null) {
          await _flutterTts.setVoice({
            "name": selectedVoice["name"].toString(),
            "locale": selectedVoice["locale"].toString(),
          });
        }
      }
    } catch (e) {
      debugPrint('TTS voice selection fallback: $e');
    }

    _flutterTts.setCompletionHandler(() {
      if (_onComplete != null) {
        final callback = _onComplete;
        _onComplete = null;
        callback!();
      }
    });

    _flutterTts.setCancelHandler(() {
      if (_onComplete != null) {
        final callback = _onComplete;
        _onComplete = null;
        callback!();
      }
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint('FlutterTTS error: $msg');
      if (_onComplete != null) {
        final callback = _onComplete;
        _onComplete = null;
        callback!();
      }
    });

    _isInitialized = true;
  }

  /// 停止当前正在播放的所有音频（支持快速打断）
  Future<void> stop() async {
    if (_isInitialized) {
      _onComplete = null;
      try {
        await _audioPlayer.stop();
      } catch (_) {}
      try {
        await _flutterTts.stop();
      } catch (_) {}
    }
  }

  /// 调整语速
  Future<void> setSpeechRate(double rateMultiplier) async {
    await init();
    final baseRate = Platform.isAndroid ? 0.45 : 0.48;
    final targetRate = (baseRate * rateMultiplier).clamp(0.1, 1.0);
    await _flutterTts.setSpeechRate(targetRate);
  }

  /// 统一发音主接口 (通用智能路由)
  Future<void> speak(String text, {VoidCallback? onComplete, double speechRate = 1.0}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      onComplete?.call();
      return;
    }

    // 单个单词路由至超高清原声单词播报
    if (!trimmed.contains(' ') && RegExp(r'^[a-zA-Z\-\.\x27]+$').hasMatch(trimmed)) {
      await speakWord(trimmed, onComplete: onComplete);
    } else {
      await speakSentence(trimmed, speechRate: speechRate, onComplete: onComplete);
    }
  }

  /// 单词发音播报 (Word Pronunciation with Native MP3 Cache)
  Future<void> speakWord(String word, {String accent = 'US', VoidCallback? onComplete}) async {
    await init();
    await stop();
    _onComplete = onComplete;

    final cleanWord = word.trim().toLowerCase();
    if (cleanWord.isEmpty) {
      _onComplete?.call();
      _onComplete = null;
      return;
    }

    final accentType = accent.toUpperCase() == 'UK' ? '1' : '2'; // 1: UK, 2: US
    final fileName = 'word_${cleanWord}_type$accentType.mp3';

    try {
      // 1. 本地文件系统缓存检查 (0 延迟极速离线播报)
      if (_cacheDir != null) {
        final localFile = File('${_cacheDir!.path}/$fileName');
        if (await localFile.exists() && (await localFile.length()) > 500) {
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        // 2. 本地无缓存 -> 异步请求有道美音/英音高保真原声 MP3 文件并写入磁盘
        final url = 'https://dict.youdao.com/dictvoice?audio=${Uri.encodeComponent(cleanWord)}&type=$accentType';
        final httpClient = HttpClient();
        httpClient.connectionTimeout = const Duration(seconds: 4);

        final request = await httpClient.getUrl(Uri.parse(url));
        final response = await request.close();

        if (response.statusCode == 200) {
          final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
          if (bytes.length > 500) {
            await localFile.writeAsBytes(bytes);
            await _audioPlayer.play(DeviceFileSource(localFile.path));
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Youdao Word MP3 fetch error: $e, falling back to TTS');
    }

    // 3. 降级方案：使用优化调优后的自然 TTS 引擎
    try {
      await _flutterTts.speak(cleanWord);
    } catch (e) {
      _onComplete?.call();
      _onComplete = null;
    }
  }

  /// 长句与文章段落发音 (Sentence & Paragraph Speech with Natural Rhythm)
  Future<void> speakSentence(String sentence, {double speechRate = 1.0, VoidCallback? onComplete}) async {
    await init();
    await stop();
    _onComplete = onComplete;

    final trimmedText = sentence.trim();
    if (trimmedText.isEmpty) {
      _onComplete?.call();
      _onComplete = null;
      return;
    }

    // 超长长句直接使用 Google Neural TTS 朗读，发音最自然连贯
    if (trimmedText.length > 80) {
      try {
        await setSpeechRate(speechRate);
        await _flutterTts.speak(trimmedText);
        return;
      } catch (e) {
        _onComplete?.call();
        _onComplete = null;
        return;
      }
    }

    // 中短句尝试高清有道原声音频流缓存
    try {
      if (_cacheDir != null) {
        final hashStr = trimmedText.hashCode.abs().toString();
        final fileName = 'sentence_${hashStr}_${trimmedText.length}.mp3';
        final localFile = File('${_cacheDir!.path}/$fileName');

        if (await localFile.exists() && (await localFile.length()) > 1000) {
          await _audioPlayer.setPlaybackRate(speechRate);
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        final encodedText = Uri.encodeComponent(trimmedText);
        final url = 'https://dict.youdao.com/dictvoice?audio=$encodedText&type=2';
        final httpClient = HttpClient();
        httpClient.connectionTimeout = const Duration(seconds: 4);

        final request = await httpClient.getUrl(Uri.parse(url));
        final response = await request.close();

        if (response.statusCode == 200) {
          final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
          if (bytes.length > 1000) {
            await localFile.writeAsBytes(bytes);
            await _audioPlayer.setPlaybackRate(speechRate);
            await _audioPlayer.play(DeviceFileSource(localFile.path));
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Sentence audio stream fallback: $e');
    }

    // 自动降级为系统自然 TTS
    try {
      await setSpeechRate(speechRate);
      await _flutterTts.speak(trimmedText);
    } catch (e) {
      _onComplete?.call();
      _onComplete = null;
    }
  }

  /// 48 国际音标点读发音 (Phonetic Symbol Speech)
  Future<void> speakPhonetic(String symbol, String sampleWord, {VoidCallback? onComplete}) async {
    await init();
    await stop();

    final cleanWord = sampleWord.trim();
    if (cleanWord.isNotEmpty) {
      // 读对应的标准例词，发音最为真实自然
      await speakWord(cleanWord, onComplete: onComplete);
    } else {
      // 兜底朗读音标标识
      final cleanSymbol = symbol.replaceAll(RegExp(r'[\[\]\/]'), '');
      try {
        await _flutterTts.speak(cleanSymbol);
      } catch (_) {
        onComplete?.call();
      }
    }
  }
}
