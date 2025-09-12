import 'package:flutter/material.dart';
import '../models/package_model.dart';
import 'package_card.dart';

class PackageList extends StatelessWidget {
  final List<PackageModel> packages;
  final Function(PackageModel)? onPackageTap;

  const PackageList({super.key, required this.packages, this.onPackageTap});

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return const SizedBox.shrink(); // 没有包裹时不显示任何内容
    }

    try {
      return Column(
        children: packages.map((package) {
          try {
            return PackageCard(
              package: package,
              onTap: onPackageTap != null ? () => onPackageTap!(package) : null,
            );
          } catch (e) {
            print('渲染包裹卡片时出错: $e, 包裹: ${package.packageNumber}');
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Text(
                '包裹显示错误: ${package.packageNumber}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
        }).toList(),
      );
    } catch (e) {
      print('包裹列表渲染错误: $e');
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text('包裹列表加载失败: $e', style: const TextStyle(color: Colors.red)),
      );
    }
  }
}
