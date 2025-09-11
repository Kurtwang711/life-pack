import 'package:flutter/material.dart';

/// 通用文件展示区组件
/// 与包裹内容管理页面样式保持一致
class VaultFileDisplayArea extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color titleColor;
  final String emptyMessage;
  final String emptySubMessage;
  final IconData emptyIcon;
  final Widget? child;

  const VaultFileDisplayArea({
    super.key,
    required this.title,
    required this.icon,
    required this.titleColor,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.emptyIcon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Row(
            children: [
              Icon(
                icon,
                color: titleColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 文件列表区域
          Expanded(
            child: child ?? _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            emptyIcon,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            emptySubMessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
