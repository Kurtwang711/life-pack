import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/vault_file_display_area.dart';

class RecordingManagementScreen extends StatefulWidget {
  const RecordingManagementScreen({super.key});

  @override
  State<RecordingManagementScreen> createState() =>
      _RecordingManagementScreenState();
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
                        '录音管理',
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
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              _buildFunctionButton('上传'),

                              // 编辑按钮
                              _buildFunctionButton('编辑'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 录音列表区域
                Positioned(
                  top: 156,
                  left: 16,
                  right: 16,
                  bottom: 120,
                  child: VaultFileDisplayArea(
                    title: '录音文件列表',
                    icon: Icons.mic,
                    titleColor: const Color(0xFF4CAF50), // 绿色主题
                    emptyMessage: '暂无录音文件',
                    emptySubMessage: '点击上传按钮开始录制或添加录音文件\n支持mp3、wav、m4a等格式',
                    emptyIcon: Icons.mic_none_outlined,
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
    )
  }

  Widget _buildFunctionButton(String text) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现对应功能
        print('点击了$text按钮');
      },
      child: Container(
        width: 70,
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
