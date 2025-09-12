import 'package:flutter/material.dart';

class AssetFile {
  final String id;
  final String assetType; // 资产类型：储蓄、房产、证券等
  final String primaryInfo; // 第一条提示词答案
  final String note; // 备注
  final DateTime timestamp;
  final Map<String, String> details; // 详细信息（所有提示词答案）
  final List<Color> colors; // 胶囊颜色

  AssetFile({
    required this.id,
    required this.assetType,
    required this.primaryInfo,
    required this.note,
    required this.timestamp,
    required this.details,
    required this.colors,
  });

  // 格式化时间戳
  String get formattedTimestamp {
    return '（${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}）';
  }
}
