import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
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

  // 守望流程收缩状态
  bool _isFlowChartExpanded = true;

  // 守望流程设置
  final List<GuardianFlow> _guardianFlows = [
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
              // 顶部导航栏
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
                        '守望设置',
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

              // 主内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 登录频次监控和运动步数监控
                      Row(
                        children: [
                          Expanded(
                            child: _buildMonitorSetting(
                              '登录频次监控',
                              _loginMonitorDays,
                              () => _showDaysSelector(
                                '登录频次监控',
                                _loginMonitorDays,
                                (value) {
                                  setState(() {
                                    _loginMonitorDays = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMonitorSetting(
                              '运动步数监控',
                              _stepMonitorDays,
                              () => _showDaysSelector(
                                '运动步数监控',
                                _stepMonitorDays,
                                (value) {
                                  setState(() {
                                    _stepMonitorDays = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // 守望流程 - 可收缩的流程图
                      Column(
                        children: [
                          // 守望流程标题栏 - 带收缩按钮
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '守望流程',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFlowChartExpanded =
                                          !_isFlowChartExpanded;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: AnimatedRotation(
                                      turns: _isFlowChartExpanded ? 0 : -0.5,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 可收缩的流程图容器
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _isFlowChartExpanded
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: _buildGuardianFlowChart(),
                            ),
                            secondChild: const SizedBox(
                              width: double.infinity,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          if (index == 0) {
            _navigateToHome();
          } else if (index == 1) {
            // 当前页面，不需要导航
          } else if (index == 2) {
            // 个人中心
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },
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
              border: Border.all(color: const Color(0xFF404040), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
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
        border: Border.all(color: flow.color.withOpacity(0.3), width: 1),
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
                style: const TextStyle(fontSize: 14, color: Colors.white),
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
                style: const TextStyle(fontSize: 14, color: Colors.white),
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
          _buildContactMethod(methods[i], _getContactColor(methods[i])),
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
        border: Border.all(color: color.withOpacity(0.5), width: 1),
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
          Container(width: 2, height: 12, color: Colors.white.withOpacity(0.3)),
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
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
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
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
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
  void _showDaysSelector(
    String title,
    String currentValue,
    Function(String) onSelected,
  ) {
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

              ...days.map(
                (day) => _buildDayOption(day, currentValue, onSelected),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建天数选项
  Widget _buildDayOption(
    String day,
    String currentValue,
    Function(String) onSelected,
  ) {
    final isSelected = currentValue.contains(day);
    return GestureDetector(
      onTap: () {
        String newValue;
        if (day == '7天') {
          newValue = '7天未登录';
        } else if (day == '15天') {
          newValue = '15天未登录';
        } else if (day == '30天') {
          newValue = '30天未登录';
        } else if (day == '60天') {
          newValue = '60天未登录';
        } else {
          newValue = '90天未登录';
        }

        onSelected(newValue);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
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

  /// 构建守望流程图
  Widget _buildGuardianFlowChart() {
    return Column(
      children: [
        // 第一行：用户超期 -> 企业微信联系
        Row(
          children: [
            // 卡片1 - 向左靠近边线10px
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: _buildFlowCard(
                number: '1',
                title: '用户超期',
                subtitle: '超过设定天数未登录',
                color: Colors.blue,
              ),
            ),
            Expanded(child: _buildHorizontalConnector('24小时内', '3次')),
            // 卡片2 - 向右靠近边线10px
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: _buildFlowCard(
                number: '2',
                title: '企业微信联系',
                subtitle: '发送提醒消息',
                color: Colors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 垂直连接器2
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(right: 70),
          child: _buildVerticalConnector('24小时 3次'),
        ),

        const SizedBox(height: 8),

        // 第二行：400电话联系 <- 短信联系
        Row(
          children: [
            // 卡片4 - 向左靠近边线10px
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: _buildFlowCard(
                number: '4',
                title: '400电话联系',
                subtitle: '拨打3次确认',
                color: Colors.red,
              ),
            ),
            Expanded(
              child: _buildHorizontalConnector('24小时内', '3次', isReversed: true),
            ),
            // 卡片3 - 向右靠近边线10px
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: _buildFlowCard(
                number: '3',
                title: '短信联系',
                subtitle: '发送紧急提醒',
                color: Colors.orange,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 垂直连接器4
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 70),
          child: _buildVerticalConnector('无限次'),
        ),

        const SizedBox(height: 8),

        // 第三行：紧急联系人 -> 投递收件人
        Row(
          children: [
            // 卡片5 - 向左靠近边线10px
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: _buildFlowCard(
                number: '5',
                title: '紧急联系人',
                subtitle: '按优先级顺序联系',
                color: Colors.red,
              ),
            ),
            Expanded(child: _buildHorizontalConnector('', '')),
            // 卡片6 - 向右靠近边线10px
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: _buildFlowCard(
                number: '6',
                title: '投递收件人',
                subtitle: '',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建流程卡片
  Widget _buildFlowCard({
    required String number,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF3f3f3f),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 第一行：数字 + 标题
            Text(
              '$number $title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // 副标题（如果有的话）
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建水平连接器
  Widget _buildHorizontalConnector(
    String topLabel,
    String bottomLabel, {
    bool isReversed = false,
  }) {
    return SizedBox(
      width: 80,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 虚线箭头
          Row(
            children: isReversed
                ? [
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                      color: Color(0xFF6b7280),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 2,
                        child: CustomPaint(painter: DashedLinePainter()),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: SizedBox(
                        height: 2,
                        child: CustomPaint(painter: DashedLinePainter()),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Color(0xFF6b7280),
                    ),
                  ],
          ),
          // 上标签
          if (topLabel.isNotEmpty)
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: const Color(0xFF1a1a1a),
                child: Text(
                  topLabel,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          // 下标签
          if (bottomLabel.isNotEmpty)
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: const Color(0xFF1a1a1a),
                child: Text(
                  bottomLabel,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建垂直连接器
  Widget _buildVerticalConnector(String sideLabel) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 垂直虚线和箭头
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: 2,
                  child: CustomPaint(
                    painter: DashedLinePainter(isVertical: true),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Color(0xFF6b7280),
              ),
            ],
          ),
          // 侧边标签
          if (sideLabel.isNotEmpty)
            Positioned(
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: const Color(0xFF1a1a1a),
                child: Text(
                  sideLabel,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 虚线画笔
class DashedLinePainter extends CustomPainter {
  final bool isVertical;

  DashedLinePainter({this.isVertical = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6b7280)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 绘制虚线
    if (isVertical) {
      _drawDashedLine(
        canvas,
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      );
    } else {
      _drawDashedLine(
        canvas,
        Offset.zero,
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double distance = (end - start).distance;
    double dashCount = (distance / (dashWidth + dashSpace)).floor().toDouble();

    for (int i = 0; i < dashCount; i++) {
      double startDistance = i * (dashWidth + dashSpace);
      double endDistance = startDistance + dashWidth;

      Offset dashStart = Offset.lerp(start, end, startDistance / distance)!;
      Offset dashEnd = Offset.lerp(start, end, endDistance / distance)!;

      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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