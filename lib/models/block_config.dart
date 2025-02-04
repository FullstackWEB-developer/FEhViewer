import 'package:flutter/foundation.dart';

import 'block_rule.dart';

@immutable
class BlockConfig {
  const BlockConfig({
    this.filterCommentsByScore,
    this.scoreFilteringThreshold,
    this.ruleForTitle,
    this.ruleForUploader,
    this.ruleForCommentator,
    this.ruleForComment,
  });

  final bool? filterCommentsByScore;
  final int? scoreFilteringThreshold;
  final List<BlockRule>? ruleForTitle;
  final List<BlockRule>? ruleForUploader;
  final List<BlockRule>? ruleForCommentator;
  final List<BlockRule>? ruleForComment;

  factory BlockConfig.fromJson(Map<String, dynamic> json) => BlockConfig(
      filterCommentsByScore: json['filter_comments_by_score'] != null
          ? json['filter_comments_by_score'] as bool
          : null,
      scoreFilteringThreshold: json['score_filtering_threshold'] != null
          ? json['score_filtering_threshold'] as int
          : null,
      ruleForTitle: json['rule_for_title'] != null
          ? (json['rule_for_title'] as List? ?? [])
              .map((e) => BlockRule.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      ruleForUploader: json['rule_for_uploader'] != null
          ? (json['rule_for_uploader'] as List? ?? [])
              .map((e) => BlockRule.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      ruleForCommentator: json['rule_for_commentator'] != null
          ? (json['rule_for_commentator'] as List? ?? [])
              .map((e) => BlockRule.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      ruleForComment: json['rule_for_comment'] != null
          ? (json['rule_for_comment'] as List? ?? [])
              .map((e) => BlockRule.fromJson(e as Map<String, dynamic>))
              .toList()
          : null);

  Map<String, dynamic> toJson() => {
        'filter_comments_by_score': filterCommentsByScore,
        'score_filtering_threshold': scoreFilteringThreshold,
        'rule_for_title': ruleForTitle?.map((e) => e.toJson()).toList(),
        'rule_for_uploader': ruleForUploader?.map((e) => e.toJson()).toList(),
        'rule_for_commentator':
            ruleForCommentator?.map((e) => e.toJson()).toList(),
        'rule_for_comment': ruleForComment?.map((e) => e.toJson()).toList()
      };

  BlockConfig clone() => BlockConfig(
      filterCommentsByScore: filterCommentsByScore,
      scoreFilteringThreshold: scoreFilteringThreshold,
      ruleForTitle: ruleForTitle?.map((e) => e.clone()).toList(),
      ruleForUploader: ruleForUploader?.map((e) => e.clone()).toList(),
      ruleForCommentator: ruleForCommentator?.map((e) => e.clone()).toList(),
      ruleForComment: ruleForComment?.map((e) => e.clone()).toList());

  BlockConfig copyWith(
          {bool? filterCommentsByScore,
          int? scoreFilteringThreshold,
          List<BlockRule>? ruleForTitle,
          List<BlockRule>? ruleForUploader,
          List<BlockRule>? ruleForCommentator,
          List<BlockRule>? ruleForComment}) =>
      BlockConfig(
        filterCommentsByScore:
            filterCommentsByScore ?? this.filterCommentsByScore,
        scoreFilteringThreshold:
            scoreFilteringThreshold ?? this.scoreFilteringThreshold,
        ruleForTitle: ruleForTitle ?? this.ruleForTitle,
        ruleForUploader: ruleForUploader ?? this.ruleForUploader,
        ruleForCommentator: ruleForCommentator ?? this.ruleForCommentator,
        ruleForComment: ruleForComment ?? this.ruleForComment,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockConfig &&
          filterCommentsByScore == other.filterCommentsByScore &&
          scoreFilteringThreshold == other.scoreFilteringThreshold &&
          ruleForTitle == other.ruleForTitle &&
          ruleForUploader == other.ruleForUploader &&
          ruleForCommentator == other.ruleForCommentator &&
          ruleForComment == other.ruleForComment;

  @override
  int get hashCode =>
      filterCommentsByScore.hashCode ^
      scoreFilteringThreshold.hashCode ^
      ruleForTitle.hashCode ^
      ruleForUploader.hashCode ^
      ruleForCommentator.hashCode ^
      ruleForComment.hashCode;
}
