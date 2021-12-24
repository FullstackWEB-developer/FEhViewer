import 'package:english_words/english_words.dart';
import 'package:fehviewer/route/routes.dart';
import 'package:get/get.dart';

import 'sublist_controller.dart';
import 'default_tabview_controller.dart';

List<String> titleList = [
  '画廊测试',
  '画廊',
  '画廊画廊',
  '单词',
  '列表',
  '列表',
  '列表',
  '列表',
  '列表',
  '只可意会',
  '不可言传',
  '点点点',
];

/// 控制所有自定义列表
class CustomListController extends DefaultTabViewController {
  CustomListController();

  final titles = <String>[].obs;
  final wordList = <WordPair>[].obs;

  @override
  void onInit() {
    tabTag = EHRoutes.coutomlist;
    titles.addAll(titleList);

    for (final title in titleList) {
      Get.lazyPut(() => SubListController(), tag: title);
    }

    super.onInit();
  }
}
