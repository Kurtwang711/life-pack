import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../home/home_screen.dart';
import '../../widgets/simple_bottom_navigation.dart';

class TrueSelfRecordScreen extends StatefulWidget {
  const TrueSelfRecordScreen({super.key});

  @override
  State<TrueSelfRecordScreen> createState() => _TrueSelfRecordScreenState();
}

class _TrueSelfRecordScreenState extends State<TrueSelfRecordScreen> {
  int _currentNavIndex = 0;
  
  // 表单控制器
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  // 焦点节点
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  
  // 波浪动画值
  final ValueNotifier<double> _waveAnimation1 = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _waveAnimation2 = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _waveAnimation3 = ValueNotifier<double>(0.0);
  
  @override
  void initState() {
    super.initState();
    _startWaveAnimations();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _nameFocus.dispose();
    _ageFocus.dispose();
    _bioFocus.dispose();
    _waveAnimation1.dispose();
    _waveAnimation2.dispose();
    _waveAnimation3.dispose();
    super.dispose();
  }
  
  void _startWaveAnimations() {
    // 优化的波浪动画 - 减少CPU使用率和内存占用
    Future.doWhile(() async {
      if (!mounted) return false;
      
      await Future.delayed(const Duration(milliseconds: 100)); // 降低刷新率节约电量
      if (mounted) {
        // 使用更高效的计算方式
        final time = DateTime.now().millisecondsSinceEpoch * 0.001;
        _waveAnimation1.value = (time * 0.8) % (2 * math.pi);
        _waveAnimation2.value = (time * 0.6) % (2 * math.pi);
        _waveAnimation3.value = (time * 1.0) % (2 * math.pi);
      }
      return mounted;
    });
  }

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
            // 头部区域 - 与录音管理完全一致
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
                          '真我录',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // 右侧占位，保持标题居中
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            
            // 头像上传区域 - 位于返回键下方
            Positioned(
              top: 114, // 返回键底部(60+44=104) + 10px垂直间距 = 114
              left: 4,  // 距离左侧边线4px
              child: _buildAvatarUploadArea(),
            ),
            
            // 主体内容区域 - 波浪式表单
            Positioned(
              top: 120,
              left: 140, // 为头像区域让出空间 (4px边距 + 120px宽度 + 16px间距)
              right: 16,
              bottom: 120, // 为底部导航栏留出空间
              child: _buildWaveFormSection(),
            ),
            
            // 底部导航栏
            Positioned(
              bottom: 30, // 距离底部30px悬浮
              left: 0,
              right: 0,
              child: Center(
                child: SimpleBottomNavigation(
                  currentIndex: _currentNavIndex,
                  onTap: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                    // 导航逻辑
                    if (index == 0) {
                      // 首页按钮
                      _navigateToHome();
                    } else if (index == 1) {
                      // 个人中心按钮 - 暂时不实现
                      print('个人中心功能开发中...');
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

  /// 构建头像上传区域
  Widget _buildAvatarUploadArea() {
    return GestureDetector(
      onTap: _handleAvatarUpload,
      child: Container(
        width: 120,  // 宽度120px
        height: 160, // 高度160px
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12), // 圆角设计
          border: Border.all(
            color: const Color(0xFF333333),
            width: 1.5,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 头像图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white54,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            // 上传提示文字
            const Text(
              '点击上传\n头像',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理头像上传
  void _handleAvatarUpload() {
    // 暂时显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('头像上传功能开发中...'),
        backgroundColor: Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    
    // 这里后续可以集成图片选择器
    // 例如: image_picker 包
    print('触发头像上传功能');
  }

  /// 构建波浪式表单区域
  Widget _buildWaveFormSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '记录真实的自己',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // 姓名输入框
            _buildWaveInput(
              controller: _nameController,
              focusNode: _nameFocus,
              label: '姓名',
              hint: '输入你的真实姓名',
              waveNotifier: _waveAnimation1,
              icon: Icons.person_outline,
            ),
            
            const SizedBox(height: 20),
            
            // 年龄输入框
            _buildWaveInput(
              controller: _ageController,
              focusNode: _ageFocus,
              label: '年龄',
              hint: '输入你的年龄',
              waveNotifier: _waveAnimation2,
              icon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 20),
            
            // 个人简介输入框
            _buildWaveInput(
              controller: _bioController,
              focusNode: _bioFocus,
              label: '个人简介',
              hint: '写下关于你的故事...',
              waveNotifier: _waveAnimation3,
              icon: Icons.edit_outlined,
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            
            // 保存按钮
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// 构建波浪式输入框 - 优化版本
  Widget _buildWaveInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required ValueNotifier<double> waveNotifier,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        // 优化的波浪式容器 - 减少重绘频率
        ValueListenableBuilder<double>(
          valueListenable: waveNotifier,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus 
                  ? Colors.blue
                  : Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          builder: (context, waveValue, child) {
            // 优化计算 - 预计算常用值
            final waveSin1 = math.sin(waveValue * 0.5);
            final waveSin2 = math.sin(waveValue * 0.3);
            final baseOpacity1 = 0.1 + 0.05 * (1 + waveSin1);
            final baseOpacity2 = 0.1 + 0.05 * (1 + waveSin2);
            
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(baseOpacity1),
                    Colors.purple.withOpacity(baseOpacity2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: focusNode.hasFocus 
                    ? Colors.blue.withOpacity(0.6)
                    : Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: focusNode.hasFocus
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }

  /// 构建保存按钮
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ValueListenableBuilder<double>(
        valueListenable: _waveAnimation1,
        builder: (context, waveValue, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.8 + 0.2 * (1 + math.sin(waveValue * 0.5))),
                  Colors.purple.withOpacity(0.8 + 0.2 * (1 + math.sin(waveValue * 0.3))),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                '保存记录',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 处理保存
  void _handleSave() {
    // 获取表单数据
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final bio = _bioController.text.trim();
    
    if (name.isEmpty) {
      _showSnackBar('请输入姓名');
      return;
    }
    
    if (age.isEmpty) {
      _showSnackBar('请输入年龄');
      return;
    }
    
    if (bio.isEmpty) {
      _showSnackBar('请输入个人简介');
      return;
    }
    
    // 暂时只显示保存成功提示
    _showSnackBar('记录保存成功！', isSuccess: true);
    
    // 这里后续可以实现数据持久化
    print('保存数据: 姓名=$name, 年龄=$age, 简介=$bio');
  }

  /// 显示提示信息
  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess 
          ? Colors.green.withOpacity(0.8)
          : Colors.red.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
