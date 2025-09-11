import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
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
                            '文档管理',
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

                // 搜索框和功能按钮区域
                Positioned(
                  top: 116,
                  left: 16,
                  right: 16,
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 搜索框 (45%宽度)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45 - 24,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 36,
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
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '搜索文档',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 14,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Color(0xFF666666),
                                        size: 18,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 10,
                                      ),
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
                              // 新增按钮 (+ 图标)
                              _buildAddButton(),

                              // 上传按钮 (减少20%宽度)
                              _buildFunctionButton('上传'),

                              // 编辑按钮 (减少20%宽度)
                              _buildFunctionButton('编辑'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 文档列表区域 (预留空间)
                Positioned(
                  top: 156,
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
                            Icons.description_outlined,
                            color: Color(0xFF666666),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '暂无文档',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '点击上传按钮添加文档',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                      currentIndex: 0,
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

  // 新增按钮 (+ 图标, 宽30px)
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // TODO: 实现新增文档功能
        print('点击了新增按钮');
      },
      child: Container(
        width: 30,
        height: 36,
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
            size: 18,
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

  // 功能按钮 (减少20%宽度：70 * 0.8 = 56)
  Widget _buildFunctionButton(String text) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现对应功能
        print('点击了$text按钮');
      },
      child: Container(
        width: 56, // 减少20%宽度: 70 * 0.8 = 56
        height: 36,
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
    );
  }
}
