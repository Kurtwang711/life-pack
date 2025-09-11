import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/vault_file_display_area.dart';
import '../../widgets/video_card.dart';
import '../../models/video_file.dart';

class VideoManagementScreen extends StatefulWidget {
  const VideoManagementScreen({super.key});

  @override
  State<VideoManagementScreen> createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<VideoFile> _videos = [
    VideoFile(
      id: '1',
      fileName: '生日派对视频',
      filePath: '/storage/emulated/0/Movies/birthday_party.mp4',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      note: '难忘的生日庆祝',
      fileSizeBytes: 125000000, // 125MB
      format: 'mp4',
      duration: const Duration(seconds: 180), // 3分钟
      thumbnailPath: '/storage/emulated/0/Movies/thumbnails/birthday_party_thumb.jpg',
      width: 1920,
      height: 1080,
    ),
    VideoFile(
      id: '2',
      fileName: '旅游风景',
      filePath: '/storage/emulated/0/Movies/travel_scenery.mov',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      note: '美丽的自然风光',
      fileSizeBytes: 89000000, // 89MB
      format: 'mov',
      duration: const Duration(seconds: 120), // 2分钟
      thumbnailPath: '/storage/emulated/0/Movies/thumbnails/travel_scenery_thumb.jpg',
      width: 1280,
      height: 720,
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

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: VideoCard(
            video: _videos[index],
            onTap: () {
              // 点击播放视频
            },
            onNoteChanged: (note) {
              setState(() {
                _videos[index].note = note;
              });
            },
            onFileNameChanged: (fileName) {
              setState(() {
                _videos[index] = VideoFile(
                  id: _videos[index].id,
                  fileName: fileName,
                  filePath: _videos[index].filePath,
                  timestamp: _videos[index].timestamp,
                  note: _videos[index].note,
                  fileSizeBytes: _videos[index].fileSizeBytes,
                  format: _videos[index].format,
                  duration: _videos[index].duration,
                  thumbnailPath: _videos[index].thumbnailPath,
                  width: _videos[index].width,
                  height: _videos[index].height,
                );
              });
            },
          ),
        );
      },
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.videocam,
                      color: Color(0xFF9C27B0),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '上传视频文件',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          '选择要上传的视频文件',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: 从相册选择
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.video_library,
                            color: Color(0xFF9C27B0),
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '从相册选择',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9C27B0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: 录制视频
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.videocam,
                            color: Color(0xFF9C27B0),
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '录制视频',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9C27B0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: 从文件选择
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.folder,
                            color: Color(0xFF9C27B0),
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '文件选择',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9C27B0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
              Color(0xFF4A1E3F), // 深紫色
              Color(0xFF6B2C91), // 紫色
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
                        '视频管理（${_videos.length}个文件）',
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
                                  hintText: '搜索视频...',
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

              // 视频列表区域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: _videos.isEmpty
                      ? VaultFileDisplayArea(
                          title: '视频文件列表',
                          icon: Icons.videocam,
                          titleColor: const Color(0xFF9C27B0), // 紫色主题
                          emptyMessage: '暂无视频文件',
                          emptySubMessage: '点击上传按钮添加视频文件\n支持mp4、avi、mov、mkv等格式',
                          emptyIcon: Icons.videocam_outlined,
                        )
                      : _buildVideoList(),
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
                  builder: (context) => const GuardianServiceScreen()),
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
          padding: const EdgeInsets.all(8),
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
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
