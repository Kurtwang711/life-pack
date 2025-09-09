import 'package:flutter/material.dart';
import '../models/checkin_model.dart';
import 'blessing_button.dart';
import 'progress_bar.dart';

class CheckinSection extends StatefulWidget {
  const CheckinSection({super.key});

  @override
  State<CheckinSection> createState() => _CheckinSectionState();
}

class _CheckinSectionState extends State<CheckinSection> {
  late CheckinManager checkinManager;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkinManager = CheckinManager();
    currentIndex = checkinManager.getTodayIndex();
  }

  void _onTokenSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  

  void _onPreviousDay() {
    setState(() {
      currentIndex = (currentIndex > 0) ? currentIndex - 1 : checkinManager.totalDays - 1;
    });
  }

  void _onNextDay() {
    final todayIndex = checkinManager.getTodayIndex();
    if (currentIndex < todayIndex) {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D1D1D), Color(0xFF1D1D1D)],
          ),
        ),
      child: Column(
        children: [
          // 顶部导航栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧菜单图标
              Icon(
                Icons.menu,
                color: Colors.grey[800],
                size: 24,
              ),
              
              // 中间祝福语按钮和箭头
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 左箭头
                  GestureDetector(
                    onTap: _onPreviousDay,
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 祝福语按钮
                  BlessingButton(
                    checkinManager: checkinManager,
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 右箭头
                  GestureDetector(
                    onTap: _onNextDay,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ],
              ),
              
              // 右侧时钟图标
              Icon(
                Icons.access_time,
                color: Colors.grey[800],
                size: 24,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 令牌列表
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: checkinManager.totalDays,
              itemBuilder: (context, index) {
                final day = checkinManager.checkinData[index];
                final isSelected = index == currentIndex;
                final isSigned = day.status == CheckinStatus.signed || day.status == CheckinStatus.madeUp;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      // 令牌容器
                      GestureDetector(
                        onTap: () => _onTokenSelected(index),
                        child: Container(
                          width: 64,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: day.status == CheckinStatus.signed
                                    ? [const Color(0xFF8a2be2).withOpacity(0.8), const Color(0xFF4b0082)]
                                    : day.status == CheckinStatus.madeUp
                                    ? [const Color(0xFFff8c00).withOpacity(0.8), const Color(0xFFb8860b)]
                                    : (index < checkinManager.getTodayIndex())
                                    ? [Colors.red.withOpacity(0.5), Colors.red.withOpacity(0.7)]
                                    : [const Color(0xFF333333), const Color(0xFF242323)],
                              ),
                              border: (index > checkinManager.getTodayIndex())
                                  ? const Border(top: BorderSide(color: Color(0xFF4E4D4D)))
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 日期数字
                                Text(
                                  '${day.day}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // 刮奖区域
                                Container(
                                  width: 40,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: (isSigned && day.rewardRevealed) 
                                        ? Colors.transparent
                                        : Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: (isSigned && day.rewardRevealed && day.reward != null)
                                      ? Center(
                                          child: Text(
                                            day.reward!.getDisplayText(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // 选中状态小圆点
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 进度条
          ProgressBarWidget(
            checkinManager: checkinManager,
          ),
        ],
      ),
      ),
    );
  }
}
