import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../guardian_service/guardian_service_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/vault_file_display_area.dart';
import '../../models/asset_file.dart';
import '../../widgets/asset_card.dart';
import '../../services/asset_storage_service.dart';
import '../../widgets/asset_clue_dialog.dart';

class AssetsManagementScreen extends StatefulWidget {
  const AssetsManagementScreen({super.key});

  @override
  State<AssetsManagementScreen> createState() => _AssetsManagementScreenState();
}

class _AssetsManagementScreenState extends State<AssetsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AssetFile> _assets = []; // 添加资产列表
  bool _isLoading = true; // 添加加载状态

  @override
  void initState() {
    super.initState();
    _loadAssets(); // 初始化时加载资产
  }

  // 加载资产数据
  Future<void> _loadAssets() async {
    try {
      final loadedAssets = await AssetStorageService.loadAssets();
      if (mounted) {
        setState(() {
          _assets = loadedAssets;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载资产失败: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF004D40), // 深青绿色
              Color(0xFF00695C), // 青绿色
              Color(0xFF00897B), // 较亮青绿色
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 头部区域
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // 返回按钮
                    GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // 标题
                    Expanded(
                      child: Text(
                        '资产管理（${_assets.length}个文件）',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // 占位，保持标题居中
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 搜索和功能区域
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 搜索容器 (45%宽度)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45 - 24,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF333333),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Icon(
                                Icons.search,
                                color: Color(0xFF999999),
                                size: 18,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '搜索资产...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                  isDense: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 功能按钮组 (45%宽度)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45 - 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 新建按钮 (+ 图标)
                            _buildAddButton(),

                            // 编辑按钮
                            _buildFunctionButton('编辑'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 资产信息列表区域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal,
                          ),
                        )
                      : _assets.isEmpty
                          ? VaultFileDisplayArea(
                              title: '资产信息',
                              icon: Icons.account_balance,
                              titleColor: Colors.teal,
                              emptyMessage: '暂无资产信息',
                              emptySubMessage: '点击上方"+"按钮添加新的资产记录',
                              emptyIcon: Icons.account_balance_wallet,
                            )
                          : _buildAssetList(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            // 更新当前导航索引
          });
          // 导航逻辑
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GuardianServiceScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // 构建添加按钮 - 采用首页年轮相册按钮同样的风格
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showAssetOptions,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 58,
          height: 28, // 总高度36px，减去padding 8px = 28px
          padding: const EdgeInsets.all(6), // 减少内边距以适应36px高度
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF333333), Color(0xFF242323)],
            ),
            border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 16,
              shadows: [
                Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 3,
                  color: Color(0x4D000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建功能按钮 - 采用首页年轮相册按钮同样的风格
  Widget _buildFunctionButton(String title) {
    return GestureDetector(
      onTap: () {
        print('点击了$title按钮');
      },
      child: Container(
        height: 36, // 匹配搜索框高度
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ), // 调整垂直内边距
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF333333), Color(0xFF242323)],
            ),
            border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: 0.5,
                height: 0.8,
                shadows: [
                  Shadow(offset: Offset(-1, -1), color: Color(0x1AE0E0E0)),
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 3,
                    color: Color(0x4D000000),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 显示资产选项对话框
  void _showAssetOptions() {
    // 资产类型列表
    final List<Map<String, dynamic>> assetTypes = [
      {
        'name': '储蓄',
        'icon': Icons.savings,
        'colors': [Color(0xFF7A69F9), Color(0xFF9C88FF)],
      },
      {
        'name': '房产',
        'icon': Icons.home,
        'colors': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      },
      {
        'name': '证券',
        'icon': Icons.trending_up,
        'colors': [Color(0xFF4ECDC4), Color(0xFF6FDDDD)],
      },
      {
        'name': '保险',
        'icon': Icons.security,
        'colors': [Color(0xFFFFE66D), Color(0xFFFFED8A)],
      },
      {
        'name': '基金',
        'icon': Icons.account_balance_wallet,
        'colors': [Color(0xFF95E1D3), Color(0xFFB8E6DC)],
      },

      {
        'name': '理财',
        'icon': Icons.monetization_on,
        'colors': [Color(0xFFF38BA8), Color(0xFFF5A3BB)],
      },
      {
        'name': '债权',
        'icon': Icons.receipt_long,
        'colors': [Color(0xFFA8DADC), Color(0xFFBDE3E5)],
      },
      {
        'name': '藏品',
        'icon': Icons.diamond,
        'colors': [Color(0xFFFFB3BA), Color(0xFFFFCDD2)],
      },
      {
        'name': '数字货币',
        'icon': Icons.currency_bitcoin,
        'colors': [Color(0xFFFFAE42), Color(0xFFFFBF69)],
      },
      {
        'name': '储值卡',
        'icon': Icons.credit_card,
        'colors': [Color(0xFF84A59D), Color(0xFF9BB5B0)],
      },

      {
        'name': '股权',
        'icon': Icons.business,
        'colors': [Color(0xFFB19CD9), Color(0xFFC8B5E6)],
      },
      {
        'name': '车辆',
        'icon': Icons.directions_car,
        'colors': [Color(0xFF6C5CE7), Color(0xFF8B7ED8)],
      },
      {
        'name': '跨境资产',
        'icon': Icons.public,
        'colors': [Color(0xFF00B894), Color(0xFF26D0CE)],
      },
      {
        'name': '信托',
        'icon': Icons.account_balance,
        'colors': [Color(0xFFE17055), Color(0xFFE89880)],
      },
      {
        'name': '专利',
        'icon': Icons.lightbulb,
        'colors': [Color(0xFF0984E3), Color(0xFF3498DB)],
      },

      {
        'name': '版权',
        'icon': Icons.copyright,
        'colors': [Color(0xFFD63031), Color(0xFFE55656)],
      },
      {
        'name': '手机解锁码',
        'icon': Icons.phone_android,
        'colors': [Color(0xFF6C5CE7), Color(0xFF8B7ED8)],
      },
      {
        'name': '其他',
        'icon': Icons.more_horiz,
        'colors': [Color(0xFF636E72), Color(0xFF7F8C8D)],
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D3748),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              const Text(
                '选择资产类型',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 资产类型网格
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 每行5个
                    childAspectRatio: 1.2, // 宽高比
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: assetTypes.length,
                  itemBuilder: (context, index) {
                    final assetType = assetTypes[index];
                    return _buildAssetCapsule(
                      assetType['name'],
                      assetType['icon'],
                      assetType['colors'],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 取消按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5568),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('取消'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建资产胶囊卡片
  Widget _buildAssetCapsule(String name, IconData icon, List<Color> colors) {
    return GestureDetector(
      onTap: () {
        print('点击了资产类型: $name'); // 添加调试信息
        Navigator.of(context).pop();
        _showAssetClueDialog(name, colors);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: const Color(0xFF2D3748).withOpacity(0.9),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示资产线索弹窗
  void _showAssetClueDialog(String assetType, List<Color> colors) {
    print('显示${assetType}线索弹窗'); // 添加调试信息

    final assetConfig = _getAssetConfig(assetType);
    
    AssetClueDialog.show(
      context: context,
      assetType: assetType,
      colors: colors,
      labels: assetConfig['labels'],
      explanation: assetConfig['explanation'],
      onCreateAsset: _createAsset,
    );
  }

  // 获取资产配置
  Map<String, dynamic> _getAssetConfig(String assetType) {
    switch (assetType) {
      case '储蓄':
        return {
          'labels': [
            '开户行所在城市',
            '开户行网点名称',
            '卡号或账号尾号',
            '密码提示词或问题',
            '开户行所在城市/区，卡号或账号尾号四位',
            '备注',
          ],
          'explanation':
              '银行不会提供集中查询，需定点查询。银行存款是个人最常见的资产形式。其继承流程通常取决于存款金额。根据相关规定，存款金额低于5万元人民币可简化办理，而超过5万元则通常需要办理继承公证。一个重要的挑战是，银行不会主动通知受益人，受益人必须主动向银行查询。银行账户没有全国性的中央查询系统，受益人无法仅凭身份信息在人民银行或银联进行集中查询。因此，明确的开户行和账号尾号是缩小查找范围、证明身份关联性的最关键线索。城市/区域信息能帮助受益人直达具体分支机构，避免一家一家无谓的奔波。这两种信息结合，将大海捞针式的查询转变为定点查询，极大地提升了效率。在法律流程中，第一顺序继承人凭死亡证明、亲属关系证明和本人有效身份证件，可向存款所在银行业金融机构申请查询存款余额，甚至可以查询死亡前6个月内的账户交易明细。提示词中的"开户行"和"卡号/尾号"正是启动这一查询流程的必备信息，完美地将应用功能与现实法律操作相结合，为受益人提供了明确的行动指南。',
        };
      case '房产':
        return {
          'labels': [
            '房产证编号尾号',
            '房产所在城市/区',
            '购房合同存放地',
            '产权人身份证号尾号',
            '房产所在城市/区，房产证编号尾号四位',
            '备注',
          ],
          'explanation':
              '房产证是基础心法律文件，需先找到房产证。房产继承需要法律文件支持。房产证是确认产权归属的核心法律文件，其编号是房产管理部门识别特定房产的唯一标识。在继承流程中，继承人需要向房产所在地的不动产登记中心申请查询和办理继承手续。明确的房产证编号和所在区域信息，能够帮助继承人快速定位到具体的管理部门和房产档案，避免在多个部门间奔波查找。购房合同作为补充证明文件，在房产证遗失的情况下具有重要的证明价值。根据《不动产登记暂行条例》，继承人可以凭借死亡证明、亲属关系证明等材料申请查询被继承人名下的不动产信息，房产证编号是启动这一查询流程的关键信息。',
        };
      case '证券':
        return {
          'labels': [
            '开户券商名称',
            '资金账户或股东号',
            '交易密码提示词',
            '券商客户经理姓名',
            '开户券商名称，资金账户或股东号',
            '备注',
          ],
          'explanation':
              '账户信息是向券商查询过户的唯一凭证。证券资产的继承需要通过证券公司进行确认和过户。证券账户信息是识别投资者身份和资产的核心要素，资金账户号或股东代码是证券公司系统中的唯一标识。在继承流程中，继承人需要向开户券商提供相关证明材料申请查询和继承手续。明确的券商名称和账户信息能够帮助继承人直接联系到正确的证券公司，避免在多家券商间查找的困扰。根据《证券法》和相关规定，证券公司有义务协助合法继承人办理证券资产的继承手续，但前提是能够准确识别账户信息。客户经理信息作为补充联系方式，在紧急情况下能够提供额外的沟通渠道。',
        };
      case '保险':
        return {
          'labels': [
            '投保保险公司',
            '保单号或合同号',
            '保单存放位置',
            '受益人指定情况',
            '投保保险公司名称，保单号或合同号',
            '备注',
          ],
          'explanation':
              '报案需明确保单号，有专门效力。保险理赔需要明确的保单信息和受益人确认。保单号是保险公司识别具体保险合同的唯一标识，是启动理赔流程的必要信息。在被保险人身故后，受益人需要向保险公司报案并提供相关证明材料。明确的保险公司名称和保单号能够帮助受益人快速联系到正确的保险公司并启动理赔程序。根据《保险法》规定，保险公司在收到理赔申请后有义务进行调查核实，保单号是这一流程的起点。受益人指定情况直接影响理赔款的分配，是理赔过程中的关键信息。保单存放位置信息有助于受益人快速找到相关文件，避免因文件缺失而延误理赔时效。',
        };
      case '基金':
        return {
          'labels': [
            '基金公司或代销行',
            '账户或基金账号',
            '账户密码提示词',
            '基金申购合同存放地',
            '基金公司或代销行，账户或基金账号',
            '备注',
          ],
          'explanation':
              '需区分自营代销机构，定位机构是首要任务。基金资产的继承需要通过基金公司或代销机构进行确认。基金账户信息是识别投资者身份和持有份额的关键要素，不同的销售机构有不同的账户体系。在继承流程中，继承人需要向基金公司或代销机构提供相关证明材料申请查询和继承手续。明确的销售机构和账户信息能够帮助继承人准确定位资产所在的管理机构，避免在多家机构间查找的困扰。根据相关法规，基金公司和代销机构有义务协助合法继承人办理基金资产的继承手续，但需要准确的账户识别信息。申购合同作为补充证明文件，在账户信息不完整的情况下具有重要的证明价值。',
        };
      case '理财':
        return {
          'labels': [
            '理财产品发行机构',
            '产品名称或编号',
            '理财合同存放位置',
            '产品到期日或类型',
            '理财产品发行机构，理财合同存放位置',
            '备注',
          ],
          'explanation':
              '合同是证明权利的关键凭证，物理位置提示至关重要。理财产品的继承需要明确的产品信息和合同文件。理财产品通常由银行、证券公司、保险公司等金融机构发行，产品编号或名称是识别具体理财产品的关键信息。在继承流程中，继承人需要向发行机构提供相关证明材料申请查询和继承手续。理财合同是证明投资关系和权益的核心法律文件，其存放位置信息对于继承人快速获取相关证明材料至关重要。根据相关法规，金融机构有义务协助合法继承人办理理财产品的继承手续，但需要准确的产品识别信息和合同文件。产品到期日信息有助于判断理财产品的当前状态，影响继承手续的具体流程。',
        };
      case '债权':
        return {
          'labels': [
            '债务人姓名/机构名',
            '债权凭证存放地',
            '原始债款金额编号',
            '相关法律文书',
            '债务人姓名/机构名，债权凭证存放地',
            '备注',
          ],
          'explanation':
              '需找到法律文书以证明债权存在。债权的继承需要充分的法律证明文件。债权作为一种财产权利，其存在和范围需要通过相关法律文件进行证明。在继承流程中，继承人需要收集完整的债权凭证，包括借款合同、欠条、法院判决书等法律文件。明确的债务人信息和凭证存放位置能够帮助继承人快速收集相关证明材料，为后续的债权主张提供法律依据。根据《民法典》等相关法律规定，债权可以依法继承，但继承人需要提供充分的证明材料来证明债权的存在和范围。法律文书的完整性直接影响债权实现的可能性，是债权继承中的核心要素。',
        };
      case '藏品':
        return {
          'labels': [
            '藏品类型或名称',
            '实物藏品存放地点',
            '鉴定证书存放地',
            '数字藏品私钥线索',
            '藏品类型或名称，实物藏品存放地点',
            '备注',
          ],
          'explanation':
              '需定位实物并找到其价值证明文件。藏品的继承涉及实物定位和价值认定两个关键环节。藏品作为特殊的财产形式，其价值往往需要专业鉴定来确认。在继承流程中，继承人首先需要找到实物藏品的存放位置，然后收集相关的鉴定证书、购买凭证等价值证明文件。明确的藏品信息和存放地点能够帮助继承人快速定位实物资产，避免遗漏或损失。鉴定证书是证明藏品真实性和价值的重要文件，其存放位置信息对于继承人评估和处置藏品具有重要意义。对于数字藏品，私钥信息是访问和转移数字资产的唯一凭证，需要特别妥善保管和传递。',
        };
      case '数字货币':
        return {
          'labels': [
            '数字钱包APP名称',
            '私钥或助记词存放地',
            '钱包密码提示词',
            '私钥备份设备或位置',
            '数字钱包APP名称，私钥或助记词存放地',
            '备注',
          ],
          'explanation':
              '去中心化资产，无机构可依赖，私钥为唯一凭证。数字货币的继承完全依赖于私钥或助记词的获取。与传统金融资产不同，数字货币采用去中心化存储，没有中央机构可以协助恢复访问权限。私钥或助记词是控制数字货币资产的唯一凭证，一旦丢失将无法找回。在继承流程中，继承人必须获得准确的私钥信息才能访问和转移数字资产。明确的钱包信息和私钥存放位置是数字货币继承的核心要素。由于数字货币的匿名性和不可逆性，继承人需要格外谨慎地处理相关信息，确保在安全的环境下进行资产转移。备份设备和位置信息提供了额外的安全保障，是数字货币资产保护的重要措施。',
        };
      case '储值卡':
        return {
          'labels': [
            '卡片类型或名称',
            '卡号后四位',
            '发卡机构名称',
            '卡片存放地点',
            '卡片类型或名称，卡号后四位',
            '备注',
          ],
          'explanation':
              '定位卡片是第一步，先起联系发卡机构。储值卡的继承需要实物卡片和发卡机构的配合。储值卡作为预付费消费工具，其余额信息存储在发卡机构的系统中。在继承流程中，继承人需要找到实物卡片，然后联系发卡机构查询余额和办理相关手续。明确的卡片信息和存放位置能够帮助继承人快速定位实物资产。发卡机构信息是查询余额和办理继承手续的关键，不同机构有不同的处理流程和要求。根据相关规定，储值卡余额在符合条件的情况下可以办理退款或转移手续，但需要提供相应的证明材料和实物卡片。卡号信息是发卡机构识别具体账户的重要标识。',
        };
      case '股权':
        return {
          'labels': [
            '公司名称或注册地',
            '股权凭证存放位置',
            '持股数量或比例',
            '公司联系人/董事',
            '公司名称或注册地，股权凭证存放位置',
            '备注',
          ],
          'explanation':
              '需与公司联系，先起提过户依据。股权的继承需要公司配合和相关法律程序。股权作为公司所有权的体现，其继承涉及公司治理和股东权利的变更。在继承流程中，继承人需要向公司提供相关证明材料，申请办理股权过户手续。明确的公司信息和股权凭证位置能够帮助继承人快速联系到相关方面，启动继承程序。根据《公司法》等相关法律规定，股权可以依法继承，但需要履行相应的法律程序和公司内部程序。股权凭证是证明股东身份和持股比例的重要文件，其完整性直接影响继承手续的顺利进行。公司联系人信息为继承人提供了直接的沟通渠道。',
        };
      case '车辆':
        return {
          'labels': [
            '车牌号',
            '车辆登记证存放地',
            '车辆停放位置',
            '是否有未清算罚单',
            '车牌号，车辆登记证存放地',
            '备注',
          ],
          'explanation':
              '车牌号是唯一标识，登记证是过户必需。车辆的继承需要完整的登记证件和过户手续。车辆作为重要的财产形式，其继承涉及车辆管理部门的登记变更。在继承流程中，继承人需要向车辆管理所提供相关证明材料，申请办理车辆过户手续。车牌号是车辆的唯一标识，车辆登记证是证明车辆所有权的核心文件。明确的车辆信息和证件存放位置能够帮助继承人快速收集相关材料，顺利办理过户手续。根据相关法规，车辆可以依法继承，但需要清理相关违章罚款等事项。车辆停放位置信息有助于继承人及时接管和管理车辆资产，避免额外的费用和风险。',
        };
      case '跨境资产':
        return {
          'labels': [
            '资产所在国家/地区',
            '负责此事的律师/机构',
            '遗嘱或法律文书存放地',
            '当地联系人或受益人',
            '资产所在国家/地区，负责此事的律师/机构',
            '备注',
          ],
          'explanation':
              '涉及多国法律，需专业人士协助。跨境资产的继承涉及多国法律制度和复杂程序。不同国家和地区对于遗产继承有不同的法律规定和程序要求，继承人通常需要专业律师或机构的协助。在继承流程中，明确的资产所在地和专业服务机构信息是启动跨境继承程序的关键。当地联系人能够提供实地协助和信息支持，对于跨境继承的顺利进行具有重要意义。遗嘱或相关法律文书需要符合当地法律要求，其存放位置和内容的准确性直接影响继承的合法性和有效性。跨境资产继承通常涉及税务、汇率、时效等多个复杂因素，需要专业指导和长期规划。',
        };
      case '信托':
        return {
          'labels': [
            '受托人姓名或机构名',
            '信托合同编号',
            '信托合同存放地',
            '信托财产类型',
            '受托人姓名或机构名，信托合同存放地',
            '备注',
          ],
          'explanation':
              '财产可直接转移，续过遗产认证。信托财产具有独特的法律地位和传承机制。信托作为一种财产管理和传承工具，其设立目的往往就是为了实现财产的有序传承。在信托框架下，财产的所有权和受益权分离，受益人可以根据信托合同的约定获得相应权益。明确的受托人信息和信托合同是确认信托关系和权益分配的核心要素。根据《信托法》等相关法律规定，信托财产具有独立性，不属于委托人的遗产范围，因此可以避开复杂的遗产认证程序。信托合同的完整性和可执行性直接影响受益人权益的实现，其存放位置信息对于权益保护具有重要意义。',
        };
      case '专利':
        return {
          'labels': ['专利名称', '专利号', '专利证书存放地', '代理机构或联系人', '专利名称，专利号', '备注'],
          'explanation':
              '专利号是向专利局查询的唯一凭证。专利权的继承需要通过专利管理部门进行确认和变更。专利作为知识产权的重要形式，其继承涉及专利权的转移和登记变更。在继承流程中，继承人需要向国家知识产权局提供相关证明材料，申请办理专利权人变更手续。专利号是专利的唯一标识，是查询专利状态和办理相关手续的必要信息。明确的专利信息和证书存放位置能够帮助继承人快速收集相关材料，顺利办理权利变更。根据《专利法》等相关法律规定，专利权可以依法继承，但需要履行相应的登记程序。代理机构信息为继承人提供了专业的技术支持和程序指导。',
        };
      case '版权':
        return {
          'labels': [
            '作品名称',
            '版权登记号',
            '原始文件存放地',
            '代理机构或联系人',
            '作品名称，版权登记号',
            '备注',
          ],
          'explanation':
              '版权财产权可继承，登记号为法律依据。版权的继承涉及著作权中财产权利的转移。著作权包括人身权和财产权两部分，其中财产权可以依法继承。在继承流程中，继承人需要收集相关的版权证明材料，包括版权登记证书、原始创作文件等。版权登记号是版权管理部门识别具体作品的重要标识，是办理权利变更的必要信息。明确的作品信息和文件存放位置能够帮助继承人建立完整的权利证明链条。根据《著作权法》等相关法律规定，著作权中的财产权利可以依法继承，但需要提供充分的证明材料。原始文件的保存对于证明作品的创作时间和内容具有重要意义。',
        };
      case '手机解锁码':
        return {
          'labels': [
            '解锁密码提示问题',
            '密码联想提示或线索',
            '密码存放位置',
            '解锁密码备用方案',
            '解锁密码提示问题，密码联想提示或线索',
            '备注',
          ],
          'explanation':
              '不得直接记录密码，仅提供记忆辅助。手机解锁信息的传递需要平衡安全性和可用性。直接记录完整密码存在安全风险，因此采用提示和线索的方式更为安全。在实际使用中，继承人可以通过提示问题和联想线索来回忆或推导出正确的解锁密码。密码存放位置信息提供了获取完整密码的途径，但需要确保存放方式的安全性。备用方案为密码遗忘或失效的情况提供了替代解决途径。手机作为现代生活中的重要工具，往往包含大量的个人信息和数字资产，其解锁权限的传递对于数字遗产的继承具有重要意义。',
        };
      case '其他':
        return {
          'labels': [
            '资产类型（如：保险箱）',
            '存放位置（如：保险柜）',
            '访问方式或密码提示',
            '相关法律文件存放地',
            '资产类型，存放位置',
            '备注',
          ],
          'explanation':
              '自由填写，用于未归类资产的发现。其他类别为未能归入标准分类的特殊资产提供了灵活的记录方式。不同家庭和个人可能拥有各种特殊形式的财产，如收藏品、古董、艺术品、贵金属等，这些资产往往具有独特的存放方式和价值评估标准。在继承流程中，明确的资产描述和存放位置信息能够帮助继承人全面了解和接管各类财产。访问方式或密码信息为受限制访问的资产提供了获取途径。相关法律文件的存放位置信息有助于继承人收集必要的证明材料，为资产的合法继承提供支持。这一分类的灵活性确保了资产记录的完整性，避免重要财产的遗漏。',
        };
      default:
        return {
          'labels': ['信息1', '信息2', '信息3', '信息4', '必填项', '备注'],
          'explanation': '暂无说明',
        };
    }
  }

  // 创建资产
  void _createAsset(String assetType, List<String> values, List<Color> colors) {
    print('_createAsset 方法被调用: $assetType'); // 添加调试信息
    
    // 确保在正确的上下文中执行
    if (!mounted) {
      print('Widget 已经卸载，取消创建资产');
      return;
    }

    try {
      final assetConfig = _getAssetConfig(assetType);
      final labels = assetConfig['labels'] as List<String>;

      // 构建详细信息映射
      final Map<String, String> details = {};
      for (int i = 0; i < values.length && i < labels.length; i++) {
        details[labels[i]] = values[i];
        print('${labels[i]}: ${values[i]}'); // 调试信息
      }

      // 创建资产文件
      final asset = AssetFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        assetType: assetType,
        primaryInfo: values.isNotEmpty && values[0].isNotEmpty
            ? values[0]
            : '未填写${labels.isNotEmpty ? labels[0] : '信息'}',
        note: values.length > 1 ? values.last : '',
        timestamp: DateTime.now(),
        details: details,
        colors: colors,
      );

      print('准备添加资产到列表'); // 调试信息

      // 直接更新状态
      setState(() {
        _assets.add(asset);
      });

      // 异步保存到持久化存储
      AssetStorageService.saveAssets(_assets).then((saved) {
        if (saved) {
          print('资产已保存到本地存储');
        } else {
          print('资产保存失败');
        }
      }).catchError((error) {
        print('保存资产时出错: $error');
      });

      print('资产已添加，当前资产数量: ${_assets.length}'); // 调试信息

      // 显示成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$assetType线索创建成功'),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('创建资产时出错: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // 构建资产列表
  Widget _buildAssetList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          // 标题栏
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1A202C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '资产信息',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // 资产列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                final asset = _assets[index];
                return AssetCard(
                  asset: asset,
                  onNoteChanged: (note) async {
                    // 创建新的资产对象，更新备注
                    final updatedAsset = AssetFile(
                      id: asset.id,
                      assetType: asset.assetType,
                      primaryInfo: asset.primaryInfo,
                      note: note,
                      timestamp: asset.timestamp,
                      details: asset.details,
                      colors: asset.colors,
                    );
                    
                    setState(() {
                      _assets[index] = updatedAsset;
                    });
                    
                    // 保存到持久化存储
                    await AssetStorageService.saveAssets(_assets);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
