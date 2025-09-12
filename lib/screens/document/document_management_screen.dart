import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/vault_file_display_area.dart';
import '../../widgets/document_card.dart';
import '../../widgets/document_note_editor.dart';
import '../../models/document_file.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<DocumentFile> _documents = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A1B9A), // 深紫色
              Color(0xFF8E24AA), // 紫色
              Color(0xFF9C27B0), // 亮紫色
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 头部区域
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // 返回按钮
                    GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // 标题
                    Expanded(
                      child: Text(
                        '文档管理（${_documents.length}个文件）',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // 占位，保持标题居中
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 搜索和功能区域
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 搜索容器 (45%宽度)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45 - 24,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF333333),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Icon(
                                Icons.search,
                                color: Color(0xFF999999),
                                size: 18,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '搜索文档...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                  isDense: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 功能按钮组 (45%宽度)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45 - 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 新建按钮 (+ 图标) - 与录音管理一致的尺寸
                            _buildAddButton(),

                            // 编辑按钮 - 与录音管理一致的尺寸
                            _buildFunctionButton('编辑'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 文档列表区域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: _documents.isEmpty
                      ? VaultFileDisplayArea(
                          title: '文档文件列表',
                          icon: Icons.description,
                          titleColor: const Color(0xFF9C27B0), // 紫色主题
                          emptyMessage: '暂无文档文件',
                          emptySubMessage:
                              '点击新建按钮开始创建笔记或上传文档\n支持pdf、doc、txt等格式',
                          emptyIcon: Icons.description_outlined,
                        )
                      : _buildDocumentList(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            // 更新当前导航索引
          });
          // 导航逻辑
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GuardianServiceScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // 构建添加按钮 - 与录音管理完全一致的尺寸和样式
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showDocumentOptions,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 58,
          height: 28, // 总高度36px，减去padding 8px = 28px
          padding: const EdgeInsets.all(6), // 减少内边距以适应36px高度
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF333333), Color(0xFF242323)],
            ),
            border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 16,
              shadows: [
                Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 3,
                  color: Color(0x4D000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建功能按钮 - 与录音管理完全一致的尺寸和样式
  Widget _buildFunctionButton(String title) {
    return GestureDetector(
      onTap: () {
        print('点击了$title按钮');
      },
      child: Container(
        height: 36, // 匹配搜索框高度
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ), // 调整垂直内边距
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF333333), Color(0xFF242323)],
            ),
            border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: 0.5,
                height: 0.8,
                shadows: [
                  Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 3,
                    color: Color(0x4D000000),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 显示文档选项对话框 - 类似录音管理的模态框
  void _showDocumentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D3748),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              const Text(
                '选择文档类型',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 写笔记选项
              ListTile(
                leading: const Icon(
                  Icons.note_add,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  '写笔记',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  '创建新的文本笔记',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showNoteEditor();
                },
              ),

              // 上传本地文件选项
              ListTile(
                leading: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  '上传本地文件',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  '选择本地文档文件',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectLocalFile();
                },
              ),

              const SizedBox(height: 16),

              // 取消按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5568),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('取消'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 显示笔记编辑器
  void _showNoteEditor() {
    showDialog(
      context: context,
      builder: (context) => DocumentNoteEditor(
        onSave: (fileName, content) {
          // 创建新的笔记文档
          final newDocument = DocumentFile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: fileName,
            filePath: '/storage/emulated/0/Documents/$fileName.note',
            timestamp: DateTime.now(),
            note: '个人笔记',
            fileSizeBytes: content.length * 2, // 估算字节数
            format: 'note',
            type: DocumentType.note,
          );

          setState(() {
            _documents.insert(0, newDocument);
          });
        },
      ),
    );
  }

  // 选择本地文件
  void _selectLocalFile() {
    // 模拟文件选择器
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在选择本地文件...'),
        backgroundColor: Color(0xFF9C27B0),
        duration: Duration(seconds: 1),
      ),
    );

    // 模拟添加文件
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _documents.insert(
          0,
          DocumentFile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: '新上传文档',
            filePath: '/storage/emulated/0/Documents/new_document.pdf',
            timestamp: DateTime.now(),
            note: '刚刚上传的文档',
            fileSizeBytes: 1500000, // 1.5MB
            format: 'pdf',
            type: DocumentType.file,
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('文档文件添加成功'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  // 构建文档列表
  Widget _buildDocumentList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final document = _documents[index];
          return DocumentCard(
            document: document,
            onTap: () {
              // 点击查看文档
            },
            onNoteChanged: (note) {
              setState(() {
                document.note = note;
              });
            },
            onFileNameChanged: (fileName) {
              setState(() {
                // 创建新的文档对象，更新文件名和时间戳
                _documents[index] = DocumentFile(
                  id: document.id,
                  fileName: fileName,
                  filePath: document.filePath,
                  timestamp: DateTime.now(), // 使用当前时间作为更新时间戳
                  note: document.note,
                  fileSizeBytes: document.fileSizeBytes,
                  format: document.format,
                  type: document.type,
                );
              });
            },
          );
        },
      ),
    );
  }
}
