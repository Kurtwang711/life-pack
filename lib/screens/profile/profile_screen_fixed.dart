import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../guardian_service/guardian_service_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 2; // 个人中心在底部导航栏的索引

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
              SingleChildScrollView(
                child: Column(
                  children: [
                    // 头部用户信息卡片
                    _buildUserInfoHeader(),

                    // 数据统计行
                    _buildStatsRow(),

                    const SizedBox(height: 16),

                    // 我的积分区域
                    _buildPointsSection(),

                    // 我的钱包区域
                    _buildWalletSection(),

                    // 管理区域
                    _buildManagementSection(),

                    // 其他区域
                    _buildOtherSection(),

                    const SizedBox(height: 100), // 给底部导航栏留空间
                  ],
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
                        // 首页
                        Navigator.of(context).pop(); // 返回首页
                      } else if (index == 1) {
                        // 守望服务
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const GuardianServiceScreen(),
                          ),
                        );
                      }
                      // index == 2 是当前页面（个人中心），无需跳转
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

  // 头部用户信息卡片
  Widget _buildUserInfoHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 左侧头像上传区域
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1), // 紫蓝色
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, color: Colors.white, size: 24),
                SizedBox(height: 4),
                Text(
                  '上传头像',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 用户信息区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '点击设置昵称',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.edit, color: Colors.grey[400], size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '账户号：USER_MFDJMTDJ_Z6AZK5',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '手机号：点击设置',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.edit, color: Colors.grey[400], size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 三个状态卡片 - 统一尺寸80*80px，间距4px
  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusCard('实名认证', Icons.check_circle, Colors.green, ''),
          const SizedBox(width: 4), // 间距改为4px
          _buildStatusCard(
            '会员资格',
            Icons.workspace_premium,
            Colors.purple,
            '2025-01-15',
          ),
          const SizedBox(width: 4), // 间距改为4px
          _buildStatusCard('存储容量', Icons.storage, Colors.blue, '1.2G/2G'),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      width: 80, // 统一宽度为80px
      height: 80, // 统一高度为80px
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4), // 方形圆角
              ),
              child: Icon(icon, color: Colors.white, size: 12),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Color(0x4D000000),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 7,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 我的积分区域 - 卡片式容器
  Widget _buildPointsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700), // 金黄色
                  borderRadius: BorderRadius.circular(4), // 方形圆角
                ),
                child: const Icon(Icons.stars, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                '我的积分',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Text(
                '2,580分',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCustomButton('挣积分', 80, 40)),
              const SizedBox(width: 8),
              Expanded(child: _buildCustomButton('花积分', 80, 40)),
              const SizedBox(width: 8),
              Expanded(child: _buildCustomButton('积分明细', 80, 40)),
            ],
          ),
        ],
      ),
    );
  }

  // 我的钱包区域 - 卡片式容器
  Widget _buildWalletSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50), // 绿色
                  borderRadius: BorderRadius.circular(4), // 方形圆角
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '我的钱包',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCustomButton('现金余额\n¥128.50', 80, 50)),
              const SizedBox(width: 8),
              Expanded(child: _buildCustomButton('消费明细', 80, 40)),
              const SizedBox(width: 8),
              Expanded(child: _buildCustomButton('充值提现', 80, 40)),
            ],
          ),
        ],
      ),
    );
  }

  // 管理区域 - 卡片式容器
  Widget _buildManagementSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3), // 蓝色
                  borderRadius: BorderRadius.circular(4), // 方形圆角
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '管理区',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCustomButton('联系人', 70, 35),
              _buildCustomButton('主题皮肤', 70, 35),
              _buildCustomButton('登录密码', 70, 35),
            ],
          ),
        ],
      ),
    );
  }

  // 其他区域 - 卡片式容器
  Widget _buildOtherSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800), // 橙色
                  borderRadius: BorderRadius.circular(4), // 方形圆角
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '其他区',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCustomButton('帮助中心', 70, 35),
              _buildCustomButton('意见反馈', 70, 35),
              _buildCustomButton('关于我们', 70, 35),
              _buildCustomButton('隐私政策', 70, 35),
              _buildCustomButton('用户协议', 70, 35),
              _buildCustomButton('退出登录', 70, 35),
            ],
          ),
        ],
      ),
    );
  }

  // 构建自定义按钮 - 与首页消息按钮样式一致
  Widget _buildCustomButton(
    String text,
    double width,
    double height, [
    VoidCallback? onTap,
  ]) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$text 功能开发中...'),
                backgroundColor: const Color(0xFF2a2a2a),
                duration: const Duration(seconds: 1),
              ),
            );
          },
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
