import 'package:flutter/material.dart';

class AnnualRingsAlbumScreen extends StatefulWidget {
  const AnnualRingsAlbumScreen({super.key});

  @override
  State<AnnualRingsAlbumScreen> createState() => _AnnualRingsAlbumScreenState();
}

class _AnnualRingsAlbumScreenState extends State<AnnualRingsAlbumScreen> {
  // 当前海报图片
  String _currentPosterImage = 'assets/images/default_poster.jpg';
  
  // 当前年份
  int _selectedYear = DateTime.now().year;
  
  // 海报配文
  String _posterText = '记录生活中每一个美好的瞬间，让时光在指尖流淌，让回忆在心中绽放。';

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
              // 海报墙区域
              _buildPosterWall(),
              
              // 控制区域 (年份设置、查看按钮、配文)
              _buildControlArea(),
              
              // 相册内容区域
              Expanded(
                child: _buildAlbumContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建海报墙
  Widget _buildPosterWall() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(top: 0), // 距离页面顶部0px间距
      child: Stack(
        children: [
          // 海报背景图片
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              image: DecorationImage(
                image: AssetImage(_currentPosterImage),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // 如果图片加载失败，使用默认颜色
                },
              ),
            ),
            child: Container(
              // 添加渐变遮罩，让文字更清晰
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          
          // 点击区域 - 整个海报都可以点击更换
          Positioned.fill(
            child: GestureDetector(
              onTap: _changePoster,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          
          // 返回按钮 - 悬浮在左上角
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // 海报标题或提示文字
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              '点击更换海报',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建控制区域
  Widget _buildControlArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 年份设置按钮 - 30px*150px
          _buildYearButton(),
          
          const SizedBox(width: 10), // 间距10px
          
          // 查看按钮
          _buildViewButton(),
          
          const SizedBox(width: 10), // 间距10px
          
          // 海报配文显示区域
          Expanded(
            child: _buildPosterTextArea(),
          ),
        ],
      ),
    );
  }

  /// 构建年份设置按钮
  Widget _buildYearButton() {
    return GestureDetector(
      onTap: _showYearPicker,
      child: Container(
        width: 150, // 宽度150px
        height: 30,  // 高度30px
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(0xFF4E4D4D),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '$_selectedYear年',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建查看按钮
  Widget _buildViewButton() {
    return GestureDetector(
      onTap: _viewAlbumDetails,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(0xFF4E4D4D),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.visibility,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  /// 构建海报配文显示区域
  Widget _buildPosterTextArea() {
    return Container(
      height: 30, // 与年份设置按钮和查看按钮高度一致
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Color(0xFF4E4D4D).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _posterText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14, // 字号14px
            height: 1.14, // 行距2px (14px字体 + 2px行距 = 16px总行高，所以height = 16/14 ≈ 1.14)
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2, // 支持换行，最多2行
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// 构建相册内容区域
  Widget _buildAlbumContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 占位内容，后续可以添加相册网格或列表
          Expanded(
            child: Center(
              child: Text(
                '${_selectedYear}年的记忆\n\n即将展示相册内容...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 更换海报
  void _changePoster() {
    // 这里可以实现选择图片的逻辑
    // 暂时使用示例逻辑
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: const Text(
            '更换海报',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '请选择新的海报图片',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 这里添加选择图片的逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('海报更换功能开发中...'),
                  ),
                );
              },
              child: const Text(
                '确定',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 显示年份选择器
  void _showYearPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D3748),
          title: const Text(
            '选择年份',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: 300,
            height: 200,
            child: YearPicker(
              firstDate: DateTime(1990),
              lastDate: DateTime.now(),
              initialDate: DateTime(_selectedYear),
              selectedDate: DateTime(_selectedYear),
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime.year;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  /// 查看相册详情
  void _viewAlbumDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('查看${_selectedYear}年相册详情'),
        backgroundColor: Color(0xFF2D5016),
      ),
    );
  }
}
