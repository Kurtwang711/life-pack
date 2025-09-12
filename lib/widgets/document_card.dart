import 'package:flutter/material.dart';
import '../models/document_file.dart';
import 'document_note_viewer.dart';
import 'edit_document_dialog.dart';

class DocumentCard extends StatelessWidget {
  final DocumentFile document;
  final VoidCallback? onTap;
  final Function(String)? onNoteChanged;
  final Function(String)? onFileNameChanged;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onNoteChanged,
    this.onFileNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // 与录音、图片、视频卡片一致
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ), // 与其他卡片一致
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3), // 与其他卡片一致
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      child: Row(
        children: [
          // 左侧文档图标作为缩略图
          GestureDetector(
            onTap: () => _handleIconTap(context),
            child: Container(
              width: 32, // 与其他卡片一致
              height: 32, // 与其他卡片一致
              margin: const EdgeInsets.only(left: 4), // 与其他卡片一致
              decoration: BoxDecoration(
                color: _getDocumentColor(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getDocumentIcon(),
                color: Colors.white,
                size: 20, // 与其他卡片一致
              ),
            ),
          ),

          // 右侧文字信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8), // 与其他卡片一致
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 第一行：文件名 + 时间戳
                  SizedBox(
                    height: 14, // 与其他卡片一致
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            document.fileName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12, // 与其他卡片一致
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '（${document.timestamp.year}${document.timestamp.month.toString().padLeft(2, '0')}${document.timestamp.day.toString().padLeft(2, '0')} ${document.timestamp.hour.toString().padLeft(2, '0')}:${document.timestamp.minute.toString().padLeft(2, '0')}）',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10, // 与其他卡片一致
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 1), // 与其他卡片一致
                  // 第二行：备注文字
                  Text(
                    document.note.isNotEmpty ? document.note : '无备注',
                    style: TextStyle(
                      color: document.note.isNotEmpty
                          ? Colors.white70
                          : const Color(0xFF666666),
                      fontSize: 12, // 与其他卡片一致
                      fontWeight: FontWeight.normal,
                      fontStyle: document.note.isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // 右侧编辑按钮（可选，保持与其他卡片的编辑方式一致）
          GestureDetector(
            onTap: () => _showEditDialog(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.edit, color: Color(0xFF999999), size: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _handleIconTap(BuildContext context) {
    if (document.type == DocumentType.note) {
      // 预览笔记
      showDialog(
        context: context,
        builder: (context) => DocumentNoteViewer(document: document),
      );
    } else {
      // 引导用户使用外部程序打开文件
      _showOpenFileDialog(context);
    }
  }

  void _showOpenFileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text('打开文件', style: TextStyle(color: Colors.white)),
        content: Text(
          '是否使用外部应用打开 ${document.fileName}？',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('正在打开外部应用...'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text('打开', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditDocumentDialog(
        document: document,
        onFileNameChanged: onFileNameChanged,
        onNoteChanged: onNoteChanged,
      ),
    );
  }

  IconData _getDocumentIcon() {
    switch (document.format.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
      case 'md':
        return Icons.text_snippet;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        if (document.type == DocumentType.note) {
          return Icons.note;
        }
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor() {
    switch (document.format.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFE53E3E); // 红色
      case 'doc':
      case 'docx':
        return const Color(0xFF2B6CB0); // 蓝色
      case 'txt':
      case 'md':
        return const Color(0xFF38A169); // 绿色
      case 'xls':
      case 'xlsx':
        return const Color(0xFF38A169); // 绿色
      case 'ppt':
      case 'pptx':
        return const Color(0xFFD69E2E); // 橙色
      default:
        if (document.type == DocumentType.note) {
          return const Color(0xFF9F7AEA); // 紫色
        }
        return const Color(0xFF718096); // 灰色
    }
  }
}
