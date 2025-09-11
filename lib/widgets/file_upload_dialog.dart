import 'package:flutter/material.dart';

class FileUploadDialog extends StatefulWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const FileUploadDialog({
    super.key,
    this.onConfirm,
    this.onCancel,
  });

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  bool _isConfirmHovered = false;
  bool _isCancelHovered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFF666666), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 200,
              spreadRadius: -50,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 自定义云朵上传SVG图标
              Container(
                height: 50,
                width: 50,
                child: CustomPaint(
                  painter: CloudUploadPainter(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 文本
              const Text(
                '是否添加文件到包裹',
                style: TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // 按钮容器
              Row(
                children: [
                  // "好" 按钮
                  Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isConfirmHovered = true),
                      onExit: (_) => setState(() => _isConfirmHovered = false),
                      child: GestureDetector(
                        onTap: widget.onConfirm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isConfirmHovered 
                                ? const Color(0xFF888888) 
                                : const Color(0xFF666666),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '好',
                            style: TextStyle(
                              color: _isConfirmHovered 
                                  ? Colors.white 
                                  : const Color(0xFFEEEEEE),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  
                  // "不" 按钮
                  Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isCancelHovered = true),
                      onExit: (_) => setState(() => _isCancelHovered = false),
                      child: GestureDetector(
                        onTap: widget.onCancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isCancelHovered 
                                ? const Color(0xFF888888) 
                                : const Color(0xFF666666),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '不',
                            style: TextStyle(
                              color: _isCancelHovered 
                                  ? Colors.white 
                                  : const Color(0xFFEEEEEE),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 自定义画笔绘制云朵上传图标
class CloudUploadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF666666)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // 基于SVG路径绘制云朵上传图标
    // 这是简化版的云朵形状
    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.cubicTo(
      size.width * 0.1, size.height * 0.7,
      size.width * 0.05, size.height * 0.6,
      size.width * 0.05, size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.05, size.height * 0.3,
      size.width * 0.2, size.height * 0.2,
      size.width * 0.4, size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.45, size.height * 0.1,
      size.width * 0.6, size.height * 0.1,
      size.width * 0.65, size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.85, size.height * 0.2,
      size.width * 0.95, size.height * 0.35,
      size.width * 0.95, size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.95, size.height * 0.6,
      size.width * 0.85, size.height * 0.7,
      size.width * 0.8, size.height * 0.7,
    );
    path.lineTo(size.width * 0.2, size.height * 0.7);

    canvas.drawPath(path, paint);

    // 绘制上传箭头
    final arrowPaint = Paint()
      ..color = const Color(0xFF666666)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 箭头线条
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.8),
      arrowPaint,
    );

    // 箭头头部
    final arrowPath = Path();
    arrowPath.moveTo(size.width * 0.4, size.height * 0.55);
    arrowPath.lineTo(size.width * 0.5, size.height * 0.45);
    arrowPath.lineTo(size.width * 0.6, size.height * 0.55);

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
