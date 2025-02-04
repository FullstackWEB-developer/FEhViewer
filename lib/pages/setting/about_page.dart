import 'dart:io';

import 'package:fehviewer/common/controller/update_controller.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  String get debugLabel => kDebugMode
      ? 'Debug'
      : kProfileMode
          ? 'Profile'
          : '';

  @override
  Widget build(BuildContext context) {
    final UpdateController _updateController = Get.put(UpdateController());

    List<Widget> _buildList() {
      final List<Widget> _list = <Widget>[];
      _list.add(
        EhCupertinoListTile(
          title: Text(L10n.of(context).app_title),
          subtitle: const Text('An unofficial e-hentai app'),
        ),
      );
      if (!Platform.isWindows || !Platform.isLinux) {
        _list.add(
          EhCupertinoListTile(
            title: Text(L10n.of(context).version),
            additionalInfo: Text(
                '${Global.packageInfo.version}(${Global.packageInfo.buildNumber}) $debugLabel'),
          ),
        );
      }
      if (!Platform.isWindows || !Platform.isLinux) {
        _list.add(
          EhCupertinoListTile(
            title: Text(L10n.of(context).check_for_update),
            trailing: Obx(() {
              if (_updateController.isChecking) {
                return const CupertinoActivityIndicator();
              } else {
                return const CupertinoListTileChevron();
              }
            }),
            onTap: () {
              _updateController.checkUpdate(showDialog: true);
            },
            subtitle: Text(!_updateController.isLastVersion
                ? L10n.of(context)
                    .update_to_version(_updateController.lastVersion ?? '')
                : '${L10n.of(context).latest_version} ${_updateController.lastVersion ?? ''}'),
          ),
        );
      }
      _list.add(
        EhCupertinoListTile(
          title: Text(L10n.of(context).license),
          trailing: const CupertinoListTileChevron(),
          onTap: () {
            Get.toNamed(EHRoutes.license);
          },
        ),
      );
      return _list;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(L10n.of(context).about),
      ),
      child: CustomScrollView(
        slivers: [
          // CupertinoSliverNavigationBar(
          //   largeTitle: Text(L10n.of(context).about),
          // ),
          SliverSafeArea(
            sliver: MultiSliver(children: [
              SliverCupertinoListSection.insetGrouped(
                hasLeading: false,
                additionalDividerMargin: 6,
                // header: Text('测试测试测试'),
                // footer: Text('测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测'),
                itemBuilder: (context, index) {
                  return _buildList()[index];
                },
                itemCount: _buildList().length,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
