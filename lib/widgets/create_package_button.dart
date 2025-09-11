import 'package:flutter/material.dart';
import 'package_creation_form.dart';
import 'add_file_to_package_dialog.dart';
import '../services/package_manager.dart';
import '../screens/package_content/package_content_screen.dart';

class CreatePackageButton extends StatefulWidget {
  const CreatePackageButton({super.key});

  @override
  State<CreatePackageButton> createState() => _CreatePackageButtonState();
}

class _CreatePackageButtonState extends State<CreatePackageButton> {
  bool _isHovering = false;

  void _showPackageCreationForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => PackageCreationForm(
        onClose: () => Navigator.of(modalContext).pop(),
        onSubmit: (formData) async {
          print('开始创建包裹，表单数据: $formData');
          try {
            // 通过包裹管理器创建包裹
            PackageManager().createPackageFromForm(formData);
            print('包裹创建成功');
            
            // 关闭模态框 - 使用modalContext确保关闭的是模态框而不是主屏幕
            Navigator.of(modalContext).pop();
            
            // 获取刚创建的包裹信息
            final packageManager = PackageManager();
            final packages = packageManager.packages;
            final latestPackage = packages.isNotEmpty ? packages.last : null;
            
            // 显示包裹创建成功的文件添加确认对话框
            final shouldAddFile = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => AddFileToPackageDialog(
                onConfirm: () => Navigator.of(context).pop(true),
                onCancel: () => Navigator.of(context).pop(false),
              ),
            );
            
            if (shouldAddFile == true && latestPackage != null) {
              // 用户选择"好" - 导航到包裹内容管理页面
              print('用户选择添加文件到包裹，导航到包裹内容管理页面');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PackageContentScreen(
                    packageNumber: latestPackage.packageNumber,
                    sequenceNumber: latestPackage.sequenceNumber,
                  ),
                ),
              );
            } else {
              // 用户选择"不" - 返回首页并显示成功消息
              print('用户选择不添加文件，返回首页');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('包裹创建成功！'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            print('创建包裹时发生错误: $e');
            
            // 关闭模态框 - 使用modalContext
            Navigator.of(modalContext).pop();
            
            // 显示错误信息 - 使用原始的context
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('创建包裹失败: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPackageCreationForm(context);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 128, // 8rem * 16 = 128px
            height: 38.4, // 2.4rem * 16 = 38.4px
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isHovering
                    ? [const Color(0xFF1D1D1D), const Color(0xFF1D1D1D)]
                    : [const Color(0xFF333333), const Color(0xFF242323)],
              ),
              border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovering ? 0 : 0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '创建包裹',
                style: TextStyle(
                  fontSize: 12.8, // 0.8rem * 16 = 12.8px
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF51A5FF), // 亮蓝色
                  letterSpacing: 0.5,
                  height: 0.8,
                  shadows: const [
                    // 凹凸感阴影效果 - 高光
                    Shadow(offset: Offset(-1, -1), color: Color(0x4AE0E0E0)),
                    // 凹凸感阴影效果 - 深色阴影
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Color(0x80000000),
                    ),
                    // 蓝色发光效果
                    Shadow(color: Color(0xFF51A5FF), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
