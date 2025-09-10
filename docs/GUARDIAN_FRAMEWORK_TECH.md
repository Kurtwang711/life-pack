# 守望框架技术实现文档

## 概述
守望框架是Life Pack应用的核心安全保障模块，通过智能监控用户的数字生活轨迹，在异常情况下自动启动预警和联系机制，为用户提供全方位的生活安全保障。

## 当前实现状态 ✅

### 已完成功能

#### 1. 守望服务主界面
- **文件位置**: `lib/screens/guardian_service/guardian_service_screen.dart`
- **核心功能**: 
  - 登录频次监控设置 (30天未登录检测)
  - 运动步数监控设置 (30天无步数检测)  
  - 守望流程可视化展示
  - 流程图收缩/展开功能

#### 2. 流程图可视化系统
- **组件**: `_buildGuardianFlowChart()`
- **特点**:
  - 6步流程卡片展示
  - 自定义虚线连接器
  - 流程方向指示箭头
  - 时间和次数标签

#### 3. 监控流程设计
```
用户超期 → 企业微信联系 → 短信联系 → 400电话联系 → 紧急联系人 → 投递收件人
    ↓         ↓ (24小时3次)    ↓ (24小时3次)   ↓ (24小时3次)    ↓ (无限次)     ↓
   检测      自动提醒        人工确认      电话确认       逐级联系      最终处理
```

#### 4. UI组件实现
- **卡片尺寸**: 120px × 60px
- **编号显示**: 数字前置式 (`1 用户超期`)
- **动态布局**: 左右卡片靠边对齐
- **交互动画**: 收缩按钮旋转动效

## 技术架构

### 核心类结构
```dart
class GuardianServiceScreen extends StatefulWidget {
  // 守望服务主界面
}

class _GuardianServiceScreenState extends State<GuardianServiceScreen> {
  // 状态变量
  String _loginMonitorDays = '30天未登录';
  String _stepMonitorDays = '30天无步数';  
  bool _isFlowChartExpanded = true;
  
  // 核心方法
  Widget _buildGuardianFlowChart();    // 构建流程图
  Widget _buildFlowCard();             // 构建流程卡片
  Widget _buildHorizontalConnector();  // 构建水平连接器
  Widget _buildVerticalConnector();    // 构建垂直连接器
}

class DashedLinePainter extends CustomPainter {
  // 自定义虚线绘制器
}
```

### 数据模型
```dart
class GuardianFlow {
  final String title;          // 流程标题
  final String subtitle;       // 流程描述  
  final Color color;          // 流程颜色
  final String timeLimit;     // 时间限制
  final int maxAttempts;      // 最大尝试次数
  final List<String> contactMethods; // 联系方式
}
```

## 界面设计规范

### 1. 色彩系统
- **背景色**: `Color(0xFF1a1a1a)` - 深色主题
- **卡片色**: `Color(0xFF3f3f3f)` - 中性灰
- **文字色**: `Colors.white` - 主文字
- **辅助色**: `Colors.white.withOpacity(0.7)` - 次要文字
- **边框色**: 根据流程类型动态设置

### 2. 尺寸规范
- **卡片尺寸**: 120px × 60px
- **圆角半径**: 8px
- **边框宽度**: 3px (左侧彩色边框)
- **阴影效果**: `BlurRadius: 4, Offset: (0, 2)`
- **间距标准**: 8px, 16px, 24px

### 3. 字体规范
- **主标题**: 14px, FontWeight.w500
- **卡片标题**: 12px, FontWeight.w600  
- **副标题**: 10px, 70%透明度
- **连接器标签**: 10px, `Color(0xFF9ca3af)`

## 动画系统

### 1. 收缩动画
```dart
AnimatedRotation(
  turns: _isFlowChartExpanded ? 0 : -0.5,
  duration: const Duration(milliseconds: 300),
  child: Icons.keyboard_arrow_down,
)
```

### 2. 内容切换动画
```dart
AnimatedCrossFade(
  duration: const Duration(milliseconds: 300),
  crossFadeState: _isFlowChartExpanded 
      ? CrossFadeState.showFirst 
      : CrossFadeState.showSecond,
  firstChild: _buildGuardianFlowChart(),
  secondChild: const SizedBox(width: double.infinity, height: 0),
)
```

## 自定义绘制

### 虚线连接器实现
```dart
class DashedLinePainter extends CustomPainter {
  final bool isVertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6b7280)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 绘制虚线逻辑
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    // ... 虚线绘制算法
  }
}
```

## 响应式布局

### 1. 自适应卡片排列
```dart
Row(
  children: [
    Container(
      margin: const EdgeInsets.only(left: 10), // 左侧卡片靠左
      child: _buildFlowCard(...),
    ),
    Expanded(child: _buildHorizontalConnector(...)), // 连接器自适应
    Container(
      margin: const EdgeInsets.only(right: 10), // 右侧卡片靠右
      child: _buildFlowCard(...),
    ),
  ],
)
```

### 2. 流程连接器布局
- **水平连接器**: 支持正向和反向箭头
- **垂直连接器**: 自适应高度和标签位置
- **标签定位**: 背景遮罩确保可读性

## 待开发功能

### 1. 监控数据收集 🚧
```dart
class GuardianMonitorService {
  // 用户活跃度监控
  Future<void> trackUserActivity() async {
    // 记录登录时间、操作频率等
  }
  
  // 健康数据监控  
  Future<void> monitorHealthData() async {
    // 接入HealthKit/Google Fit
  }
  
  // 异常检测算法
  bool detectAnomalies(UserActivityData data) {
    // 基于机器学习的异常检测
  }
}
```

### 2. 智能预警系统 🚧
```dart
class AlertSystem {
  // 分级预警机制
  void triggerAlert(AlertLevel level, AlertReason reason) {
    switch(level) {
      case AlertLevel.info:    // 信息提醒
      case AlertLevel.warning: // 注意预警  
      case AlertLevel.critical: // 紧急警报
      case AlertLevel.emergency: // 应急响应
    }
  }
  
  // 联系人通知
  Future<void> notifyContacts(List<EmergencyContact> contacts) async {
    // 按优先级顺序联系
  }
}
```

### 3. 数据分析报告 🚧
```dart
class GuardianAnalytics {
  // 生成健康报告
  Future<HealthReport> generateHealthReport() async {}
  
  // 风险评估
  RiskAssessment assessUserRisk() {}
  
  // 趋势分析
  List<Trend> analyzeTrends(Duration period) {}
}
```

## 数据存储设计

### 本地数据表
```sql
-- 守望配置表
CREATE TABLE guardian_config (
  user_id VARCHAR(36) PRIMARY KEY,
  login_monitor_days INT DEFAULT 30,
  step_monitor_days INT DEFAULT 30,
  emergency_contacts TEXT, -- JSON格式
  notification_settings TEXT, -- JSON格式
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 监控日志表
CREATE TABLE guardian_logs (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36),
  monitor_type VARCHAR(50), -- 'login', 'steps', 'heartrate'
  data_value DECIMAL(10,2),
  status VARCHAR(20), -- 'normal', 'warning', 'critical'
  recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 预警记录表  
CREATE TABLE alert_records (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36),
  alert_level VARCHAR(20),
  alert_reason TEXT,
  contacts_notified TEXT, -- JSON格式
  resolved_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 性能优化

### 1. 数据采集优化
- **批量上报**: 每5分钟批量上报监控数据
- **差量同步**: 只同步变化的配置项
- **本地缓存**: 离线情况下本地存储

### 2. UI渲染优化
- **Widget复用**: 流程卡片组件复用
- **懒加载**: 历史数据分页加载
- **动画优化**: 减少重绘范围

### 3. 电池优化
- **智能采样**: 根据用户习惯调整采样频率
- **后台限制**: 非关键监控降低后台运行频率
- **传感器管理**: 按需启用传感器

## 隐私安全

### 1. 数据加密
- **本地加密**: AES-256加密存储敏感数据
- **传输加密**: HTTPS + Certificate Pinning
- **密钥管理**: 基于设备唯一标识生成密钥

### 2. 权限管理
- **最小权限**: 只请求必要的系统权限
- **用户控制**: 用户可随时关闭特定监控
- **透明度**: 清晰说明数据使用目的

### 3. 合规设计
- **GDPR合规**: 支持数据导出和删除
- **本地优先**: 敏感数据优先本地处理
- **匿名化**: 上报数据去除个人标识

## 测试策略

### 1. 单元测试
```dart
// 流程图组件测试
testWidgets('Guardian flow chart displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(GuardianServiceScreen());
  expect(find.text('守望流程'), findsOneWidget);
  expect(find.text('1 用户超期'), findsOneWidget);
});

// 数据处理逻辑测试
test('Alert threshold calculation', () {
  final calculator = AlertCalculator();
  expect(calculator.shouldTriggerAlert(30), equals(true));
});
```

### 2. 集成测试
- 监控数据采集流程测试
- 预警触发机制测试  
- 联系人通知功能测试

### 3. 压力测试
- 大量监控数据处理性能
- 长时间运行稳定性
- 内存泄漏检测

## 部署配置

### 1. 环境配置
```yaml
# pubspec.yaml 依赖
dependencies:
  health: ^9.0.0           # 健康数据接入
  permission_handler: ^10.0.0 # 权限管理
  flutter_local_notifications: ^15.0.0 # 本地通知
  workmanager: ^0.5.0      # 后台任务
  encrypt: ^5.0.0          # 数据加密
```

### 2. 平台配置
```xml
<!-- Android权限 -->
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
```

```plist
<!-- iOS权限 -->
<key>NSHealthShareUsageDescription</key>
<string>需要访问健康数据来监控您的运动状态</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要位置信息来提供紧急联系服务</string>
```

## 版本迭代计划

### v1.0 (当前版本) ✅
- 基础UI界面
- 流程图可视化
- 收缩展开功能
- 静态配置设置

### v1.1 (下一版本) 🚧  
- 真实监控数据接入
- 基础预警功能
- 联系人管理
- 本地数据存储

### v1.2 (未来版本) 📋
- 智能异常检测
- 机器学习优化
- 高级分析报告
- 云端数据同步

### v1.3 (长期规划) 🔮
- 家庭群组监控
- 医疗机构对接
- IoT设备集成
- 国际化支持

---

*文档版本: v1.0*  
*最后更新: 2025年9月10日*  
*技术负责: Guardian Framework Team*  
*代码覆盖: lib/screens/guardian_service/*
