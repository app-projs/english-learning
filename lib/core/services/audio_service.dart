import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

/// 统一超真实高保真语音服务 (Unified Natural Audio Service)
/// 支持: 谷歌 Google Neural TTS 神经网络发音、有道美音/英音原生原声 MP3 本地文件缓存、双引擎故障自动降级
class AudioService {
  static AudioService? _instance;
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;
  VoidCallback? _onComplete;
  Directory? _cacheDir;

  bool _isStopped = false;

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
    await _flutterTts.setSpeechRate((!kIsWeb && Platform.isAndroid) ? 0.45 : 0.48); // 更加平滑自然的语速
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
    _isStopped = true;
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

  /// 单词发音播报 (Word Pronunciation with Native MP3 Cache & Global Accent)
  Future<void> speakWord(String word, {String? accent, VoidCallback? onComplete}) async {
    await init();
    await stop();
    _isStopped = false;
    _onComplete = onComplete;

    final cleanWord = word.trim().toLowerCase();
    if (cleanWord.isEmpty) {
      _onComplete?.call();
      _onComplete = null;
      return;
    }

    final storage = await StorageService.getInstance();
    final effectiveAccent = accent ?? storage.getAccent();
    final accentType = effectiveAccent.toUpperCase() == 'UK' ? '1' : '2'; // 1: UK, 2: US
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
        request.headers.set('User-Agent', 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36');
        final response = await request.close();

        if (response.statusCode == 200) {
          final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
          if (bytes.length > 500) {
            await localFile.writeAsBytes(bytes);
            await _audioPlayer.play(DeviceFileSource(localFile.path));
            return;
          }
        }

        // 3. 有道无响应 -> 尝试 Google Neural TTS
        final googleBytes = await _fetchGoogleTtsAudio(cleanWord, accent: effectiveAccent);
        if (googleBytes != null && googleBytes.length > 500) {
          await localFile.writeAsBytes(googleBytes);
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }
      }
    } catch (e) {
      debugPrint('Word MP3 fetch error: $e, falling back to TTS');
    }

    // 4. 降级方案：使用优化调优后的自然 TTS 引擎
    try {
      await _flutterTts.speak(cleanWord);
    } catch (e) {
      _onComplete?.call();
      _onComplete = null;
    }
  }

  /// 长句与文章段落发音 (Sentence & Paragraph Speech - Multi-Layer Neural TTS)
  /// 策略：优先走微软 Edge Neural TTS ➔ 备用 Google Translate Neural TTS ➔ 按句切分串行播放 (Google/Youdao MP3) ➔ 系统 TTS
  Future<void> speakSentence(String paragraph, {double speechRate = 1.0, VoidCallback? onComplete}) async {
    await init();
    await stop();
    _isStopped = false;

    final trimmedText = paragraph.trim();
    if (trimmedText.isEmpty) {
      onComplete?.call();
      return;
    }

    _onComplete = onComplete;
    final storage = await StorageService.getInstance();
    final accent = storage.getAccent();

    try {
      if (_cacheDir != null) {
        final hashStr = trimmedText.hashCode.abs().toString();
        final fileName = 'neural_tts_${accent}_${hashStr}_${trimmedText.length}.mp3';
        final localFile = File('${_cacheDir!.path}/$fileName');

        // 1. 磁盘缓存命中 - 0 延迟秒播
        if (await localFile.exists() && (await localFile.length()) > 500) {
          if (_isStopped) return;
          await _audioPlayer.setPlaybackRate(speechRate);
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        // 2. 请求微软 Edge 神经网络发音 (支持长段落自然连续播报，美音/英音适配)
        final voiceName = accent.toUpperCase() == 'UK' ? 'en-GB-SoniaNeural' : 'en-US-AvaNeural';
        final edgeBytes = await _fetchEdgeTtsAudio(trimmedText, voiceName: voiceName);
        if (edgeBytes != null && edgeBytes.length > 500) {
          if (_isStopped) return;
          await localFile.writeAsBytes(edgeBytes);
          await _audioPlayer.setPlaybackRate(speechRate);
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        // 3. 请求 Google Translate Neural TTS 原声发音 (针对 200 字符内段落/单句)
        if (trimmedText.length <= 200) {
          final googleBytes = await _fetchGoogleTtsAudio(trimmedText, accent: accent);
          if (googleBytes != null && googleBytes.length > 500) {
            if (_isStopped) return;
            await localFile.writeAsBytes(googleBytes);
            await _audioPlayer.setPlaybackRate(speechRate);
            await _audioPlayer.play(DeviceFileSource(localFile.path));
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Neural TTS paragraph speech error: $e, falling back to sentence chunks');
    }

    // 4. 降级方案：按句切分串行播放 (Google Neural / Youdao 原声 MP3)
    final sentences = trimmedText
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (sentences.isEmpty) {
      _onComplete?.call();
      _onComplete = null;
      return;
    }

    int currentIndex = 0;
    late Future<void> Function() playNext;
    playNext = () async {
      if (currentIndex >= sentences.length) {
        final callback = _onComplete;
        _onComplete = null;
        callback?.call();
        return;
      }
      final sentenceText = sentences[currentIndex++];
      await _playSentenceChunk(sentenceText, accent: accent, speechRate: speechRate, onComplete: playNext);
    };
    await playNext();
  }

  /// 通过谷歌 Google Translate 高保真神经网络 API 合成自然高保真音频 (HTTP GET)
  Future<List<int>?> _fetchGoogleTtsAudio(String text, {String accent = 'US'}) async {
    if (kIsWeb) return null;
    final cleanText = text.trim();
    if (cleanText.isEmpty) return null;

    final lang = accent.toUpperCase() == 'UK' ? 'en-GB' : 'en-US';
    final encoded = Uri.encodeComponent(cleanText);
    final url = 'https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded&tl=$lang&client=tw-ob';

    try {
      final httpClient = HttpClient();
      httpClient.connectionTimeout = const Duration(seconds: 5);

      final request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set(
        'User-Agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      );
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
        if (bytes.length > 500) {
          return bytes;
        }
      }
    } catch (e) {
      debugPrint('Google TTS fetch error: $e');
    }
    return null;
  }

  /// 通过微软 Edge TTS 官方免费 WebSocket 节点合成高保真神经网络音频
  Future<List<int>?> _fetchEdgeTtsAudio(String text, {String? voiceName}) async {
    if (kIsWeb) return null;
    final selectedVoice = voiceName ?? 'en-US-AvaNeural';
    final escapedText = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');

    try {
      const wsUrl = 'wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/edge/v1?TrustedClientToken=6A5AA1D4EA5E40B1A42548646CF1037F';
      final socket = await WebSocket.connect(
        wsUrl,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0',
          'Pragma': 'no-cache',
          'Cache-Control': 'no-cache',
          'Origin': 'chrome-extension://jdiccldimpdaibocqfkgahpififfkbej',
        },
      ).timeout(const Duration(seconds: 5));

      final completer = Completer<List<int>?>();
      final audioBuffer = <int>[];

      // 1. 发送配置消息
      final configMsg =
          "X-Timestamp: ${DateTime.now().toIso8601String()}\r\n"
          "Content-Type: application/json; charset=utf-8\r\n"
          "Path: speech.config\r\n\r\n"
          '{"context":{"synthesis":{"audio":{"metadataOptions":{"sentenceBoundaryEnabled":false,"wordBoundaryEnabled":false},"outputFormat":"audio-24khz-48kbitrate-mono-mp3"}}}}';
      socket.add(configMsg);

      // 2. 发送 SSML 朗读请求
      final ssmlMsg =
          "X-Timestamp: ${DateTime.now().toIso8601String()}\r\n"
          "Content-Type: application/ssml+xml\r\n"
          "Path: ssml\r\n\r\n"
          "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>"
          "<voice name='$selectedVoice'>"
          "<pitch hertz='0Hz'/><rate speed='0%'/>$escapedText"
          "</voice></speak>";
      socket.add(ssmlMsg);

      socket.listen(
        (data) {
          if (data is List<int>) {
            if (data.length > 2) {
              final headerLen = (data[0] << 8) | data[1];
              if (data.length >= 2 + headerLen) {
                final headerStr = String.fromCharCodes(data.sublist(2, 2 + headerLen));
                if (headerStr.contains('Path: audio')) {
                  audioBuffer.addAll(data.sublist(2 + headerLen));
                }
              }
            }
          } else if (data is String) {
            if (data.contains('Path: turn.end')) {
              socket.close();
              if (!completer.isCompleted) {
                completer.complete(audioBuffer.isNotEmpty ? audioBuffer : null);
              }
            }
          }
        },
        onError: (err) {
          socket.close();
          if (!completer.isCompleted) completer.complete(null);
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(audioBuffer.isNotEmpty ? audioBuffer : null);
          }
        },
        cancelOnError: true,
      );

      return await completer.future.timeout(
        const Duration(seconds: 7),
        onTimeout: () {
          socket.close();
          return audioBuffer.isNotEmpty ? audioBuffer : null;
        },
      );
    } catch (e) {
      debugPrint('Edge TTS WebSocket synthesis error: $e');
      return null;
    }
  }

  /// 单句 MP3 流播放内核 (Google Neural TTS -> Youdao MP3 -> FlutterTts 降级)
  Future<void> _playSentenceChunk(
    String sentenceText, {
    String accent = 'US',
    double speechRate = 1.0,
    Future<void> Function()? onComplete,
  }) async {
    if (_isStopped) return;
    try {
      if (_cacheDir != null) {
        final hashStr = sentenceText.hashCode.abs().toString();
        final fileName = 'chunk_${accent}_${hashStr}_${sentenceText.length}.mp3';
        final localFile = File('${_cacheDir!.path}/$fileName');

        // 命中磁盘缓存 - 0 延迟直接播放
        if (await localFile.exists() && (await localFile.length()) > 500) {
          await _audioPlayer.setPlaybackRate(speechRate);
          _onComplete = onComplete != null ? () => onComplete() : null;
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        // 1. 优先尝试 Google Translate Neural TTS 高质量原声
        final googleBytes = await _fetchGoogleTtsAudio(sentenceText, accent: accent);
        if (googleBytes != null && googleBytes.length > 500) {
          await localFile.writeAsBytes(googleBytes);
          await _audioPlayer.setPlaybackRate(speechRate);
          _onComplete = onComplete != null ? () => onComplete() : null;
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        // 2. 次级备用：请求有道原声 MP3
        final accentType = accent.toUpperCase() == 'UK' ? '1' : '2';
        final encodedText = Uri.encodeComponent(sentenceText);
        final url = 'https://dict.youdao.com/dictvoice?audio=$encodedText&type=$accentType';
        final httpClient = HttpClient();
        httpClient.connectionTimeout = const Duration(seconds: 4);

        final request = await httpClient.getUrl(Uri.parse(url));
        request.headers.set(
          'User-Agent',
          'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        );
        final response = await request.close();

        if (response.statusCode == 200) {
          final bytes = await response.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
          if (bytes.length > 500) {
            await localFile.writeAsBytes(bytes);
            await _audioPlayer.setPlaybackRate(speechRate);
            _onComplete = onComplete != null ? () => onComplete() : null;
            await _audioPlayer.play(DeviceFileSource(localFile.path));
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Chunk audio fetch error: $e');
    }

    // 3. 降级：使用本地 TTS 朗读这一句
    try {
      final ttsCompleter = Completer<void>();
      _flutterTts.setCompletionHandler(() => ttsCompleter.complete());
      _flutterTts.setErrorHandler((_) => ttsCompleter.complete());
      await setSpeechRate(speechRate);
      await _flutterTts.speak(sentenceText);
      await ttsCompleter.future;
    } catch (_) {}
    onComplete?.call();
  }

  // 48 国际音标高保真纯音发音源映射 (仅保留纯正爆破音/摩擦音音频，拒绝包含完整单词发音)
  static final Map<String, String> _ipaPhonemeAudioUrls = {
    'p': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/p--_gb_1.mp3',
    'b': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/b--_gb_1.mp3',
    't': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/t--_gb_1.mp3',
    'd': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/d--_gb_1.mp3',
    'k': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/k--_gb_1.mp3',
    'f': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/f--_gb_1.mp3',
    'v': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/v--_gb_1.mp3',
    's': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/s--_gb_1.mp3',
    'z': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/z--_gb_1.mp3',
    'h': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/h--_gb_1.mp3',
    'r': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/r--_gb_1.mp3',
    'm': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/m--_gb_1.mp3',
    'n': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/n--_gb_1.mp3',
    'l': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/l--_gb_1.mp3',
    'w': 'https://ssl.gstatic.com/dictionary/static/sounds/20200429/w--_gb_1.mp3',
  };

  // TTS 音标纯音提示词映射 (防止死读字母名称 "Pee", "Bee", "Tee", "Dee" 或读出例词)
  static final Map<String, String> _ipaTtsCues = {
    // 20 元音 (Vowels)
    'i:': 'ee',
    'ɪ': 'ih',
    'e': 'eh',
    'æ': 'ah',
    'ɜ:': 'er',
    'ə': 'uh',
    'ʌ': 'uh',
    'u:': 'oo',
    'ʊ': 'oo',
    'ɔ:': 'or',
    'ɒ': 'oh',
    'ɑ:': 'ah',
    'aɪ': 'eye',
    'eɪ': 'ay',
    'ɔɪ': 'oy',
    'aʊ': 'ow',
    'əʊ': 'oh',
    'ɪə': 'ear',
    'eə': 'air',
    'ʊə': 'poor',

    // 28 辅音 (Consonants)
    'p': 'puh',
    'b': 'buh',
    't': 'tuh',
    'd': 'duh',
    'k': 'kuh',
    'g': 'guh',
    'f': 'fff',
    'v': 'vvv',
    's': 'sss',
    'z': 'zzz',
    'm': 'mmm',
    'n': 'nnn',
    'h': 'huh',
    'r': 'ruh',
    'w': 'wuh',
    'j': 'yuh',
    'l': 'luh',
    'θ': 'thuh',
    'ð': 'theuh',
    'ʃ': 'shh',
    'ʒ': 'zhh',
    'tʃ': 'chuh',
    'dʒ': 'juh',
    'tr': 'tree',
    'dr': 'drive',
    'ts': 'ts',
    'dz': 'dz',
    'ŋ': 'ng',
  };

  /// 48 国际音标纯正发音播报 (Pure Phonetic Symbol Speech - 拒绝读成字母名称或例词)
  Future<void> speakPhoneticSymbol(String symbol, {VoidCallback? onComplete}) async {
    await init();
    await stop();
    _onComplete = onComplete;

    final rawSymbol = symbol.replaceAll(RegExp(r'[\[\]\/]'), '').trim();
    if (rawSymbol.isEmpty) {
      _onComplete?.call();
      _onComplete = null;
      return;
    }

    // 1. 优先获取纯正爆破音/摩擦音原声音频 MP3 缓存 (使用 ipa_v6_clean_ 前缀刷新本地旧缓存)
    try {
      final audioUrl = _ipaPhonemeAudioUrls[rawSymbol];
      if (audioUrl != null && _cacheDir != null) {
        final localFile = File('${_cacheDir!.path}/ipa_v6_clean_${rawSymbol.hashCode.abs()}.mp3');
        if (await localFile.exists() && (await localFile.length()) > 500) {
          await _audioPlayer.play(DeviceFileSource(localFile.path));
          return;
        }

        final httpClient = HttpClient();
        httpClient.connectionTimeout = const Duration(seconds: 4);
        final request = await httpClient.getUrl(Uri.parse(audioUrl));
        request.headers.set('User-Agent', 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36');
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
      debugPrint('Pure IPA audio fetch error: $e, falling back to TTS cue');
    }

    // 2. 离线/降级方案：使用纯音提示词 (如 [æ] 读纯元音 "ah"，[p] 读 "puh")，拒绝死读字母名或单词
    try {
      final cueText = _ipaTtsCues[rawSymbol] ?? rawSymbol;
      await _flutterTts.setSpeechRate(Platform.isAndroid ? 0.35 : 0.40);
      await _flutterTts.speak(cueText);
    } catch (e) {
      debugPrint('speakPhoneticSymbol fallback error: $e');
      _onComplete?.call();
      _onComplete = null;
    }
  }

  /// 48 国际音标点读发音 (向后兼容)
  Future<void> speakPhonetic(String symbol, String sampleWord, {VoidCallback? onComplete}) async {
    await speakPhoneticSymbol(symbol, onComplete: onComplete);
  }
}
