import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/package_info_card.dart';
import '../../widgets/edit_package_dialog.dart';
import '../../services/package_manager.dart';
import '../../models/package_model.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';

class PackageContentScreen extends StatefulWidget {
  final String packageNumber;
  final int sequenceNumber;

  const PackageContentScreen({
    super.key,
    required this.packageNumber,
    required this.sequenceNumber,
  });

  @override
  State<PackageContentScreen> createState() => _PackageContentScreenState();
}

class _PackageContentScreenState extends State<PackageContentScreen> {
  int _currentNavIndex = 0;
  bool _isVaultExpanded = false; // 机要库是否展开
  String? _selectedFunction = 'overview'; // 当前选中的功能按钮：'overview', 'delete', 'add'，默认为总览
  bool _showFilters = true; // 是否显示筛选按钮，默认显示

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1419),
              Color(0xFF1C1C1E),
            ],
          ),
        ),
      // 标准底部导航栏
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          // 导航逻辑
          if (index == 0) {
            // 首页
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false,
            );
          } else if (index == 1) {
            // 守望服务
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GuardianServiceScreen(),
              ),
            );
          } else if (index == 2) {
            // 个人中心
            Navigator.of(context).push(
              MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                builder: (context) => const ProfileScreen(),
              ),
            )
          }
        },
      ),
        child: Stack(
          children: [
            // 主要内容区域
            SafeArea(
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
                          onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          ),
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
                            '#${widget.sequenceNumber}包裹内容管理',
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
                  
                  // 包裹信息卡片（距离顶部导航4px）
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: _buildPackageInfoCard(),
                  ),
                  
                  // 功能按钮区域（距离包裹卡片4px）
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: _buildFunctionButtons(),
                  ),
                  
                  // 筛选框区域（距离功能按钮4px）
                  if (_showFilters) 
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: _buildFilterSection(),
                    ),
                  
                  // 文件展示区域（距离筛选区4px）
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: _buildFileDisplayArea(),
                    ),
                  ),
                ],
              ),
            ),

            // 悬浮底部导航栏
      ),
    );
  }

  Widget _buildPackageInfoCard() {
    // 使用AnimatedBuilder监听PackageManager的变化
    return AnimatedBuilder(
      animation: PackageManager(),
      builder: (context, child) {
        // 根据包裹号从PackageManager获取包裹信息
        final packageManager = PackageManager();
        final package = packageManager.packages.firstWhere(
          (p) => p.packageNumber == widget.packageNumber,
          orElse: () => PackageModel(
            id: 'temp',
            packageNumber: widget.packageNumber,
            recipient: '未知收件人',
            phone: '未知手机号',
            deliveryMethod: 'package_id_app',
            createdAt: DateTime.now(),
            lastModified: DateTime.now(),
            sequenceNumber: widget.sequenceNumber,
          ),
        );

        return PackageInfoCard(
          package: package,
          onTap: () => _showEditPackageDialog(package),
        );
      },
    );
  }

  Widget _buildFunctionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // 包裹总览按钮
          Expanded(
            child: _buildFunctionButton('包裹总览', '0', 'overview'),
          ),
          const SizedBox(width: 8),
          
          // 删除文件按钮
          Expanded(
            child: _buildFunctionButton('删除文件', '0', 'delete'),
          ),
          const SizedBox(width: 8),
          
          // 添加文件按钮
          Expanded(
            child: _buildFunctionButton('添加文件', '0', 'add'),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton(String text, String count, String functionType) {
    // 根据按钮类型获取颜色
    Color getTextColor() {
      switch (functionType) {
        case 'overview':
          return const Color(0xFFFF8C00); // 橙色
        case 'delete':
          return const Color(0xFF8A2BE2); // 紫色
        case 'add':
          return const Color(0xFF90EE90); // 淡绿色
        default:
          return Colors.black;
      }
    }
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedFunction == functionType && _showFilters) {
            // 如果点击的是已选中的按钮且筛选器已显示，则隐藏筛选器
            _showFilters = false;
            _selectedFunction = null;
            _isVaultExpanded = false;
          } else {
            // 否则显示筛选器并选中当前按钮
            _showFilters = true;
            _selectedFunction = functionType;
            _isVaultExpanded = false; // 重置机要库展开状态
          }
        });
        
        print('点击了$text按钮，数量: $count，类型: $functionType');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$text功能激活 (当前: $count个)'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        height: 36,
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
            '$text($count)'.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: getTextColor(),
              letterSpacing: 0.5,
              height: 0.8,
              shadows: [
                const Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                const Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 3,
                  color: Color(0x4D000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPackageDialog(PackageModel package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => EditPackageDialog(
        package: package,
        onClose: () => Navigator.of(modalContext).pop(),
        onSubmit: (formData) async {
          print('修改包裹信息: $formData');
          try {
            // 更新包裹信息
            PackageManager().updatePackageFromForm(formData);
            
            // 关闭模态框
            Navigator.of(modalContext).pop();
            
            // 显示成功消息
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('包裹信息修改成功！'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            
            // 刷新页面状态
            setState(() {});
            
          } catch (e) {
            print('修改包裹信息时发生错误: $e');
            
            // 关闭模态框
            Navigator.of(modalContext).pop();
            
            // 显示错误信息
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('修改失败: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
  
  Widget _buildFilterSection() {
    // 根据选中的功能获取颜色
    Color getFilterColor() {
      switch (_selectedFunction) {
        case 'overview':
          return const Color(0xFFFF8C00); // 橙色
        case 'delete':
          return const Color(0xFF8A2BE2); // 紫色
        case 'add':
          return const Color(0xFF90EE90); // 淡绿色
        default:
          return Colors.grey[700]!;
      }
    }
    
    return Column(
      children: [
        // 主筛选按钮行
        Row(
          children: [
            // 机要库按钮（可展开）
            Expanded(
              child: _buildFilterButton(
                '机要库', 
                hasDropdown: true,
                isExpanded: _isVaultExpanded, 
                color: getFilterColor(),
                onTap: () {
                  setState(() {
                    _isVaultExpanded = !_isVaultExpanded;
                  });
                }
              ),
            ),
            const SizedBox(width: 8),
            
            // 年轮相册按钮
            Expanded(
              child: _buildFilterButton('年轮相册', color: getFilterColor()),
            ),
            const SizedBox(width: 8),
            
            // 真我录按钮
            Expanded(
              child: _buildFilterButton('真我录', color: getFilterColor()),
            ),
            const SizedBox(width: 8),
            
            // 许愿按钮
            Expanded(
              child: _buildFilterButton('许愿', color: getFilterColor()),
            ),
          ],
        ),
        
        // 展开的机要库子选项
        if (_isVaultExpanded) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFilterButton('录音', color: getFilterColor()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('图片', color: getFilterColor()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('视频', color: getFilterColor()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('文档', color: getFilterColor()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('资产', color: getFilterColor()),
              ),
            ],
          ),
        ],
      ],
    );
  }
  
  Widget _buildFilterButton(
    String text, {
    bool hasDropdown = false,
    bool isExpanded = false,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                  height: 0.8,
                  shadows: [
                    const Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                    const Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      color: Color(0x4D000000),
                    ),
                  ],
                ),
              ),
              if (hasDropdown) ...[
                const SizedBox(width: 4),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: color,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFileDisplayArea() {
    // 根据选中的功能显示对应的内容
    String getDisplayTitle() {
      switch (_selectedFunction) {
        case 'overview':
          return '包裹总览 - 文件列表';
        case 'delete':
          return '删除文件 - 选择要删除的文件';
        case 'add':
          return '添加文件 - 上传新文件';
        default:
          return '文件管理';
      }
    }
    
    Color getTitleColor() {
      switch (_selectedFunction) {
        case 'overview':
          return const Color(0xFFFF8C00); // 橙色
        case 'delete':
          return const Color(0xFF8A2BE2); // 紫色
        case 'add':
          return const Color(0xFF90EE90); // 淡绿色
        default:
          return Colors.grey[700]!;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Row(
            children: [
              Icon(
                _getIconForFunction(),
                color: getTitleColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                getDisplayTitle(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: getTitleColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 文件列表区域
          Expanded(
            child: _buildFileList(),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForFunction() {
    switch (_selectedFunction) {
      case 'overview':
        return Icons.folder_open;
      case 'delete':
        return Icons.delete_outline;
      case 'add':
        return Icons.add_circle_outline;
      default:
        return Icons.folder;
    }
  }
  
  Widget _buildFileList() {
    // 当前没有文件，显示空状态
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无文件',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  String _getEmptyStateMessage() {
    switch (_selectedFunction) {
      case 'overview':
        return '此包裹中还没有任何文件\n点击"添加文件"开始上传';
      case 'delete':
        return '没有可删除的文件\n请先添加一些文件';
      case 'add':
        return '点击下方按钮选择要添加的文件类型\n支持录音、图片、视频、文档等';
      default:
        return '暂无内容';
    }
  }
}
