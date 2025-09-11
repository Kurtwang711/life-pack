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
  String _nickname = "生如夏花";
  final String _accountId = "1398888888";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF0f0f0f)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头部用户信息卡片
                _buildUserInfoCard(),
                
                const SizedBox(height: 20),
                
                // 数据统计区域
                _buildStatsSection(),
                
                const SizedBox(height: 20),
                
                // 认证和会员状态
                _buildStatusSection(),
                
                const SizedBox(height: 20),
                
                // 我的积分
                _buildPointsSection(),
                
                const SizedBox(height: 20),
                
                // 我的钱包
                _buildWalletSection(),
                
                const SizedBox(height: 20),
                
                // 管理功能
                _buildManagementSection(),
                
                const SizedBox(height: 20),
                
                // 其他功能
                _buildOtherSection(),
                
                const SizedBox(height: 100), // 给底部导航栏留空间
                
                const SizedBox(height: 100), // 为底部导航栏留出空间
              ],
            ),
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
  Widget _buildUserInfoCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF2E5266), // 深蓝色
            Color(0xFF4A90E2), // 浅蓝色
          ],
        ),
      ),
      child: Row(
        children: [
          // 左侧头像区域
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const CircleAvatar(
              radius: 47,
              backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          
          // 中间用户信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '账号：$_accountId',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右侧设置图标
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // 数据统计区域
  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('77', '剩余存储空间'),
        ),
        Expanded(
          child: _buildStatItem('3', '包裹数量'),
        ),
        Expanded(
          child: _buildStatItem('55', '现金'),
        ),
        Expanded(
          child: _buildStatItem('200', '积分'),
        ),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 认证和会员状态
  Widget _buildStatusSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            '实名认证',
            Icons.verified_user,
            Colors.green,
            true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            '年卡会员',
            Icons.card_membership,
            Colors.purple,
            true,
            subtitle: '2025年1月2日 到期',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatusCard(
            '存储容量',
            Icons.storage,
            Colors.blue,
            false,
            subtitle: '1.2G/2G',
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, IconData icon, Color color, bool verified, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
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
          if (subtitle != null) ...[
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

  // 我的积分
  Widget _buildPointsSection() {
    return Column(
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
              child: _buildFunctionItem('挣积分', Icons.add_circle, Colors.green),
            ),
            Expanded(
              child: _buildFunctionItem('花积分', Icons.remove_circle, Colors.orange),
            ),
            Expanded(
              child: _buildFunctionItem('积分明细', Icons.list, Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  // 我的钱包
  Widget _buildWalletSection() {
    return Column(
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
                  _buildFunctionItem('现金余额', Icons.account_balance_wallet, Colors.green),
                  const SizedBox(height: 8),
                  const Text(
                    '¥128.50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildFunctionItem('消费明细', Icons.trending_up, Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  // 管理功能
  Widget _buildManagementSection() {
    return Column(
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
            _buildFunctionItem('联系人', Icons.contacts, Colors.blue),
            _buildFunctionItem('主题皮肤', Icons.palette, Colors.purple),
            _buildFunctionItem('登录密码', Icons.lock, Colors.red),
            _buildFunctionItem('人脸识别', Icons.face, Colors.green),
            _buildFunctionItem('邀请码', Icons.card_giftcard, Colors.orange),
          ],
        ),
      ],
    );
  }

  // 其他功能
  Widget _buildOtherSection() {
    return Column(
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
            _buildFunctionItem('帮助', Icons.help, Colors.blue),
            _buildFunctionItem('反馈', Icons.feedback, Colors.green),
            _buildFunctionItem('评分', Icons.star, Colors.orange),
            _buildFunctionItem('登出', Icons.logout, Colors.red),
            _buildFunctionItem('注销账户', Icons.delete_forever, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildFunctionItem(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现具体功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 功能开发中...'),
            backgroundColor: const Color(0xFF2a2a2a),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B5A87), Color(0xFF1E3A5F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '生如夏花',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '账号：1398888888',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // 设置按钮
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB84D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // 数据统计卡片
  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('77', '剩余存储空间'),
          _buildStatItem('3', '包裹数量'),
          _buildStatItem('55', '现金'),
          _buildStatItem('200', '积分'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // 认证和会员卡片
  Widget _buildVerificationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 实名认证
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B5A87),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '实名认证',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 年卡会员
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '年卡会员',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '2025年1月2日 到期',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9ACD32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '续费',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 我的积分卡片
  Widget _buildPointsCard() {
    return _buildSectionCard(
      '我的积分',
      [
        _buildIconItem(Icons.star_border, '挣积分', Colors.orange),
        _buildIconItem(Icons.shopping_cart, '花积分', Colors.orange),
        _buildIconItem(Icons.list_alt, '积分明细', Colors.orange),
      ],
    );
  }

  // 我的钱包卡片
  Widget _buildWalletCard() {
    return _buildSectionCard(
      '我的钱包',
      [
        _buildIconItem(Icons.account_balance_wallet, '提现', Colors.red),
        _buildIconItem(Icons.receipt_long, '收支明细', Colors.red),
      ],
    );
  }

  // 管理功能卡片
  Widget _buildManagementCard() {
    return _buildSectionCard(
      '管理',
      [
        _buildIconItem(Icons.contacts, '联系人', Colors.blue),
        _buildIconItem(Icons.palette, '主题皮肤', Colors.blue),
        _buildIconItem(Icons.lock, '登录密码', Colors.blue),
        _buildIconItem(Icons.face, '人脸识别', Colors.blue),
        _buildIconItem(Icons.qr_code_scanner, '邀请码', Colors.blue),
      ],
    );
  }

  // 其他功能卡片
  Widget _buildOtherFunctionsCard() {
    return _buildSectionCard(
      '其他',
      [
        _buildIconItem(Icons.help_outline, '帮助', Colors.purple),
        _buildIconItem(Icons.feedback, '反馈', Colors.purple),
        _buildIconItem(Icons.star_rate, '评分', Colors.purple),
        _buildIconItem(Icons.wechat, '加微信助理', Colors.purple),
        _buildIconItem(Icons.logout, '登出', Colors.purple),
      ],
    );
  }

  // 通用卡片构建方法
  Widget _buildSectionCard(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: items,
          ),
        ],
      ),
    );
  }

  // 图标功能项构建方法
  Widget _buildIconItem(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 功能开发中...'),
            backgroundColor: const Color(0xFF2a2a2a),
          ),
        );
      },
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
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
      ),
    );
  }
}
