import 'package:flutter/material.dart';

class MinimalTestScreen extends StatefulWidget {
  const MinimalTestScreen({super.key});

  @override
  State<MinimalTestScreen> createState() => _MinimalTestScreenState();
}

class _MinimalTestScreenState extends State<MinimalTestScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    print('计数器值: $_counter');
  }

  @override
  Widget build(BuildContext context) {
    print('正在构建MinimalTestScreen，计数器: $_counter');
    
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332),
      appBar: AppBar(
        title: const Text('最小测试屏幕'),
        backgroundColor: const Color(0xFF081C15),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '这是一个最简单的测试界面',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '计数器: $_counter',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('点击增加计数'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showTestDialog();
              },
              child: const Text('显示弹窗'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('测试弹窗'),
        content: Text('当前计数器值: $_counter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
