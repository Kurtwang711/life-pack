class CheckinDay {
  final int day;
  CheckinStatus status;
  String blessing;
  CheckinReward? reward;
  bool rewardRevealed;

  CheckinDay({
    required this.day,
    required this.status,
    required this.blessing,
    this.reward,
    this.rewardRevealed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'status': status.toString().split('.').last,
      'blessing': blessing,
      'reward': reward?.toJson(),
      'rewardRevealed': rewardRevealed,
    };
  }

  factory CheckinDay.fromJson(Map<String, dynamic> json) {
    return CheckinDay(
      day: json['day'],
      status: CheckinStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      blessing: json['blessing'],
      reward: json['reward'] != null
          ? CheckinReward.fromJson(json['reward'])
          : null,
      rewardRevealed: json['rewardRevealed'] ?? false,
    );
  }
}

enum CheckinStatus {
  unsigned, // 未签到
  signed, // 已签到
  madeUp, // 已补签
  future, // 未来日期
}

class CheckinReward {
  final int points;
  final int cash;
  final int memberDays;

  CheckinReward({
    required this.points,
    required this.cash,
    required this.memberDays,
  });

  Map<String, dynamic> toJson() {
    return {'points': points, 'cash': cash, 'memberDays': memberDays};
  }

  factory CheckinReward.fromJson(Map<String, dynamic> json) {
    return CheckinReward(
      points: json['points'] ?? 0,
      cash: json['cash'] ?? 0,
      memberDays: json['memberDays'] ?? 0,
    );
  }

  String getDisplayText() {
    if (points > 0) return '$points积分';
    if (cash > 0) return '$cash现金';
    if (memberDays > 0) return '$memberDays天';
    return '';
  }
}

class CheckinManager {
  static const List<String> _blessings = [
    '万事如意',
    '心想事成',
    '身体健康',
    '财源广进',
    '学业有成',
    '爱情美满',
    '阖家幸福',
    '事业顺利',
    '平安喜乐',
    '幸福安康',
  ];

  static const int _totalDays = 99;
  static final DateTime _startDate = DateTime(2025, 1, 1);

  List<CheckinDay> _checkinData = [];

  int get totalDays => _totalDays;
  List<CheckinDay> get checkinData => _checkinData;

  CheckinManager() {
    _initializeData();
  }

  void _initializeData() {
    _checkinData = List.generate(_totalDays, (index) {
      return CheckinDay(
        day: index + 1,
        status: CheckinStatus.unsigned,
        blessing: _blessings[index % _blessings.length],
      );
    });
  }

  int getTodayIndex() {
    final now = DateTime.now();
    final difference = now.difference(_startDate).inDays;
    return (difference >= 0 && difference < _totalDays) ? difference : 0;
  }

  void handleCheckin(int index) {
    if (index >= _checkinData.length) return;

    final todayIndex = getTodayIndex();
    CheckinReward reward;

    if (index == todayIndex) {
      // 今日签到
      reward = CheckinReward(points: 40, cash: 0, memberDays: 0);
      _checkinData[index].blessing = '万事如意';
      _checkinData[index].status = CheckinStatus.signed;
    } else if (index < todayIndex) {
      // 补签
      final rewardOptions = [
        CheckinReward(points: 5, cash: 0, memberDays: 0),
        CheckinReward(points: 10, cash: 1, memberDays: 0),
        CheckinReward(points: 0, cash: 0, memberDays: 1),
      ];
      reward = rewardOptions[index % rewardOptions.length];
      _checkinData[index].blessing =
          _blessings[(index + 1) % _blessings.length];
      _checkinData[index].status = CheckinStatus.madeUp;
    } else {
      return; // 未来日期不能签到
    }

    _checkinData[index].reward = reward;
    _checkinData[index].rewardRevealed = true;
  }

  String getButtonText(int index) {
    final todayIndex = getTodayIndex();
    final day = _checkinData[index];

    if (index < todayIndex) {
      // 过去的日期
      if (day.status == CheckinStatus.unsigned) {
        return '补签';
      } else {
        return day.blessing;
      }
    } else if (index == todayIndex) {
      // 今天
      if (day.status == CheckinStatus.unsigned) {
        return '签到';
      } else {
        return day.blessing;
      }
    } else {
      // 未来日期
      return '改天再来！';
    }
  }

  bool canCheckin(int index) {
    final todayIndex = getTodayIndex();
    final day = _checkinData[index];

    if (index > todayIndex) return false; // 未来日期
    return day.status == CheckinStatus.unsigned; // 未签到的日期
  }

  Map<String, int> getStats() {
    int completedCount = 0;
    int totalPoints = 0;
    int totalCash = 0;
    int totalMemberDays = 0;

    for (var day in _checkinData) {
      if (day.status == CheckinStatus.signed ||
          day.status == CheckinStatus.madeUp) {
        completedCount++;
        if (day.reward != null) {
          totalPoints += day.reward!.points;
          totalCash += day.reward!.cash;
          totalMemberDays += day.reward!.memberDays;
        }
      }
    }

    return {
      'completed': completedCount,
      'total': _totalDays,
      'points': totalPoints,
      'cash': totalCash,
      'memberDays': totalMemberDays,
    };
  }
}
