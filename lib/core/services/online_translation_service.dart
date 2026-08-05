import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class OnlineTranslationService {
  /// 使用 Dart 原生 HttpClient 调用极速网络翻译 API（零外部 package 依赖）
  static Future<String?> translate(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return '';

    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);

      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh-CN&dt=t&q=${Uri.encodeComponent(cleanText)}',
      );

      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)');

      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> data = jsonDecode(responseBody);
        if (data.isNotEmpty && data[0] is List) {
          final List<dynamic> sentences = data[0];
          final StringBuffer sb = StringBuffer();
          for (var item in sentences) {
            if (item is List && item.isNotEmpty && item[0] != null) {
              sb.write(item[0].toString());
            }
          }
          final result = sb.toString();
          if (result.isNotEmpty) {
            return result;
          }
        }
      }
    } catch (e) {
      debugPrint('Online translation failed: $e');
    } finally {
      client?.close();
    }
    return null;
  }
}
