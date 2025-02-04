import 'dart:async';

import 'package:fehviewer/config/config.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:fehviewer/utils/openl/openl_translator.dart';
import 'package:google_translator/translator.dart';
import 'package:learning_language/learning_language.dart';

import 'language.dart';

TranslatorHelper translatorHelper = TranslatorHelper();

class TranslatorHelper {
  final _languageIdentifier = LanguageIdentifier();

  GoogleTranslator googleTranslator = GoogleTranslator();

  Future<String?> getOpenLApikey() async {
    return FeConfig.openLapikey;
  }

  Future<OpenlTranslation?> openLtranslate(
    String sourceText, {
    String from = 'auto',
    String to = 'en',
    String service = 'deepl',
  }) async {
    final String? apikey = await getOpenLApikey();
    if (apikey == null || apikey.isEmpty) {
      return null;
    }

    final OpenLTranslator openLTranslator = OpenLTranslator(apikey: apikey);
    return openLTranslator.translate(
      sourceText,
      from: from,
      to: to,
      service: service,
    );
  }

  Future<String?> getfallbackService() async {
    final String? apikey = await getOpenLApikey();
    if (apikey == null || apikey.isEmpty) {
      return null;
    }
    final OpenLTranslator openLTranslator = OpenLTranslator(apikey: apikey);
    return await openLTranslator.getFallbackService();
  }

  Future<String?> translateText(
    String sourceText, {
    String to = 'zh',
    String service = 'deepl',
  }) async {
    logger.d('translateText');

    // 通过语言识别器识别语言
    String sourceLanguage = await _languageIdentifier.identify(sourceText);
    logger.d('sourceLanguage: $sourceLanguage');
    if (sourceLanguage == 'und' || sourceLanguage.contains('-')) {
      sourceLanguage = 'auto';
    }

    if (!OpenLLanguageList.contains(sourceLanguage)) {
      return await translateTextByGoogle(
            sourceText,
            sourceLanguage: sourceLanguage,
            to: to,
          ) ??
          '';
    }

    OpenlTranslation? result = await openLtranslate(
      sourceText,
      from: sourceLanguage,
      to: to,
      service: service,
    );

    if (result?.status ?? false) {
      return result?.result ?? '';
    } else {
      final service = await getfallbackService();
      if (service != null) {
        logger.d('getFallbackService $service');
        try {
          final result = await openLtranslate(
            sourceText,
            from: sourceLanguage,
            to: to,
            service: service,
          );
          return result?.result ?? '';
        } catch (e, stack) {
          logger.e('$e\n$stack');

          // 使用 google 翻译
          return await translateTextByGoogle(
                sourceText,
                sourceLanguage: sourceLanguage,
                to: to,
              ) ??
              '';
        }
      }
    }
    return null;
  }

  Future<String?> translateTextByGoogle(
    String sourceText, {
    String? sourceLanguage,
    String to = 'zh',
  }) async {
    logger.d('translateTextByGoogle');
    try {
      final googleTranslateResult = await googleTranslator.translate(
        sourceText,
        from: sourceLanguage ?? 'auto',
        to: to == 'zh' ? 'zh-cn' : to,
      );
      final resultText = googleTranslateResult.text;
      return resultText;
    } catch (e, stack) {
      logger.e('$e\n$stack');
    }
    return null;
  }
}
