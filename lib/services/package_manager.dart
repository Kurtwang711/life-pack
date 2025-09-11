import 'package:flutter/foundation.dart';
import '../models/package_model.dart';

class PackageManager extends ChangeNotifier {
  static final PackageManager _instance = PackageManager._internal();
  factory PackageManager() => _instance;
  PackageManager._internal();

  List<PackageModel> _packages = [];

  List<PackageModel> get packages => List.unmodifiable(_packages);

  /// 添加新包裹
  void addPackage({
    required String recipient,
    required String phone,
    required String deliveryMethod,
    String? address,
    String? email,
    String userName = 'User', // 默认用户名，实际使用时应该从用户系统获取
  }) {
    print('开始添加包裹: recipient=$recipient, phone=$phone, deliveryMethod=$deliveryMethod');
    
    final now = DateTime.now();
    final packageNumber = PackageModel.generatePackageNumber(
      userName,
      recipient,
    );
    final sequenceNumber = _packages.length + 1;

    final newPackage = PackageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      packageNumber: packageNumber,
      recipient: recipient,
      phone: phone,
      deliveryMethod: deliveryMethod,
      address: address,
      email: email,
      createdAt: now,
      lastModified: now,
      sequenceNumber: sequenceNumber,
    );

    print('创建包裹对象: ${newPackage.packageNumber}');
    
    _packages.add(newPackage);
    print('包裹添加到列表，当前数量: ${_packages.length}');
    
    // 立即通知监听器
    notifyListeners();
    print('监听器通知完成');
  }

  /// 从表单数据创建包裹
  void createPackageFromForm(Map<String, dynamic> formData) {
    try {
      print('正在创建包裹，表单数据: $formData');
      addPackage(
        recipient: formData['recipient'] ?? '',
        phone: formData['phone'] ?? '',
        deliveryMethod: formData['deliveryMethod'] ?? '',
        address: formData['address'],
        email: formData['email'],
      );
      print('包裹创建成功，当前包裹数量: ${_packages.length}');
    } catch (e) {
      print('包裹创建失败: $e');
      // 重新抛出异常，让调用方知道失败了
      rethrow;
    }
  }

  /// 删除包裹
  void removePackage(String packageId) {
    _packages.removeWhere((package) => package.id == packageId);
    // 重新分配序号
    _reAssignSequenceNumbers();
    notifyListeners();
  }

  /// 更新包裹
  void updatePackage(PackageModel updatedPackage) {
    final index = _packages.indexWhere(
      (package) => package.id == updatedPackage.id,
    );
    if (index != -1) {
      _packages[index] = updatedPackage.copyWith(lastModified: DateTime.now());
      notifyListeners();
    }
  }

  /// 重新分配序号
  void _reAssignSequenceNumbers() {
    for (int i = 0; i < _packages.length; i++) {
      _packages[i] = _packages[i].copyWith(sequenceNumber: i + 1);
    }
  }

  /// 根据ID获取包裹
  PackageModel? getPackageById(String id) {
    try {
      return _packages.firstWhere((package) => package.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 清空所有包裹
  void clearAllPackages() {
    _packages.clear();
    notifyListeners();
  }

  /// 获取包裹数量
  int get packageCount => _packages.length;

  /// 模拟加载一些测试数据
  void loadTestData() {
    final now = DateTime.now();

    // 清空现有数据
    _packages.clear();

    // 添加测试数据
    _packages.addAll([
      PackageModel(
        id: '1',
        packageNumber: '0000000000000004',
        recipient: '收件人',
        phone: '13966668888',
        deliveryMethod: 'package_id_app',
        createdAt: now.subtract(const Duration(hours: 2)),
        lastModified: now.subtract(const Duration(minutes: 30)),
        sequenceNumber: 1,
      ),
      PackageModel(
        id: '2',
        packageNumber: '0000000000000003',
        recipient: '收件人',
        phone: '13899996666',
        deliveryMethod: 'email_cloud',
        email: 'sheismine@hotmail.com',
        createdAt: now.subtract(const Duration(hours: 4)),
        lastModified: now.subtract(const Duration(minutes: 30)),
        sequenceNumber: 2,
      ),
      PackageModel(
        id: '3',
        packageNumber: '0000000000000002',
        recipient: '收件人',
        phone: '13899996666',
        deliveryMethod: 'physical_usb',
        address: '北京市朝阳区河北路大发小区1期2栋2302室',
        createdAt: now.subtract(const Duration(hours: 6)),
        lastModified: now.subtract(const Duration(minutes: 31)),
        sequenceNumber: 3,
      ),
    ]);

    notifyListeners();
  }
}
