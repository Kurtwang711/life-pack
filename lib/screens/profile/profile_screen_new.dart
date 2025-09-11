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
  String _nickname = "生如夏花";
  final String _phoneNumber = "138****8888";
  final String _accountId = "USER_MFDJMTDJ_Z6AZK5";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // 浅灰背景
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部用户信息区域
              _buildUserHeader(),

              const SizedBox(height: 20),

              // 用户状态卡片区域 (实名认证、会员资格、存储容量)
              _buildStatusCards(),

              const SizedBox(height: 30),

              // 积分区域
              _buildPointsSection(),

              const SizedBox(height: 30),

              // 现金区域
              _buildCashSection(),

              const SizedBox(height: 30),

              // 管理区域
              _buildManagementSection(),

              const SizedBox(height: 30),

              // 其他功能区域
              _buildOtherSection(),

              const SizedBox(height: 100), // 为底部导航栏留出空间
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
              MaterialPageRoute(
                builder: (context) => const GuardianServiceScreen(),
              ),
            );
          }
          // index == 2 是当前页面（个人中心），无需跳转
        },
      ),
    );
  }

  // 头部用户信息区域
  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF6C8DF0), Color(0xFF4A90E2)], // 蓝色渐变
        ),
      ),
      child: Row(
        children: [
          // 头像区域
          GestureDetector(
            onTap: () {
              _showAvatarUploadDialog();
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF5A7BF0),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 用户信息区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 昵称和编辑按钮
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "点击设置昵称",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showNicknameEditDialog,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 账户号
                Text(
                  "账户号：$_accountId",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 4),

                // 手机号
                Row(
                  children: [
                    Text(
                      "手机号：点击设置",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showPhoneEditDialog,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white70,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 设置按钮
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFA726),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  // 用户状态卡片区域
  Widget _buildStatusCards() {
    return Row(
      children: [
        // 实名认证
        Expanded(
          child: _buildStatusCard(
            icon: Icons.verified_user,
            iconColor: const Color(0xFF4CAF50),
            title: "实名认证",
            subtitle: "",
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(width: 12),

        // 会员资格
        Expanded(
          child: _buildStatusCard(
            icon: Icons.workspace_premium,
            iconColor: const Color(0xFF9C27B0),
            title: "会员资格",
            subtitle: "2025-01-15",
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(width: 12),

        // 存储容量
        Expanded(
          child: _buildStatusCard(
            icon: Icons.storage,
            iconColor: const Color(0xFF2196F3),
            title: "存储容量",
            subtitle: "1.2G/2G",
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  // 状态卡片组件
  Widget _buildStatusCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
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
              color: iconColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // 积分区域
  Widget _buildPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "积分",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildCircleButton(
              icon: Icons.add,
              color: const Color(0xFF4CAF50),
              label: "挣积分",
            ),
            const SizedBox(width: 40),
            _buildCircleButton(
              icon: Icons.remove,
              color: const Color(0xFFFF9800),
              label: "花积分",
            ),
            const SizedBox(width: 40),
            _buildCircleButton(
              icon: Icons.list,
              color: const Color(0xFF2196F3),
              label: "积分明细",
            ),
          ],
        ),
      ],
    );
  }

  // 现金区域
  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "现金",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Column(
              children: [
                _buildCircleButton(
                  icon: Icons.account_balance_wallet,
                  color: const Color(0xFF4CAF50),
                  label: "现金余额",
                ),
                const SizedBox(height: 8),
                const Text(
                  "￥128.50",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 60),
            _buildCircleButton(
              icon: Icons.trending_up,
              color: const Color(0xFF2196F3),
              label: "消费明细",
            ),
          ],
        ),
      ],
    );
  }

  // 管理区域
  Widget _buildManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "管理",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(
              icon: Icons.group,
              color: const Color(0xFF2196F3),
              label: "联系人",
            ),
            _buildCircleButton(
              icon: Icons.palette,
              color: const Color(0xFF9C27B0),
              label: "主题皮肤",
            ),
            _buildCircleButton(
              icon: Icons.lock,
              color: const Color(0xFFF44336),
              label: "登录密码",
            ),
            _buildCircleButton(
              icon: Icons.face_retouching_natural,
              color: const Color(0xFF4CAF50),
              label: "人脸识别",
            ),
            _buildCircleButton(
              icon: Icons.card_giftcard,
              color: const Color(0xFFFF9800),
              label: "邀请码",
            ),
          ],
        ),
      ],
    );
  }

  // 其他功能区域
  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "其他",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(
              icon: Icons.help,
              color: const Color(0xFF2196F3),
              label: "帮助",
            ),
            _buildCircleButton(
              icon: Icons.feedback,
              color: const Color(0xFF4CAF50),
              label: "反馈",
            ),
            _buildCircleButton(
              icon: Icons.star,
              color: const Color(0xFFFF9800),
              label: "评分",
            ),
            _buildCircleButton(
              icon: Icons.logout,
              color: const Color(0xFFF44336),
              label: "登出",
            ),
            _buildCircleButton(
              icon: Icons.delete_forever,
              color: const Color(0xFFF44336),
              label: "注销账户",
            ),
          ],
        ),
      ],
    );
  }

  // 圆形按钮组件
  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 显示头像上传对话框
  void _showAvatarUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('上传头像'),
          content: const Text('头像上传功能开发中...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 显示昵称编辑对话框
  void _showNicknameEditDialog() {
    TextEditingController controller = TextEditingController(text: _nickname);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('设置昵称'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '请输入昵称'),
            maxLength: 20,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _nickname = controller.text.trim();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 显示手机号编辑对话框
  void _showPhoneEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('设置手机号'),
          content: const Text('手机号设置功能开发中...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
