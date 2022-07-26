import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:fehviewer/common/global.dart';
import 'package:fehviewer/common/service/ehconfig_service.dart';
import 'package:fehviewer/common/service/layout_service.dart';
import 'package:fehviewer/common/service/theme_service.dart';
import 'package:fehviewer/component/setting_base.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:fehviewer/generated/l10n.dart';
import 'package:fehviewer/utils/cust_lib/flutter_egg.dart';
import 'package:fehviewer/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget cps = Obx(() {
      return CupertinoPageScaffold(
          backgroundColor: !ehTheme.isDarkMode
              ? CupertinoColors.secondarySystemBackground
              : null,
          navigationBar: CupertinoNavigationBar(
            middle: Text(L10n.of(context).about),
          ),
          child: SafeArea(
            bottom: false,
            child: ListViewAbout(),
          ));
    });

    return cps;
  }
}

class ListViewAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EhConfigService _ehConfigService = Get.find();

    return Container(
      child: ListView(
        children: <Widget>[
          Egg(
            child: TextItem(
              '${Global.packageInfo.appName} ',
              desc: 'an unofficial e-hentai app',
              onTap: null,
            ),
            onTrigger: (int tapNum, int neededNum) {
              if (Platform.isIOS) {
                if (_ehConfigService.isSafeMode.value) {
                  // showToast('你发现了不得了的东西');
                  logger.v('safeMode off');
                  _ehConfigService.isSafeMode.value = false;
                  Vibrate.feedback(FeedbackType.success);
                } else {
                  // showToast('ヾ(￣▽￣)Bye~Bye~');
                  logger.v('safeMode on');
                  _ehConfigService.isSafeMode.value = true;
                  Vibrate.feedback(FeedbackType.error);
                }
              }
            },
          ),
          TextItem(
            L10n.of(context).version,
            desc:
                '${Global.packageInfo.version}(${Global.packageInfo.buildNumber})',
            onTap: null,
          ),
          TextItem(
            L10n.of(context).author,
            desc: 'honjow  <honjow311@gmail.com>',
            onTap: () => launchUrlString('mailto:honjow311@gmail.com'),
          ),
          if (!_ehConfigService.isSafeMode.value)
            TextItem(
              'Github',
              desc: 'https://github.com/honjow/FEhViewer',
              onTap: () =>
                  launchUrlString('https://github.com/honjow/FEhViewer'),
            ),
          TextItem(
            'Telegram',
            onTap: () =>
                launchUrlString('https://t.me/joinchat/AEj27KMQe0JiMmUx'),
          ),
          TextItem(
            'Telegram Channel',
            desc: 'https://t.me/fehviewer',
            onTap: () => launchUrlString('https://t.me/fehviewer'),
          ),
          TextItem(
            L10n.of(context).license,
            onTap: () {
              Get.toNamed(
                EHRoutes.license,
                id: isLayoutLarge ? 2 : null,
              );
            },
          ),
          TextItem(
            L10n.of(context).donate,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(L10n.of(context).donate),
                    content: Container(
                      // padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CupertinoButton(
                              child: Column(
                                children: [
                                  ExtendedImage.asset(
                                    'assets/images/afdian.png',
                                    width: 50,
                                  ),
                                  Text(
                                    '爱发电',
                                  ),
                                ],
                              ),
                              onPressed: () {
                                launchUrlString('https://afdian.net/@honjow');
                              }),
                          CupertinoButton(
                            child: Column(
                              children: [
                                ExtendedImage.asset(
                                  'assets/images/dundun.png',
                                  width: 40,
                                ).paddingSymmetric(vertical: 6),
                                Text(
                                  '顿顿饭',
                                ),
                              ],
                            ),
                            onPressed: () {
                              launchUrlString(
                                  'https://dun.mianbaoduo.com/@honjow');
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(L10n.of(context).cancel),
                        onPressed: Get.back,
                      ),
                    ],
                  );
                },
              );
            },
            hideLine: true,
          ),
        ],
      ),
    );
  }
}
