class PackageModel {
  final String id; // 包裹唯一ID
  final String packageNumber; // 包裹号（16位组合）
  final String recipient; // 收件人姓名
  final String phone; // 手机号
  final String deliveryMethod; // 投递方式
  final String? address; // 地址（实体U盘）
  final String? email; // 邮箱（邮件+云盘）
  final DateTime createdAt; // 创建时间
  final DateTime lastModified; // 最后修改时间
  final int sequenceNumber; // 序号（1、2、3...）

  PackageModel({
    required this.id,
    required this.packageNumber,
    required this.recipient,
    required this.phone,
    required this.deliveryMethod,
    this.address,
    this.email,
    required this.createdAt,
    required this.lastModified,
    required this.sequenceNumber,
  });

  /// 生成包裹号：用户名首字母+时间戳+收件人首字母+随机数字和字母补全的总计16个字母数字组合
  static String generatePackageNumber(String userName, String recipientName) {
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    final recipientInitial = recipientName.isNotEmpty
        ? recipientName[0].toUpperCase()
        : 'R';
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7, 13); // 6位时间戳

    // 生成8位随机字符（数字和字母）
    final random = DateTime.now().microsecondsSinceEpoch % 100000000;
    final randomStr = random.toString().padLeft(8, '0');

    return '$userInitial$timestamp$recipientInitial$randomStr';
  }

  /// 获取投递方式显示名称
  String get deliveryMethodDisplayName {
    switch (deliveryMethod) {
      case 'physical_usb':
        return '实体U盘';
      case 'email_cloud':
        return '邮箱+网盘';
      case 'package_id_app':
        return '包裹号登录App';
      default:
        return deliveryMethod;
    }
  }

  /// 是否有第二行信息（地址或邮箱）
  bool get hasSecondLine {
    return deliveryMethod == 'physical_usb' || deliveryMethod == 'email_cloud';
  }

  /// 获取第二行显示内容
  String? get secondLineContent {
    if (deliveryMethod == 'physical_usb') {
      return address;
    } else if (deliveryMethod == 'email_cloud') {
      return email;
    }
    return null;
  }

  /// 从Map创建PackageModel
  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      id: map['id'] ?? '',
      packageNumber: map['packageNumber'] ?? '',
      recipient: map['recipient'] ?? '',
      phone: map['phone'] ?? '',
      deliveryMethod: map['deliveryMethod'] ?? '',
      address: map['address'],
      email: map['email'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastModified: DateTime.fromMillisecondsSinceEpoch(
        map['lastModified'] ?? 0,
      ),
      sequenceNumber: map['sequenceNumber'] ?? 1,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageNumber': packageNumber,
      'recipient': recipient,
      'phone': phone,
      'deliveryMethod': deliveryMethod,
      'address': address,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastModified': lastModified.millisecondsSinceEpoch,
      'sequenceNumber': sequenceNumber,
    };
  }

  /// 复制并更新某些字段
  PackageModel copyWith({
    String? id,
    String? packageNumber,
    String? recipient,
    String? phone,
    String? deliveryMethod,
    String? address,
    String? email,
    DateTime? createdAt,
    DateTime? lastModified,
    int? sequenceNumber,
  }) {
    return PackageModel(
      id: id ?? this.id,
      packageNumber: packageNumber ?? this.packageNumber,
      recipient: recipient ?? this.recipient,
      phone: phone ?? this.phone,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      address: address ?? this.address,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    );
  }
}
