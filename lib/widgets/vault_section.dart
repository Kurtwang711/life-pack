import 'package:flutter/material.dart';
import '../screens/recording/recording_management_screen.dart';
import '../screens/image/image_management_screen.dart';
import '../screens/video/video_management_screen.dart';
import '../screens/document/document_management_screen.dart';
import '../screens/assets/assets_management_screen.dart';

class VaultSection extends StatefulWidget {
  const VaultSection({super.key});

  @override
  State<VaultSection> createState() => _VaultSectionState();
}

class _VaultSectionState extends State<VaultSection> with TickerProviderStateMixin {
  bool _showMainView = false;
  late AnimationController _flashController;
  late Animation<Color?> _flashAnimation;

  final Map<String, VaultOption> _options = {
    'audio': VaultOption('录音', const Color(0xFFD88FA3)), // 春 - 粉色
    'image': VaultOption('图片', const Color(0xFFE6B800)), // 夏 - 黄色
    'video': VaultOption('视频', const Color(0xFFC76B00)), // 秋 - 橙色
    'document': VaultOption('文档', const Color(0xFF7FA8C4)), // 冬 - 蓝色
    'assets': VaultOption('资产', const Color(0xFF00BFFF)), // 中心 - 深蓝色
  };

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _flashAnimation = ColorTween(
      begin: Colors.black,
      end: const Color(0xFFFFD700), // 金色
    ).animate(_flashController);
    
    // 开始闪烁动画
    _flashController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _showMainView ? _buildMainView() : _buildVaultView(),
      ),
    );
  }


  Widget _buildVaultView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMainView = true;
        });
      },
      child: Container(
        key: const ValueKey('vault'),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF4E4D4D),
              width: 1,
            ),
          ),
        ),
        child: Stack(
          children: [
            // 电路纹路背景 (按下时显示)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF00BFFF).withOpacity(0),
                    Colors.transparent,
                  ],
                  stops: const [0.1, 0.5, 0.9],
                ),
              ),
            ),
            
            // 内容
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '机要库',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFE0E0E0).withOpacity(0.1),
                          offset: const Offset(-1, -1),
                          blurRadius: 1,
                        ),
                        const Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 锁形图标 - 带闪烁效果
                  AnimatedBuilder(
                    animation: _flashAnimation,
                    builder: (context, child) {
                      return Icon(
                        Icons.lock,
                        size: 24,
                        color: _flashAnimation.value,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFE0E0E0).withOpacity(0.1),
                            offset: const Offset(1, 1),
                            blurRadius: 1,
                          ),
                          const Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 3,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMainView = false;
        });
      },
      child: Container(
        key: const ValueKey('main'),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF4E4D4D),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // 上排按钮
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildOptionButton('audio'),
                    ),
                    const SizedBox(width: 2),
                    const SizedBox(width: 67), // 中心按钮占位
                    const SizedBox(width: 2),
                    Expanded(
                      child: _buildOptionButton('image'),
                    ),
                  ],
                ),
              ),
              
              // 中间行
              SizedBox(
                height: 67,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    _buildCenterButton(),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              
              // 下排按钮
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildOptionButton('video'),
                    ),
                    const SizedBox(width: 2),
                    const SizedBox(width: 67), // 中心按钮占位
                    const SizedBox(width: 2),
                    Expanded(
                      child: _buildOptionButton('document'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String optionKey) {
    final option = _options[optionKey]!;
    
    return GestureDetector(
      onTap: () {
        // 单击直接导航到对应的管理页面
        if (optionKey == 'audio') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RecordingManagementScreen(),
            ),
          );
        } else if (optionKey == 'image') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ImageManagementScreen(),
            ),
          );
        } else if (optionKey == 'video') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VideoManagementScreen(),
            ),
          );
        } else if (optionKey == 'document') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DocumentManagementScreen(),
            ),
          );
        } else if (optionKey == 'assets') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AssetsManagementScreen(),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: const Border(
            top: BorderSide(color: Color(0xFF4E4D4D), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // 文字
            Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: const TextStyle(
                  color: Color(0xFF0073E6),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                child: Text(
                  option.label.toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    final option = _options['assets']!;
    
    return GestureDetector(
      onTap: () {
        // TODO: 添加资产管理页面导航
        print('点击了资产管理');
      },
      child: Container(
        width: 67,
        height: 67,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: const Border(
            top: BorderSide(color: Color(0xFF4E4D4D), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // 文字
            Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: const TextStyle(
                  color: Color(0xFF0073E6),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                child: Text(
                  option.label.toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VaultOption {
  final String label;
  final Color color;
  
  VaultOption(this.label, this.color);
}
