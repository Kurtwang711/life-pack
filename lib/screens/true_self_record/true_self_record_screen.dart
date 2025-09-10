import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';

class TrueSelfRecordScreen extends StatefulWidget {
  const TrueSelfRecordScreen({super.key});

  @override
  State<TrueSelfRecordScreen> createState() => _TrueSelfRecordScreenState();
}

class _TrueSelfRecordScreenState extends State<TrueSelfRecordScreen> {
  int _currentNavIndex = 0;

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 头部区域 - 与录音管理完全一致
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
                          '真我录',
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
            
            // 头像上传区域 - 位于返回键下方
            Positioned(
              top: 114, // 返回键底部(60+44=104) + 10px垂直间距 = 114
              left: 4,  // 距离左侧边线4px
              child: _buildAvatarUploadArea(),
            ),
            
            // 主体内容区域 - 暂时留空，只显示占位文字
            Positioned(
              top: 120,
              left: 140, // 为头像区域让出空间 (4px边距 + 120px宽度 + 16px间距)
              right: 16,
              bottom: 120, // 为底部导航栏留出空间
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: Text(
                    '真我录功能开发中...\n\n请等待后续版本更新',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部导航栏
            Positioned(
              bottom: 30, // 距离底部30px悬浮
              left: 0,
              right: 0,
              child: Center(
                child: CustomBottomNavigation(
                  currentIndex: _currentNavIndex,
                  onTap: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                    // 导航逻辑
                    if (index == 0) {
                      // 首页按钮
                      _navigateToHome();
                    } else if (index == 1) {
                      // 个人中心按钮 - 暂时不实现
                      print('个人中心功能开发中...');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头像上传区域
  Widget _buildAvatarUploadArea() {
    return GestureDetector(
      onTap: _handleAvatarUpload,
      child: Container(
        width: 120,  // 宽度120px
        height: 160, // 高度160px
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12), // 圆角设计
          border: Border.all(
            color: const Color(0xFF333333),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 头像图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white54,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            // 上传提示文字
            const Text(
              '点击上传\n头像',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理头像上传
  void _handleAvatarUpload() {
    // 暂时显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('头像上传功能开发中...'),
        backgroundColor: Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    
    // 这里后续可以集成图片选择器
    // 例如: image_picker 包
    print('触发头像上传功能');
  }
}
