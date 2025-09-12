import 'package:flutter/material.dart';
import 'widgets/create_package_button.dart';
import 'widgets/package_list.dart';
import 'services/package_manager.dart';

class TestPackageScreen extends StatefulWidget {
  const TestPackageScreen({super.key});

  @override
  State<TestPackageScreen> createState() => _TestPackageScreenState();
}

class _TestPackageScreenState extends State<TestPackageScreen> {
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
      appBar: AppBar(
        title: const Text('测试包裹功能'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _packageManager.loadTestData();
              });
            },
          ),
        ],
      ),
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
              const SizedBox(height: 20),

              // 创建包裹按钮
              const Center(child: CreatePackageButton()),

              const SizedBox(height: 20),

              // 包裹列表
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListenableBuilder(
                    listenable: _packageManager,
                    builder: (context, child) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '包裹数量: ${_packageManager.packageCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '最后一个包裹: ${_packageManager.packages.isNotEmpty ? _packageManager.packages.last.packageNumber : "无"}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            PackageList(
                              packages: _packageManager.packages,
                              onPackageTap: (package) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '点击了包裹: ${package.packageNumber}',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 手动添加一个测试包裹
          _packageManager.addPackage(
            recipient: '测试收件人',
            phone: '13800138000',
            deliveryMethod: 'package_id_app',
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('已添加测试包裹')));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
