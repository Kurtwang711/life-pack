import 'package:flutter/material.dart';
import '../models/checkin_model.dart';

class TokenList extends StatefulWidget {
  final CheckinManager checkinManager;
  final int currentIndex;
  final Function(int) onTokenSelected;

  const TokenList({
    super.key,
    required this.checkinManager,
    required this.currentIndex,
    required this.onTokenSelected,
  });

  @override
  _TokenListState createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 滚动到当前选中的令牌
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToken(widget.currentIndex);
    });
  }

  @override
  void didUpdateWidget(TokenList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToToken(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToken(int index) {
    const tokenWidth = 64.0;
    const tokenSpacing = 12.0;
    const itemWidth = tokenWidth + tokenSpacing;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final screenWidth = MediaQuery.of(context).size.width;
        final targetOffset =
            (index * itemWidth) - (screenWidth / 2) + (tokenWidth / 2);

        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.checkinManager.totalDays,
        itemBuilder: (context, index) {
          final day = widget.checkinManager.checkinData[index];
          final isSelected = index == widget.currentIndex;
          final isSigned =
              day.status == CheckinStatus.signed ||
              day.status == CheckinStatus.madeUp;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                // 令牌容器
                GestureDetector(
                  onTap: () => widget.onTokenSelected(index),
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
                              ? [
                                  const Color(0xFF8a2be2).withOpacity(0.8),
                                  const Color(0xFF4b0082),
                                ]
                              : day.status == CheckinStatus.madeUp
                              ? [
                                  const Color(0xFFff8c00).withOpacity(0.8),
                                  const Color(0xFFb8860b),
                                ]
                              : (index < widget.checkinManager.getTodayIndex())
                              ? [
                                  Colors.red.withOpacity(0.5),
                                  Colors.red.withOpacity(0.7),
                                ]
                              : [
                                  const Color(0xFF333333),
                                  const Color(0xFF242323),
                                ],
                        ),
                        border: (index > widget.checkinManager.getTodayIndex())
                            ? const Border(
                                top: BorderSide(color: Color(0xFF4E4D4D)),
                              )
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
                            child:
                                (isSigned &&
                                    day.rewardRevealed &&
                                    day.reward != null)
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
    );
  }
}
