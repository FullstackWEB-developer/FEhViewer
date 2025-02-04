import 'package:fehviewer/common/controller/block_controller.dart';
import 'package:fehviewer/common/service/layout_service.dart';
import 'package:fehviewer/component/setting_base.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BlockRuleEditPage extends GetView<BlockController> {
  const BlockRuleEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String _title = L10n.of(context).edit_block_rule;

    final BlockRule? _blockRuleFromArg =
        Get.arguments is BlockRule ? Get.arguments as BlockRule : null;

    BlockRule _blockRule = _blockRuleFromArg ??
        BlockRule(
          ruleText: '',
          blockType: controller.latestBlockType?.name ?? BlockType.title.name,
          enabled: true,
          enableRegex: controller.latestEnableRegex ?? false,
        );

    controller.blockRuleTextEditingController.text = _blockRule.ruleText ?? '';
    controller.currentEnableRegex = _blockRule.enableRegex ?? false;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_title),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0),
          minSize: 40,
          child: const Icon(
            CupertinoIcons.check_mark_circled,
            size: 28,
          ),
          onPressed: controller.isRegexFormatError
              ? null
              : () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  logger.d('_blockRule ${_blockRule.toJson()}');
                  Get.back<BlockRule>(
                    id: isLayoutLarge ? 2 : null,
                    result: _blockRule,
                  );
                },
        ),
      ),
      child: CustomScrollView(slivers: [
        SliverSafeArea(
          sliver: MultiSliver(
            children: [
              SliverCupertinoListSection.listInsetGrouped(children: [
                // enable switch
                EhCupertinoListTile(
                  title: Text(L10n.of(context).enable),
                  trailing: StatefulBuilder(builder: (context, setState) {
                    return CupertinoSwitch(
                      value: _blockRule.enabled ?? true,
                      onChanged: (val) {
                        _blockRule = _blockRule.copyWith(enabled: val);
                        setState(() {});
                      },
                    );
                  }),
                ),

                // regex switch
                EhCupertinoListTile(
                  title: Text(L10n.of(context).regex),
                  trailing: StatefulBuilder(builder: (context, setState) {
                    return CupertinoSwitch(
                      value: _blockRule.enableRegex ?? false,
                      onChanged: (val) {
                        _blockRule = _blockRule.copyWith(enableRegex: val);
                        controller.currentEnableRegex = val;
                        setState(() {});
                      },
                    );
                  }),
                ),
                _BlockTypeSelector(
                  initValue: BlockType.values
                      .byName(_blockRule.blockType ?? BlockType.title.name),
                  onChanged: (BlockType value) {
                    controller.latestBlockType = value;
                    _blockRule = _blockRule.copyWith(blockType: value.name);
                  },
                ),
              ]),
              SliverCupertinoListSection.listInsetGrouped(
                header: Text(L10n.of(context).block_rule),
                children: [
                  CupertinoTextField(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: null,
                    maxLines: null,
                    controller: controller.blockRuleTextEditingController,
                    placeholder: L10n.of(context).block_rule,
                    placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.placeholderText,
                      height: 1.25,
                    ),
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(height: 1.3),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      logger.t('value $value');
                      _blockRule = _blockRule.copyWith(
                          ruleText: value.replaceAll('\n', ' '));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _BlockTypeSelector extends StatefulWidget {
  const _BlockTypeSelector({
    super.key,
    this.onChanged,
    this.initValue,
  });

  final ValueChanged<BlockType>? onChanged;
  final BlockType? initValue;

  @override
  State<_BlockTypeSelector> createState() => _BlockTypeSelectorState();
}

class _BlockTypeSelectorState extends State<_BlockTypeSelector> {
  final segmentedPadding =
      const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
  final segmentedTextStyle = const TextStyle(height: 1.1, fontSize: 14);

  BlockType? _initValue;

  @override
  void initState() {
    super.initState();
    _initValue = widget.initValue;
  }

  Widget _buildSlidingSegmentedAction(String title) {
    return Container(
      child: Text(
        title,
        style: segmentedTextStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      padding: segmentedPadding,
      // constraints: BoxConstraints(minWidth: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        constraints: const BoxConstraints(minHeight: kItemHeight),
        child: SafeArea(
          child: CupertinoSlidingSegmentedControl<BlockType>(
            children: <BlockType, Widget>{
              BlockType.title:
                  _buildSlidingSegmentedAction(L10n.of(context).title),
              BlockType.uploader:
                  _buildSlidingSegmentedAction(L10n.of(context).uploader),
              BlockType.commentator:
                  _buildSlidingSegmentedAction(L10n.of(context).commentator),
              BlockType.comment:
                  _buildSlidingSegmentedAction(L10n.of(context).comment),
            },
            groupValue: _initValue,
            onValueChanged: (BlockType? value) {
              setState(() {
                _initValue = value;
              });
              widget.onChanged?.call(value!);
            },
          ),
        ),
      ),
    );
  }
}
