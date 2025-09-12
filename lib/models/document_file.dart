class DocumentFile {
  final String id;
  String fileName;
  final String filePath;
  DateTime timestamp;
  String note;
  final int fileSizeBytes;
  final String format; // pdf, doc, docx, txt, md, etc.
  final DocumentType type; // note or file

  DocumentFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.timestamp,
    this.note = '',
    required this.fileSizeBytes,
    required this.format,
    required this.type,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) {
      return '${fileSizeBytes}B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}

enum DocumentType {
  note, // 笔记
  file, // 文件
}
