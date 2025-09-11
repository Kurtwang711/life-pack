class RecordingFile {
  final String id;
  final String fileName;
  final String filePath;
  final DateTime timestamp;
  String note;
  final Duration duration;

  RecordingFile({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.timestamp,
    this.note = '录音备注栏',
    this.duration = const Duration(minutes: 3, seconds: 25), // 默认时长
  });

  String get displayName {
    // 格式化显示名称：文件名（时间戳）
    final formattedTime = '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return '$fileName（$formattedTime）';
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
