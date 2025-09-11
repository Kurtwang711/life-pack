import 'package:flutter/material.dart';
import '../../widgets/spring_card.dart';
import '../../widgets/radio_buttons.dart';
import '../../widgets/checkin_section.dart';
import '../../widgets/vault_section.dart';
import '../../widgets/create_package_button.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/package_list.dart';
import '../../services/package_manager.dart';
import '../album/annual_rings_album_screen.dart';
import '../true_self_record/true_self_record_screen.dart';
import '../wish/wish_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  late PackageManager _packageManager;

  @override
  void initState() {
    super.initState();
    try {
      print('HomeScreen initState 开始');
      _packageManager = PackageManager();
      print('PackageManager 实例获取成功');
      
      // 使用WidgetsBinding确保在下一帧加载数据
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (mounted) {
            print('开始加载测试数据');
            _packageManager.loadTestData();
            print('测试数据加载完成');
          }
        } catch (e) {
          print('加载测试数据时发生错误: $e');
        }
      });
    } catch (e) {
      print('HomeScreen 初始化错误: $e');
      // 确保有一个可用的包管理器实例
      _packageManager = PackageManager();
    }
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
          child: Stack(
            children: [
              // 可滚动的内容区域
              SingleChildScrollView(
                child: Column(
                  children: [
                    // 寄语区卡片 - 距离顶部4px，距离左侧4px
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                      child: Row(
                        children: [
                          const SpringCard(),
                          const SizedBox(width: 4),
                          // 右侧按钮组
                          Expanded(
                            child: Column(
                              children: [
                                // 第一排按钮
                                const RadioButtons(
                                  leftButtonText: '分享',
                                  rightButtonText: '消息',
                                ),
                                const SizedBox(height: 4),
                                // 第二排按钮
                                const RadioButtons(
                                  leftButtonText: '客服',
                                  rightButtonText: '主题',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10), // 间距
                    // 签到区
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: CheckinSection(),
                    ),

                    const SizedBox(height: 10), // 间距
                    // 机要库区和右侧按钮组
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 机要库区
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: VaultSection(),
                          ),
                          const SizedBox(width: 4),
                          // 右侧按钮组
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // 年轮相册按钮
                                  _buildCustomButton('年轮相册', 140, 50, () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AnnualRingsAlbumScreen(),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 20),
                                  // 真我录按钮
                                  _buildCustomButton('真我录', 140, 50, () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TrueSelfRecordScreen(),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 18),
                                  // 许愿按钮
                                  _buildCustomButton('许愿', 140, 50, () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WishScreen(),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10), // 间距
                    // 创建包裹按钮 - 居中位置
                    const Center(child: CreatePackageButton()),

                    const SizedBox(height: 4), // 与包裹卡片的4px间距
                    // 包裹卡片列表
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedBuilder(
                        animation: _packageManager,
                        builder: (context, child) {
                          try {
                            if (_packageManager.packages.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            
                            return PackageList(
                              packages: _packageManager.packages,
                              onPackageTap: (package) {
                                // 处理包裹点击事件
                                print('点击了包裹: ${package.packageNumber}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('包裹: ${package.packageNumber}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                            print('包裹列表渲染错误: $e');
                            // 如果包裹列表渲染失败，显示一个简单的消息
                            return Container(
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                '包裹列表加载中...',
                                style: TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 120), // 底部留白，避免被导航栏遮挡
                  ],
                ),
              ),

              // 悬浮底部导航栏
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
                      if (index == 1) {
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
      ),
    );
  }

  // 构建自定义按钮的辅助方法
  Widget _buildCustomButton(
    String text,
    double width,
    double height, [
    VoidCallback? onTap,
  ]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          width: width,
          height: height,
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
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: width > 100 ? 16 : 12, // 根据宽度调整字体大小
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: 0.5,
                height: 0.8,
                shadows: const [
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
