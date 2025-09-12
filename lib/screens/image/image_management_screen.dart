import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/vault_file_display_area.dart';
import '../../widgets/image_card.dart';
import '../../models/image_file.dart';

class ImageManagementScreen extends StatefulWidget {
  const ImageManagementScreen({super.key});

  @override
  State<ImageManagementScreen> createState() => _ImageManagementScreenState();
}

class _ImageManagementScreenState extends State<ImageManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<ImageFile> _images = [
    ImageFile(
      id: '1',
      fileName: '旅行风景照',
      filePath: '/storage/emulated/0/Pictures/travel_scenery.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      note: '美丽的自然风光',
      fileSizeBytes: 3500000, // 3.5MB
      format: 'jpg',
      width: 3840,
      height: 2160,
    ),
    ImageFile(
      id: '2',
      fileName: '家庭聚会',
      filePath: '/storage/emulated/0/Pictures/family_gathering.png',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      note: '温馨的家庭时光',
      fileSizeBytes: 2800000, // 2.8MB
      format: 'png',
      width: 2560,
      height: 1440,
    ),
  ];

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

  Widget _buildImageList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return ImageCard(
            image: _images[index],
            onTap: () {
              // 点击查看图片
            },
            onNoteChanged: (note) {
              setState(() {
                _images[index].note = note;
              });
            },
            onFileNameChanged: (fileName) {
              setState(() {
                _images[index] = ImageFile(
                  id: _images[index].id,
                  fileName: fileName,
                  filePath: _images[index].filePath,
                  timestamp: DateTime.now(), // 使用当前时间作为更新时间戳
                  note: _images[index].note,
                  fileSizeBytes: _images[index].fileSizeBytes,
                  format: _images[index].format,
                  width: _images[index].width,
                  height: _images[index].height,
                );
              });
            },
          );
        },
      ),
    );
  }

  // 显示图片选项对话框 - 与录音管理和文档管理一致的底部模态框
  void _showUploadDialog() {
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
                '选择图片来源',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 从相册选择选项
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  '从相册选择',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  '从手机相册中选择图片',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectFromGallery();
                },
              ),

              // 拍照选项
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  '拍照',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  '使用相机拍摄新照片',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),

              // 从文件选择选项
              ListTile(
                leading: const Icon(
                  Icons.folder,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  '从文件选择',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  '选择本地图片文件',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectFromFiles();
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

  // 从相册选择
  void _selectFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在从相册选择图片...'),
        backgroundColor: Color(0xFF2196F3),
        duration: Duration(seconds: 1),
      ),
    );

    // 模拟添加图片
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _images.insert(
          0,
          ImageFile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: '新图片',
            filePath: '/storage/emulated/0/Pictures/new_image.jpg',
            timestamp: DateTime.now(),
            note: '从相册选择的图片',
            fileSizeBytes: 2500000,
            format: 'jpg',
            width: 1920,
            height: 1080,
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片添加成功'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  // 拍照
  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在启动相机...'),
        backgroundColor: Color(0xFF2196F3),
        duration: Duration(seconds: 1),
      ),
    );

    // 模拟拍照
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _images.insert(
          0,
          ImageFile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: '拍摄照片',
            filePath: '/storage/emulated/0/Pictures/camera_photo.jpg',
            timestamp: DateTime.now(),
            note: '刚刚拍摄的照片',
            fileSizeBytes: 3200000,
            format: 'jpg',
            width: 2560,
            height: 1440,
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('照片拍摄成功'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  // 从文件选择
  void _selectFromFiles() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在选择本地文件...'),
        backgroundColor: Color(0xFF2196F3),
        duration: Duration(seconds: 1),
      ),
    );

    // 模拟文件选择
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _images.insert(
          0,
          ImageFile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fileName: '本地图片',
            filePath: '/storage/emulated/0/Pictures/local_image.png',
            timestamp: DateTime.now(),
            note: '从文件选择的图片',
            fileSizeBytes: 1800000,
            format: 'png',
            width: 1280,
            height: 720,
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片文件添加成功'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
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
              Color(0xFF1565C0), // 深蓝色
              Color(0xFF1976D2), // 蓝色
              Color(0xFF2196F3), // 亮蓝色
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
                          color: Colors.white.withOpacity(0.1),
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
                        '图片管理（${_images.length}个文件）',
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
                          color: Colors.black.withOpacity(0.6),
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
                                  hintText: '搜索图片...',
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
                            // 新建按钮 (+ 图标)
                            _buildAddButton(),

                            // 编辑按钮
                            _buildFunctionButton('编辑'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 图片列表区域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: _images.isEmpty
                      ? VaultFileDisplayArea(
                          title: '图片文件列表',
                          icon: Icons.image,
                          titleColor: const Color(0xFF2196F3), // 蓝色主题
                          emptyMessage: '暂无图片文件',
                          emptySubMessage: '点击上传按钮添加图片文件\n支持jpg、png、gif等格式',
                          emptyIcon: Icons.image_not_supported_outlined,
                        )
                      : _buildImageList(),
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

  // 构建添加按钮 - 采用首页年轮相册按钮同样的风格
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showUploadDialog,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 58,
          height: 28,
          padding: const EdgeInsets.all(6),
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
                color: Colors.black.withOpacity(0.2),
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

  // 构建功能按钮 - 采用首页年轮相册按钮同样的风格
  Widget _buildFunctionButton(String title) {
    return GestureDetector(
      onTap: () {
        print('点击了$title按钮');
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                color: Colors.black.withOpacity(0.2),
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
}
