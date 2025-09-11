import 'package:flutter/material.dart';
import '../widgets/create_package_button.dart';
import '../widgets/package_card.dart';
import '../services/package_manager.dart';

class StablePackageScreen extends StatefulWidget {
  const StablePackageScreen({super.key});

  @override
  State<StablePackageScreen> createState() => _StablePackageScreenState();
}

class _StablePackageScreenState extends State<StablePackageScreen> {
  late PackageManager _packageManager;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _packageManager = PackageManager();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 延迟加载，确保界面稳定
      await Future.delayed(const Duration(milliseconds: 100));
      _packageManager.loadTestData();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      appBar: AppBar(
        title: const Text('Lifepack - 包裹管理'),
        backgroundColor: const Color(0xFF081C15),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 20),
                
                // 标题和统计
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '包裹管理中心',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _packageManager,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_packageManager.packageCount} 个包裹',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 创建包裹按钮
                const CreatePackageButton(),
                
                const SizedBox(height: 20),
                
                // 包裹列表
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: AnimatedBuilder(
                      animation: _packageManager,
                      builder: (context, child) {
                        if (_packageManager.packages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '暂无包裹',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '点击上方按钮创建第一个包裹',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: _packageManager.packages.length,
                          itemBuilder: (context, index) {
                            final package = _packageManager.packages[index];
                            return Container(
                              key: ValueKey(package.id),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: PackageCard(
                                package: package,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('包裹: ${package.packageNumber}'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
