import 'package:flutter/material.dart';
import '../models/document_file.dart';

class DocumentNoteViewer extends StatelessWidget {
  final DocumentFile document;

  const DocumentNoteViewer({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Stack(
          children: [
            // 主体容器
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
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 头部 - 标题和关闭按钮
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // 文档图标
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF9F7AEA,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.note,
                              color: Color(0xFF9F7AEA),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 标题
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  document.fileName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  document.formattedTimestamp,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 关闭按钮
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _getDocumentContent(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 光效装饰
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
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.1),
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

  String _getDocumentContent() {
    // 这里应该从文件路径读取实际内容
    // 目前返回模拟内容
    if (document.type == DocumentType.note) {
      return '''今天是一个美好的日子，阳光明媚，心情愉悦。

在这个特殊的时刻，我想记录下一些重要的想法和感受。

生活中总是充满了各种各样的挑战和机遇，我们需要保持积极的心态去面对每一天。

无论遇到什么困难，都要相信自己有能力克服。每一次的挫折都是成长的机会，每一次的成功都是努力的回报。

希望未来的日子里，能够继续保持这份热情和动力，去追求更好的自己。

记录时间：${document.formattedTimestamp}
文件大小：${document.formattedSize}''';
    } else {
      return '这是一个 ${document.format.toUpperCase()} 文件，请使用相应的应用程序打开查看完整内容。';
    }
  }
}
