import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';

class RecordingManagementScreen extends StatefulWidget {
  const RecordingManagementScreen({super.key});

  @override
  State<RecordingManagementScreen> createState() => _RecordingManagementScreenState();
}

class _RecordingManagementScreenState extends State<RecordingManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

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
      backgroundColor: const Color(0xFF1a1a1a),
      body: Stack(
        children: [
          // 头部区域
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Container(
              height: 44,
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
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF333333),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  // 居中标题
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '录音管理',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // 右侧占位，保持标题居中
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // 功能区域
          Positioned(
            top: 120,
            left: 16,
            right: 16,
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
                            hintText: '搜索录音...',
                            hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
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
                      // 上传按钮
                      _buildFunctionButton('上传', Icons.upload_outlined),
                      
                      // 编辑按钮  
                      _buildFunctionButton('编辑', Icons.edit_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 录音列表区域 (预留空间)
          Positioned(
            top: 180,
            left: 16,
            right: 16,
            bottom: 120,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF333333),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mic_none_outlined,
                      color: Color(0xFF666666),
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '暂无录音文件',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '点击上传按钮添加录音',
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 底部导航
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigation(
              currentIndex: 0, // 默认首页索引
              onTap: (index) {
                if (index == 0) {
                  _navigateToHome();
                }
                // 其他导航项可以根据需要实现
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现对应功能
        print('点击了$text按钮');
      },
      child: Container(
        width: 70,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF333333),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.8),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                  Shadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: const Offset(0, -1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
