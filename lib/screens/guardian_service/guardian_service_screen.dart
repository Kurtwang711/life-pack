import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';

class GuardianServiceScreen extends StatefulWidget {
  const GuardianServiceScreen({super.key});

  @override
  State<GuardianServiceScreen> createState() => _GuardianServiceScreenState();
}

class _GuardianServiceScreenState extends State<GuardianServiceScreen> {
  int _currentNavIndex = 1; // 守望服务在导航栏的索引位置

  // 守望设置状态
  String _loginMonitorDays = '30天未登录';
  String _stepMonitorDays = '30天无步数';
  
  // 守望流程设置
  List<GuardianFlow> _guardianFlows = [
    GuardianFlow(
      title: '用户超期',
      subtitle: '超过设定天数未登录',
      color: Colors.blue,
      timeLimit: '24小时内',
      maxAttempts: 3,
      contactMethods: ['企业微信联系', '短信联系', '400电话联系'],
    ),
  ];

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
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
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
                          '守望设置',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // 占位空间保持标题居中
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            
            // 主内容区域
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              bottom: 120,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 守望设置标题
                    const Text(
                      '守望设置',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 登录频次监控和运动步数监控
                    Row(
                      children: [
                        Expanded(
                          child: _buildMonitorSetting(
                            '登录频次监控',
                            _loginMonitorDays,
                            () => _showDaysSelector('登录频次监控', _loginMonitorDays, (value) {
                              setState(() {
                                _loginMonitorDays = value;
                              });
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMonitorSetting(
                            '运动步数监控',
                            _stepMonitorDays,
                            () => _showDaysSelector('运动步数监控', _stepMonitorDays, (value) {
                              setState(() {
                                _stepMonitorDays = value;
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 守望流程标题
                    const Text(
                      '守望流程',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 守望流程列表
                    ...(_guardianFlows.map((flow) => _buildGuardianFlowCard(flow)).toList()),
                    
                    const SizedBox(height: 20),
                    
                    // 紧急联系人
                    _buildEmergencyContact(),
                  ],
                ),
              ),
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
                      // 当前页面，不需要导航
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

  /// 构建监控设置项
  Widget _buildMonitorSetting(String title, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF404040),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建守望流程卡片
  Widget _buildGuardianFlowCard(GuardianFlow flow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: flow.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 流程标题
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: flow.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flow.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    flow.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 时间限制和次数
          Row(
            children: [
              Text(
                flow.timeLimit,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 2,
                height: 20,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(width: 20),
              Text(
                '${flow.maxAttempts}次',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 联系方式流程图
          _buildContactFlow(flow.contactMethods),
        ],
      ),
    );
  }

  /// 构建联系流程图
  Widget _buildContactFlow(List<String> methods) {
    return Column(
      children: [
        for (int i = 0; i < methods.length; i++) ...[
          _buildContactMethod(
            methods[i],
            _getContactColor(methods[i]),
          ),
          if (i < methods.length - 1) _buildFlowConnector(),
        ],
      ],
    );
  }

  /// 构建单个联系方式
  Widget _buildContactMethod(String method, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        method,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建流程连接器
  Widget _buildFlowConnector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: 2,
            height: 12,
            color: Colors.white.withOpacity(0.3),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white54,
            size: 16,
          ),
        ],
      ),
    );
  }

  /// 构建紧急联系人
  Widget _buildEmergencyContact() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '紧急联系人',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '按优先级顺序联系',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white54,
            size: 16,
          ),
        ],
      ),
    );
  }

  /// 获取联系方式颜色
  Color _getContactColor(String method) {
    if (method.contains('企业微信')) {
      return Colors.green;
    } else if (method.contains('短信')) {
      return Colors.orange;
    } else if (method.contains('400电话')) {
      return Colors.red;
    }
    return Colors.blue;
  }

  /// 显示天数选择器
  void _showDaysSelector(String title, String currentValue, Function(String) onSelected) {
    final days = ['7天', '15天', '30天', '60天', '90天'];
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              ...days.map((day) => _buildDayOption(day, currentValue, onSelected)).toList(),
            ],
          ),
        );
      },
    );
  }

  /// 构建天数选项
  Widget _buildDayOption(String day, String currentValue, Function(String) onSelected) {
    final isSelected = currentValue.contains(day);
    return GestureDetector(
      onTap: () {
        String newValue;
        if (day == '7天') newValue = '7天未登录';
        else if (day == '15天') newValue = '15天未登录';
        else if (day == '30天') newValue = '30天未登录';
        else if (day == '60天') newValue = '60天未登录';
        else newValue = '90天未登录';
        
        onSelected(newValue);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.blue.withOpacity(0.3)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
              ? Colors.blue
              : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            day,
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
}

/// 守望流程数据模型
class GuardianFlow {
  final String title;
  final String subtitle;
  final Color color;
  final String timeLimit;
  final int maxAttempts;
  final List<String> contactMethods;

  GuardianFlow({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.timeLimit,
    required this.maxAttempts,
    required this.contactMethods,
  });
}
