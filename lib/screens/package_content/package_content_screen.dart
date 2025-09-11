import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';

class PackageContentScreen extends StatefulWidget {
  final String packageNumber;
  final int sequenceNumber;

  const PackageContentScreen({
    super.key,
    required this.packageNumber,
    required this.sequenceNumber,
  });

  @override
  State<PackageContentScreen> createState() => _PackageContentScreenState();
}

class _PackageContentScreenState extends State<PackageContentScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1419),
              Color(0xFF1C1C1E),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 主要内容区域
            SafeArea(
              child: Column(
                children: [
                  // 顶部导航栏
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // 返回按钮
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
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
                            '#${widget.sequenceNumber}包裹内容管理',
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
                  
                  // 内容区域
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // 包裹信息头部
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '包裹编号: ${widget.packageNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '序列号: #${widget.sequenceNumber}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 分割线
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          
                          // 文件列表区域
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '包裹内容',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // 空状态提示
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open,
                                            size: 64,
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '包裹内容为空',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.5),
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '点击下方按钮添加文件',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.4),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // 添加文件按钮
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // TODO: 实现添加文件功能
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('添加文件功能开发中...'),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      label: const Text(
                                        '添加文件',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF51A5FF),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 悬浮底部导航栏
            Positioned(
              bottom: 30,
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
                      // 首页
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    } else if (index == 1) {
                      // 守望服务
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GuardianServiceScreen(),
                        ),
                      );
                    } else if (index == 2) {
                      // 个人中心
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
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
}
