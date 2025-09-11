import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recording_file.dart';

class RecordingCard extends StatefulWidget {
  final RecordingFile recording;
  final VoidCallback? onPlay;
  final ValueChanged<String>? onNoteChanged;
  final ValueChanged<String>? onFileNameChanged;

  const RecordingCard({
    super.key,
    required this.recording,
    this.onPlay,
    this.onNoteChanged,
    this.onFileNameChanged,
  });

  @override
  State<RecordingCard> createState() => _RecordingCardState();
}

class _RecordingCardState extends State<RecordingCard> {
  bool _isEditingNote = false;
  bool _isEditingFileName = false;
  bool _showPlayer = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _fileNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.recording.note;
    _fileNameController.text = widget.recording.fileName;
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
    return Column(
      children: [
        // 录音卡片
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF333333),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // 左侧播放器图标
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPlayer = !_showPlayer;
                  });
                  widget.onPlay?.call();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
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
                            _fileNameController.text = widget.recording.fileName;
                          });
                          // 延迟聚焦，确保TextField已经构建完成
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
                                      widget.onFileNameChanged?.call(_fileNameController.text);
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
                                        widget.recording.fileName,
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
                                      '（${widget.recording.timestamp.year}${widget.recording.timestamp.month.toString().padLeft(2, '0')}${widget.recording.timestamp.day.toString().padLeft(2, '0')} ${widget.recording.timestamp.hour.toString().padLeft(2, '0')}:${widget.recording.timestamp.minute.toString().padLeft(2, '0')}）',
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
                            _noteController.text = widget.recording.note;
                          });
                          // 延迟聚焦，确保TextField已经构建完成
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
                                    widget.onNoteChanged?.call(_noteController.text);
                                  },
                                ),
                              )
                            : Text(
                                widget.recording.note,
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
        ),
        
        // 播放器（展开时显示）
        if (_showPlayer) _buildPlayer(),
      ],
    );
  }

  // 构建播放器
  Widget _buildPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 播放控制区
          _buildPlayControls(),
          
          const SizedBox(height: 8),
          
          // 倍速控制
          _buildSpeedControls(),
          
          const SizedBox(height: 8),
          
          // 转文字功能
          _buildTranscriptButton(),
        ],
      ),
    );
  }

  // 播放控制
  Widget _buildPlayControls() {
    return Row(
      children: [
        // 快退按钮
        IconButton(
          onPressed: () {
            print('快退');
          },
          icon: const Icon(
            Icons.replay_10,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        // 播放/暂停按钮
        IconButton(
          onPressed: () {
            print('播放/暂停');
          },
          icon: const Icon(
            Icons.play_arrow,
            color: Color(0xFF4CAF50),
            size: 28,
          ),
        ),
        
        // 快进按钮
        IconButton(
          onPressed: () {
            print('快进');
          },
          icon: const Icon(
            Icons.forward_10,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        // 进度条
        Expanded(
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF4CAF50),
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: const Color(0xFF4CAF50),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackHeight: 2,
                ),
                child: Slider(
                  value: 0.3, // 当前进度
                  onChanged: (value) {
                    print('进度: $value');
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '01:05',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    widget.recording.formattedDuration,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
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

  // 倍速控制
  Widget _buildSpeedControls() {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    double currentSpeed = 1.0;
    
    return Row(
      children: [
        Text(
          '倍速:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 4,
            children: speeds.map((speed) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentSpeed = speed;
                  });
                  print('设置倍速: ${speed}x');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: currentSpeed == speed
                        ? const Color(0xFF4CAF50)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: currentSpeed == speed
                          ? const Color(0xFF4CAF50)
                          : Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${speed}x',
                    style: TextStyle(
                      color: currentSpeed == speed
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 转文字按钮
  Widget _buildTranscriptButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showTranscriptDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        icon: const Icon(Icons.text_fields, size: 16),
        label: const Text('转文字', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  // 显示转文字对话框
  void _showTranscriptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D3748),
          title: const Text(
            'AI语音识别',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: 300,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '识别结果:',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    child: const SingleChildScrollView(
                      child: Text(
                        '这是一段示例的语音识别文本内容。实际使用时，这里会显示AI识别后的文字结果。功能开发中...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '关闭',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('文本已复制到剪贴板'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('复制'),
            ),
          ],
        );
      },
    );
  }
}
