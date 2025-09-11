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

    return Column(
      children: packages.map((package) {
        return PackageCard(
          package: package,
          onTap: onPackageTap != null ? () => onPackageTap!(package) : null,
        );
      }).toList(),
    );
  }
}
