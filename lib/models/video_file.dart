class VideoFile {
  final String id;
  final String fileName;
  final String filePath;
  final DateTime timestamp;
  String note;
  final int fileSizeBytes;
  final String format; // mp4, avi, mov, etc.
  final Duration duration;
  final int width;
  final int height;
  final String thumbnailPath;

  VideoFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.timestamp,
    this.note = '视频备注栏',
    this.fileSizeBytes = 10485760, // 默认10MB
    this.format = 'mp4',
    this.duration = const Duration(minutes: 2, seconds: 30),
    this.width = 1920,
    this.height = 1080,
    this.thumbnailPath = '',
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
    } else if (fileSizeBytes < 1024 * 1024 * 1024) {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get resolution {
    return '${width}×${height}';
  }
}
