import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../guardian_service/guardian_service_screen.dart';

class WishScreen extends StatefulWidget {
  const WishScreen({super.key});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> {
  int _currentNavIndex = 0;
  String _selectedFilter = '进行中'; // 当前筛选状态

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
                          '许愿',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // 筛选按钮
                    GestureDetector(
                      onTap: _showFilterOptions,
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
                          Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 四个功能按钮
            Positioned(
              top: 120, // 头部下方
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFunctionButton(
                    icon: Icons.add,
                    label: '新增',
                    onTap: () => _handleNewWish(),
                  ),
                  _buildFunctionButton(
                    icon: Icons.history,
                    label: '历史',
                    onTap: () => _handleViewHistory(),
                  ),
                  _buildFunctionButton(
                    icon: Icons.analytics,
                    label: '统计',
                    onTap: () => _handleStatistics(),
                  ),
                  _buildFunctionButton(
                    icon: Icons.list_alt,
                    label: '清单',
                    onTap: () => _handleWishList(),
                  ),
                ],
              ),
            ),

            // 愿望卡片展示区域
            Positioned(
              top: 210, // 功能按钮下方
              left: 16,
              right: 16,
              bottom: 120, // 为底部导航栏留出空间
              child: _buildWishCardsArea(),
            ),

            // 底部导航栏
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
                    if (index == 0) {
                      _navigateToHome();
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

  /// 构建功能按钮 - 30*80px尺寸，与年轮相册设计一致
  Widget _buildFunctionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8E8E8), // 浅灰色渐变起点
              Color(0xFFD0D0D0), // 中等灰色
              Color(0xFFB8B8B8), // 较深灰色渐变终点
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建愿望卡片展示区域
  Widget _buildWishCardsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 当前筛选状态显示
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
          ),
          child: Text(
            '当前筛选: $_selectedFilter',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 愿望卡片列表
        Expanded(
          child: ListView.builder(
            itemCount: _getFilteredWishes().length,
            itemBuilder: (context, index) {
              final wish = _getFilteredWishes()[index];
              return _buildWishCard(wish);
            },
          ),
        ),
      ],
    );
  }

  /// 构建单个愿望卡片
  Widget _buildWishCard(Map<String, dynamic> wish) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: wish['status'] == '进行中'
              ? Colors.orange.withOpacity(0.5)
              : Colors.green.withOpacity(0.5),
          width: 1,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 愿望标题和状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  wish['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: wish['status'] == '进行中'
                      ? Colors.orange.withOpacity(0.8)
                      : Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  wish['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 愿望描述
          Text(
            wish['description'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // 创建时间
          Text(
            '创建于: ${wish['createdAt']}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示筛选选项
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '筛选愿望',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _buildFilterOption('进行中'),
              const SizedBox(height: 12),
              _buildFilterOption('已实现'),
            ],
          ),
        );
      },
    );
  }

  /// 构建筛选选项
  Widget _buildFilterOption(String option) {
    final isSelected = _selectedFilter == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = option;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.white,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取筛选后的愿望列表
  List<Map<String, dynamic>> _getFilteredWishes() {
    final allWishes = _getDemoWishes();
    return allWishes
        .where((wish) => wish['status'] == _selectedFilter)
        .toList();
  }

  /// 获取演示数据
  List<Map<String, dynamic>> _getDemoWishes() {
    return [
      {
        'title': '学会一门新语言',
        'description': '希望能在今年内学会基础的日语对话，能够进行简单的日常交流。',
        'status': '进行中',
        'createdAt': '2024-01-15',
      },
      {
        'title': '完成马拉松比赛',
        'description': '参加并完成一场全程马拉松比赛，挑战自己的体能极限。',
        'status': '已实现',
        'createdAt': '2023-10-20',
      },
      {
        'title': '读完50本书',
        'description': '今年的阅读目标是50本书，涵盖文学、历史、科技等各个领域。',
        'status': '进行中',
        'createdAt': '2024-01-01',
      },
      {
        'title': '学会弹钢琴',
        'description': '从零开始学习钢琴，希望能弹奏出一首完整的曲子。',
        'status': '已实现',
        'createdAt': '2023-08-15',
      },
      {
        'title': '环游世界',
        'description': '计划在未来几年内游览世界各大洲，体验不同的文化和风景。',
        'status': '进行中',
        'createdAt': '2024-02-10',
      },
    ];
  }

  /// 处理新增愿望
  void _handleNewWish() {
    _showSnackBar('新增愿望功能开发中...');
  }

  /// 处理查看历史
  void _handleViewHistory() {
    _showSnackBar('查看历史功能开发中...');
  }

  /// 处理统计
  void _handleStatistics() {
    _showSnackBar('统计功能开发中...');
  }

  /// 处理生成愿望清单
  void _handleWishList() {
    _showSnackBar('生成愿望清单功能开发中...');
  }

  /// 显示提示信息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
