import 'package:flutter/material.dart';
import '../widgets/create_package_button.dart';
import '../widgets/package_list.dart';
import '../services/package_manager.dart';

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  late PackageManager _packageManager;

  @override
  void initState() {
    super.initState();
    _packageManager = PackageManager();
    // 加载测试数据
    _packageManager.loadTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      appBar: AppBar(
        title: const Text('Lifepack'),
        backgroundColor: const Color(0xFF081C15),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 标题
            const Text(
              '包裹管理',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 创建包裹按钮
            const Center(child: CreatePackageButton()),
            
            const SizedBox(height: 20),
            
            // 包裹列表
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListenableBuilder(
                  listenable: _packageManager,
                  builder: (context, child) {
                    try {
                      print('正在构建包裹列表，包裹数量: ${_packageManager.packageCount}');
                      
                      if (_packageManager.packages.isEmpty) {
                        return const Center(
                          child: Text(
                            '暂无包裹\n点击上方按钮创建包裹',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '包裹总数: ${_packageManager.packageCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _packageManager.loadTestData();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            PackageList(
                              packages: _packageManager.packages,
                              onPackageTap: (package) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('点击了包裹: ${package.packageNumber}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      print('构建包裹列表时发生错误: $e');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '包裹列表加载失败\n$e',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _packageManager.loadTestData();
                                });
                              },
                              child: const Text('重新加载'),
                            ),
                          ],
                        ),
                      );
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
}
