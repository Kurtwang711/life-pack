import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../guardian_service/guardian_service_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 2; // 个人中心在底部导航栏的索引

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: SafeArea(
        child: SingleChildScrollView(
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
      ),
      bottomNavigationBar: CustomBottomNavigation(
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
              MaterialPageRoute(builder: (context) => const GuardianServiceScreen()),
            );
          }
          // index == 2 是当前页面（个人中心），无需跳转
        },
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
                Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  '上传头像',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
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
                    Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '账户号：USER_MFDJMTDJ_Z6AZK5',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '手机号：点击设置',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 三个状态卡片
  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              '实名认证',
              Icons.check_circle,
              Colors.green,
              '',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatusCard(
              '会员资格',
              Icons.workspace_premium,
              Colors.purple,
              '2025-01-15',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatusCard(
              '存储容量',
              Icons.storage,
              Colors.blue,
              '1.2G/2G',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }



  // 我的积分区域
  Widget _buildPointsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '积分',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildIconButton('挣积分', Icons.add, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIconButton('花积分', Icons.remove, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIconButton('积分明细', Icons.format_list_bulleted, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 我的钱包区域
  Widget _buildWalletSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '现金',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildIconButton('现金余额', Icons.account_balance_wallet, Colors.green),
                    const SizedBox(height: 8),
                    const Text(
                      '¥128.50',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIconButton('消费明细', Icons.trending_up, Colors.blue),
              ),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()), // 空占位
            ],
          ),
        ],
      ),
    );
  }

  // 管理区域
  Widget _buildManagementSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '管理',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton('联系人', Icons.people, Colors.blue),
              _buildIconButton('主题皮肤', Icons.palette, Colors.purple),
              _buildIconButton('登录密码', Icons.lock, Colors.red),
              _buildIconButton('人脸识别', Icons.face, Colors.green),
              _buildIconButton('邀请码', Icons.card_giftcard, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  // 其他区域
  Widget _buildOtherSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '其他',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton('帮助', Icons.help, Colors.blue),
              _buildIconButton('反馈', Icons.chat_bubble_outline, Colors.green),
              _buildIconButton('评分', Icons.star, Colors.orange),
              _buildIconButton('登出', Icons.logout, Colors.red),
              _buildIconButton('注销账户', Icons.delete_forever, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  // 通用图标按钮
  Widget _buildIconButton(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 功能开发中...'),
            backgroundColor: const Color(0xFF2a2a2a),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
