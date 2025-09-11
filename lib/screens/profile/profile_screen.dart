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
        child: Center(
          child: Text(
            '个人中心',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
}
