import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageSubmissionDialog extends StatefulWidget {
  const MessageSubmissionDialog({super.key});

  @override
  State<MessageSubmissionDialog> createState() => _MessageSubmissionDialogState();
}

class _MessageSubmissionDialogState extends State<MessageSubmissionDialog> {
  final TextEditingController _textController = TextEditingController();
  final int _maxLength = 20; // 最多20个汉字

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入投稿内容'),
          backgroundColor: Color(0xFF666666),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 处理投稿逻辑
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('投稿成功：$text'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 260,
        constraints: const BoxConstraints(minHeight: 200),
        child: Stack(
          children: [
            // 主体容器 - 参考HTML样式
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF7E7E7E),
                    Color(0xFF363636),
                    Color(0xFF363636),
                    Color(0xFF363636),
                    Color(0xFF363636),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 头部 - 关闭按钮
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 输入区域
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          // 文本输入框
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _textController,
                              maxLength: _maxLength,
                              maxLines: 3,
                              minLines: 3,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                hintText: '写点什么投稿吧...✦˚',
                                hintStyle: TextStyle(
                                  color: Color(0xFFF3F6FD),
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                                counterStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(_maxLength),
                              ],
                            ),
                          ),
                          
                          // 操作区域
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 提交按钮
                                GestureDetector(
                                  onTap: _handleSubmit,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF555555),
                                          Color(0xFF292929),
                                          Color(0xFF555555),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          blurRadius: 2,
                                          offset: const Offset(0, -4),
                                          blurStyle: BlurStyle.inner,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.send,
                                        color: Color(0xFF8B8B8B),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 底部提示
                    Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text(
                        '投稿经录用会赠送一周会员资格',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 光效装饰 - 参考HTML中的::after效果
            Positioned(
              top: -10,
              left: -10,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
