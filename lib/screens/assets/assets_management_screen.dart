import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';

class AssetsManagementScreen extends StatefulWidget {
  const AssetsManagementScreen({super.key});

  @override
  State<AssetsManagementScreen> createState() => _AssetsManagementScreenState();
}

class _AssetsManagementScreenState extends State<AssetsManagementScreen> {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4332), // 墨绿偏暗色
              Color(0xFF2D5016), // 深绿色
              Color(0xFF081C15), // 更深的绿黑色
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
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
                // 头部区域
                Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // 返回按钮
                      GestureDetector(
                        onTap: _navigateToHome,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF333333),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),

                      // 居中标题
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            '资产管理',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // 右侧占位，保持标题居中
                      const SizedBox(width: 36),
                    ],
                  ),
                ),

                // 功能区域 (搜索框 + 功能按钮)
                Positioned(
                  top: 112, // 调整为与录音管理页面一致的112px
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 44, // 添加与录音管理页面一致的高度
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ), // 添加与录音管理页面一致的padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 搜索容器 (45%宽度)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45 - 16,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 36, // 调整为与录音管理页面一致的36px高度
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF333333),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14, // 调整字体大小适配36px高度
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '搜索资产',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 14,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Color(0xFF666666),
                                        size: 18, // 调整图标大小
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

                // 资产信息列表区域
                Positioned(
                  top: 156,
                  left: 16,
                  right: 16,
                  bottom: 80, // 为底部导航留出空间
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
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
                            Icons.account_balance_wallet,
                            color: Color(0xFF666666),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '暂无资产信息',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '点击上方"+"按钮添加新的资产记录',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 底部导航 (完全复用首页的导航组件)
                Positioned(
                  bottom: 30, // 距离底部30px悬浮
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CustomBottomNavigation(
                      currentIndex: 0, // 首页索引
                      onTap: (index) {
                        setState(() {
                          // 更新当前导航索引
                        });
                        // 导航逻辑
                        if (index == 0) {
                          // 当前页面是从首页进入的，无需跳转
                        } else if (index == 1) {
                          // 守望服务
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GuardianServiceScreen(),
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
        ),
      ),
    );
  }

  // 新建按钮 (+ 图标)
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // TODO: 实现新建资产功能
        print('点击了新建按钮');
      },
      child: Container(
        width: 70, // 调整为与录音管理页面一致的70px宽度
        height: 36, // 调整为与录音管理页面一致的36px高度
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
            size: 18, // 调整图标大小适配36px高度
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
    );
  }

  // 功能按钮 (采用首页分享和消息按钮同样的风格)
  Widget _buildFunctionButton(String text) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现对应功能
        print('点击了$text按钮');
      },
      child: Container(
        width: 70, // 调整为与录音管理页面一致的70px宽度
        height: 36, // 调整为与录音管理页面一致的36px高度
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
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 12, // 调整字体大小适配36px高度
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
    );
  }
}
