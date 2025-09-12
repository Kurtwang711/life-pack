class ImageFile {
  final String id;
  final String fileName;
  final String filePath;
  final DateTime timestamp;
  String note;
  final int fileSizeBytes;
  final String format; // jpg, png, gif, etc.
  final int width;
  final int height;

  ImageFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.timestamp,
    this.note = '图片备注栏',
    this.fileSizeBytes = 2048576, // 默认2MB
    this.format = 'jpg',
    this.width = 1920,
    this.height = 1080,
  });

  String get displayName {
    // 格式化显示名称：文件名（时间戳）
    final formattedTime =
        '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return '$fileName（$formattedTime）';
  }

  String get formattedFileSize {
    if (fileSizeBytes < 1024) {
      return '${fileSizeBytes}B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  String get resolution {
    return '${width}×${height}';
  }
}
