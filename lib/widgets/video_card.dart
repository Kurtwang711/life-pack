import 'package:flutter/material.dart';
import '../models/video_file.dart';

class VideoCard extends StatefulWidget {
  final VideoFile video;
  final VoidCallback? onTap;
  final ValueChanged<String>? onNoteChanged;
  final ValueChanged<String>? onFileNameChanged;

  const VideoCard({
    super.key,
    required this.video,
    this.onTap,
    this.onNoteChanged,
    this.onFileNameChanged,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _isEditingNote = false;
  bool _isEditingFileName = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _fileNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.video.note;
    _fileNameController.text = widget.video.fileName;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _fileNameController.dispose();
    _noteFocusNode.dispose();
    _fileNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      child: Row(
        children: [
          // 左侧视频缩略图
          GestureDetector(
            onTap: () {
              _showVideoPlayer();
              widget.onTap?.call();
            },
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0), // 紫色主题
                borderRadius: BorderRadius.circular(6),
                image: widget.video.thumbnailPath.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(
                          'assets/images/sample_video_thumbnail.jpg',
                        ),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // 处理缩略图加载错误
                        },
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (widget.video.thumbnailPath.isEmpty)
                    const Center(
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  // 播放按钮覆盖层
                  const Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 右侧文字信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 第一行：文件名 + 时间戳
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingFileName = true;
                        _fileNameController.text = widget.video.fileName;
                      });
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (_isEditingFileName) {
                          _fileNameFocusNode.requestFocus();
                        }
                      });
                    },
                    child: _isEditingFileName
                        ? SizedBox(
                            height: 14,
                            child: TextField(
                              controller: _fileNameController,
                              focusNode: _fileNameFocusNode,
                              autofocus: true,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _isEditingFileName = false;
                                });
                                if (value.isNotEmpty) {
                                  widget.onFileNameChanged?.call(value);
                                }
                              },
                              onTapOutside: (event) {
                                setState(() {
                                  _isEditingFileName = false;
                                });
                                if (_fileNameController.text.isNotEmpty) {
                                  widget.onFileNameChanged?.call(
                                    _fileNameController.text,
                                  );
                                }
                              },
                            ),
                          )
                        : SizedBox(
                            height: 14,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.video.fileName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '（${widget.video.timestamp.year}${widget.video.timestamp.month.toString().padLeft(2, '0')}${widget.video.timestamp.day.toString().padLeft(2, '0')} ${widget.video.timestamp.hour.toString().padLeft(2, '0')}:${widget.video.timestamp.minute.toString().padLeft(2, '0')}）',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 1),

                  // 第二行：备注（可编辑）
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingNote = true;
                        _noteController.text = widget.video.note;
                      });
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (_isEditingNote) {
                          _noteFocusNode.requestFocus();
                        }
                      });
                    },
                    child: _isEditingNote
                        ? SizedBox(
                            height: 14,
                            child: TextField(
                              controller: _noteController,
                              focusNode: _noteFocusNode,
                              autofocus: true,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _isEditingNote = false;
                                });
                                widget.onNoteChanged?.call(value);
                              },
                              onTapOutside: (event) {
                                setState(() {
                                  _isEditingNote = false;
                                });
                                widget.onNoteChanged?.call(
                                  _noteController.text,
                                );
                              },
                            ),
                          )
                        : Text(
                            widget.video.note,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 显示视频播放器对话框
  void _showVideoPlayer() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // 标题栏
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.videocam,
                        color: Color(0xFF9C27B0),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.video.fileName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // 视频播放器区域
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 视频预览背景
                        Center(
                          child: widget.video.thumbnailPath.isNotEmpty
                              ? Image.asset(
                                  'assets/images/sample_video_thumbnail.jpg',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.videocam_off,
                                          size: 64,
                                          color: Colors.white54,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          '视频加载失败',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      size: 64,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '暂无预览',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        // 播放控制层
                        Positioned.fill(child: _buildVideoPlayer()),
                      ],
                    ),
                  ),
                ),

                // 视频详细信息
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '视频信息:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('文件大小', widget.video.formattedFileSize),
                      _buildInfoRow('视频格式', widget.video.format.toUpperCase()),
                      _buildInfoRow('分辨率', widget.video.resolution),
                      _buildInfoRow('视频时长', widget.video.formattedDuration),
                      _buildInfoRow(
                        '创建时间',
                        '${widget.video.timestamp.year}-${widget.video.timestamp.month.toString().padLeft(2, '0')}-${widget.video.timestamp.day.toString().padLeft(2, '0')} ${widget.video.timestamp.hour.toString().padLeft(2, '0')}:${widget.video.timestamp.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 构建视频播放器
  Widget _buildVideoPlayer() {
    return Column(
      children: [
        // 上方空间
        const Spacer(),

        // 播放控制区域
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Column(
            children: [
              // 播放控制按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 快退按钮
                  IconButton(
                    onPressed: () {
                      print('快退');
                    },
                    icon: const Icon(
                      Icons.replay_10,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 播放/暂停按钮
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        print('播放/暂停');
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 快进按钮
                  IconButton(
                    onPressed: () {
                      print('快进');
                    },
                    icon: const Icon(
                      Icons.forward_10,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 进度条
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF9C27B0),
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: const Color(0xFF9C27B0),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: 0.3, // 当前进度
                  onChanged: (value) {
                    print('进度: $value');
                  },
                ),
              ),

              // 时间显示
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:45',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.video.formattedDuration,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
