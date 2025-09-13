import 'package:flutter/material.dart';

class AssetClueDialog extends StatefulWidget {
  final String assetType;
  final List<Color> colors;
  final List<String> labels;
  final String explanation;
  final Function(String, List<String>, List<Color>) onCreateAsset;

  const AssetClueDialog({
    super.key,
    required this.assetType,
    required this.colors,
    required this.labels,
    required this.explanation,
    required this.onCreateAsset,
  });

  static Future<void> show({
    required BuildContext context,
    required String assetType,
    required List<Color> colors,
    required List<String> labels,
    required String explanation,
    required Function(String, List<String>, List<Color>) onCreateAsset,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AssetClueDialog(
          assetType: assetType,
          colors: colors,
          labels: labels,
          explanation: explanation,
          onCreateAsset: onCreateAsset,
        );
      },
    );
  }

  @override
  State<AssetClueDialog> createState() => _AssetClueDialogState();
}

class _AssetClueDialogState extends State<AssetClueDialog> {
  late final List<TextEditingController> _controllers;
  bool _showExplanation = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.labels.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // 清理所有控制器
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleCreate() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // 收集数据
    final values = _controllers.map((c) => c.text).toList();
    
    // 延迟一帧以确保 UI 更新
    await Future.delayed(const Duration(milliseconds: 50));
    
    // 调用创建回调
    widget.onCreateAsset(
      widget.assetType,
      values,
      widget.colors,
    );
    
    // 关闭对话框
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildInputField(int index) {
    final label = widget.labels[index];
    final isLastField = index == widget.labels.length - 1;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧提示词
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 右侧输入框
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A202C),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4A5568)),
              ),
              child: TextField(
                controller: _controllers[index],
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: isLastField ? 3 : 1, // 备注字段多行
                decoration: InputDecoration(
                  hintText: '请不要填写完整账号和密码！',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isProcessing,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFF2D3748),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF4A5568), width: 1),
          ),
          child: Column(
            children: [
              // 头部
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A202C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.assetType}线索',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (!_isProcessing)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
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

              // 内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 输入字段
                      ...List.generate(
                        widget.labels.length,
                        (index) => _buildInputField(index),
                      ),

                      const SizedBox(height: 16),

                      // 说明按钮
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showExplanation = !_showExplanation;
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A5568),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  '?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '点击查看说明',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),

                      // 说明文字
                      if (_showExplanation) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A202C),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4A5568)),
                          ),
                          child: Text(
                            widget.explanation,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // 确认创建按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _handleCreate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  '确认创建',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 法律声明
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A202C),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF4A5568)),
                        ),
                        child: const Text(
                          '本功能仅为信息提示，不具备任何法律效力，不构成遗嘱或其他任何法律文书。所有权转移最终必须依照法律程序进行。',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
  }
}