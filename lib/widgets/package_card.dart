import 'package:flutter/material.dart';
import '../models/package_model.dart';

class PackageCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback? onTap;

  const PackageCard({super.key, required this.package, this.onTap});

  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4), // 卡片间距4px
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A), // 深灰色卡片背景
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF444444), width: 1),
          ),
          child: IntrinsicHeight(
            // 使用IntrinsicHeight让高度自适应内容
            child: Row(
              children: [
                // 左侧序号区域 - 黑色背景与卡片上下端相接
                Container(
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7), // 稍微小一点，确保与卡片边界相接
                      bottomLeft: Radius.circular(7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '#${package.sequenceNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 右侧内容区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 第一行：收件人和手机号，右侧投递方式
                        Row(
                          children: [
                            // 收件人信息
                            Expanded(
                              child: Row(
                                children: [
                                  // 收件人姓名
                                  Text(
                                    package.recipient,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // "收"标签
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF51A5FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '收',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 手机号
                                  Flexible(
                                    child: Text(
                                      package.phone,
                                      style: const TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 投递方式按钮
                            _buildDeliveryMethodButton(),
                          ],
                        ),

                        // 第二行：地址或邮箱（如果有）- 允许换行
                        if (package.hasSecondLine) ...[
                          const SizedBox(height: 6),
                          Text(
                            package.secondLineContent ?? '',
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 12,
                              height: 1.2, // 行高
                            ),
                            maxLines: 3, // 最多3行
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 6),

                        // 第三行：包裹号和时间戳
                        Row(
                          children: [
                            // 包裹号
                            Expanded(
                              child: Text(
                                package.packageNumber,
                                style: const TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontFamily: 'monospace', // 等宽字体
                                ),
                              ),
                            ),
                            // 时间戳
                            Text(
                              _formatDateTime(package.lastModified),
                              style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 11,
                                fontFamily: 'monospace', // 等宽字体保证对齐
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // 如果渲染出错，返回一个错误卡片
      print('包裹卡片渲染错误: $e');
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Text(
          '包裹卡片渲染错误: ${package.packageNumber}',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildDeliveryMethodButton() {
    Color buttonColor;
    switch (package.deliveryMethod) {
      case 'physical_usb':
        buttonColor = const Color(0xFF2ECC71); // 绿色 - 实体U盘
        break;
      case 'email_cloud':
        buttonColor = const Color(0xFF4A90E2); // 蓝色 - 邮箱+网盘
        break;
      case 'package_id_app':
        buttonColor = const Color(0xFFFFA500); // 橙色 - 包裹号登录App
        break;
      default:
        buttonColor = const Color(0xFF666666);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        package.deliveryMethodDisplayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // 格式：20250920 16:20
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
