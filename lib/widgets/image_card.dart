import 'package:flutter/material.dart';
import '../models/image_file.dart';

class ImageCard extends StatefulWidget {
  final ImageFile image;
  final VoidCallback? onTap;
  final ValueChanged<String>? onNoteChanged;
  final ValueChanged<String>? onFileNameChanged;

  const ImageCard({
    super.key,
    required this.image,
    this.onTap,
    this.onNoteChanged,
    this.onFileNameChanged,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isEditingNote = false;
  bool _isEditingFileName = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _fileNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.image.note;
    _fileNameController.text = widget.image.fileName;
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
          // 左侧图片缩略图
          GestureDetector(
            onTap: () {
              _showImagePreview();
              widget.onTap?.call();
            },
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3), // 蓝色主题
                borderRadius: BorderRadius.circular(6),
                image: widget.image.filePath.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage('assets/images/sample_image.jpg'),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // 处理图片加载错误
                        },
                      )
                    : null,
              ),
              child: widget.image.filePath.isEmpty
                  ? const Icon(Icons.image, color: Colors.white, size: 20)
                  : null,
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
                        _fileNameController.text = widget.image.fileName;
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
                                    widget.image.fileName,
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
                                  '（${widget.image.timestamp.year}${widget.image.timestamp.month.toString().padLeft(2, '0')}${widget.image.timestamp.day.toString().padLeft(2, '0')} ${widget.image.timestamp.hour.toString().padLeft(2, '0')}:${widget.image.timestamp.minute.toString().padLeft(2, '0')}）',
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
                        _noteController.text = widget.image.note;
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
                            widget.image.note,
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

  // 显示图片预览对话框
  void _showImagePreview() {
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
                        Icons.image,
                        color: Color(0xFF2196F3),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.image.fileName,
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

                // 图片预览区域
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: widget.image.filePath.isNotEmpty
                          ? Image.asset(
                              'assets/images/sample_image.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 64,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '图片加载失败',
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
                                  Icons.image,
                                  size: 64,
                                  color: Colors.white54,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '暂无预览图',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                // 图片详细信息
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '图片信息:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('文件大小', widget.image.formattedFileSize),
                      _buildInfoRow('图片格式', widget.image.format.toUpperCase()),
                      _buildInfoRow('分辨率', widget.image.resolution),
                      _buildInfoRow(
                        '创建时间',
                        '${widget.image.timestamp.year}-${widget.image.timestamp.month.toString().padLeft(2, '0')}-${widget.image.timestamp.day.toString().padLeft(2, '0')} ${widget.image.timestamp.hour.toString().padLeft(2, '0')}:${widget.image.timestamp.minute.toString().padLeft(2, '0')}',
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
