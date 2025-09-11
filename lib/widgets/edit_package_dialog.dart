import 'package:flutter/material.dart';
import '../models/package_model.dart';

class EditPackageDialog extends StatefulWidget {
  final PackageModel package;
  final VoidCallback? onClose;
  final Function(Map<String, dynamic>)? onSubmit;

  const EditPackageDialog({
    super.key,
    required this.package,
    this.onClose,
    this.onSubmit,
  });

  @override
  State<EditPackageDialog> createState() => _EditPackageDialogState();
}

class _EditPackageDialogState extends State<EditPackageDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _recipientController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  late String _selectedDeliveryMethod;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    
    // 初始化控制器，填入现有数据
    _recipientController = TextEditingController(text: widget.package.recipient);
    _phoneController = TextEditingController(text: widget.package.phone);
    _addressController = TextEditingController(text: widget.package.address ?? '');
    _emailController = TextEditingController(text: widget.package.email ?? '');
    _selectedDeliveryMethod = widget.package.deliveryMethod;
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    
    // 如果有选中的投递方式，立即展开
    if (_selectedDeliveryMethod.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _expandController.forward();
      });
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onDeliveryMethodChanged(String method) {
    setState(() {
      _selectedDeliveryMethod = method;
    });
    _expandController.reset();
    _expandController.forward();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'id': widget.package.id,
        'recipient': _recipientController.text,
        'phone': _phoneController.text,
        'deliveryMethod': _selectedDeliveryMethod,
        'address': _addressController.text,
        'email': _emailController.text,
      };

      widget.onSubmit?.call(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Color(0xFF333333), width: 1),
          left: BorderSide(color: Color(0xFF333333), width: 1),
          right: BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
      child: Column(
        children: [
          // 头部区域
          _buildHeader(),

          // 表单内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 收件人输入
                    _buildInputField(
                      label: '收件人',
                      controller: _recipientController,
                      hintText: '请输入收件人姓名',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '请输入收件人姓名';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // 手机号输入
                    _buildInputField(
                      label: '手机号',
                      controller: _phoneController,
                      hintText: '请输入收件人手机号',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '请输入收件人手机号';
                        }
                        if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value.trim())) {
                          return '请输入正确的手机号格式';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // 投递方式选择
                    _buildDeliveryMethodSection(),

                    const SizedBox(height: 32),

                    // 确认按钮
                    _buildSubmitButton(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 关闭按钮
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          // 标题
          Expanded(
            child: Text(
              '修改包裹信息',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 占位，保持标题居中
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label：',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF666666)),
            filled: true,
            fillColor: const Color(0xFF2a2a2a),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF444444), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF444444), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF51A5FF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '投递方式：',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // 实体U盘选项
        _buildDeliveryOption(
          value: 'physical_usb',
          title: '实体U盘',
          icon: Icons.usb,
          isSelected: _selectedDeliveryMethod == 'physical_usb',
          onTap: () => _onDeliveryMethodChanged('physical_usb'),
        ),

        // 实体U盘展开内容
        if (_selectedDeliveryMethod == 'physical_usb')
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(left: 32, top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF444444),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('⭐ 为确保正确投递，客服会先电联收件人并使用挂号方式寄达。'),
                      _buildInfoItem('⭐ U盘采用数据封闭灌装，隐私安全有保障。'),
                      _buildInfoItem('⭐ 本投递方式需额外付费69元/包裹（含快递和U盘费用）。'),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '详细地址',
                        controller: _addressController,
                        hintText: '请输入收件人详细地址',
                        validator: _selectedDeliveryMethod == 'physical_usb'
                            ? (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '请输入收件人详细地址';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 12),

        // 邮件+云盘选项
        _buildDeliveryOption(
          value: 'email_cloud',
          title: '邮件+云盘',
          icon: Icons.cloud_upload,
          isSelected: _selectedDeliveryMethod == 'email_cloud',
          onTap: () => _onDeliveryMethodChanged('email_cloud'),
        ),

        // 邮件+云盘展开内容
        if (_selectedDeliveryMethod == 'email_cloud')
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(left: 32, top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF444444),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('⭐ 为确保正确投递，客服会电联收件人。'),
                      _buildInfoItem('⭐ 邮件中会有安全的云盘链接供收件人下载包裹。'),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '电子邮箱',
                        controller: _emailController,
                        hintText: '请输入收件人电子邮箱',
                        keyboardType: TextInputType.emailAddress,
                        validator: _selectedDeliveryMethod == 'email_cloud'
                            ? (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '请输入收件人电子邮箱';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value.trim())) {
                                  return '请输入正确的邮箱格式';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 12),

        // 包裹号登录app选项
        _buildDeliveryOption(
          value: 'package_id_app',
          title: '包裹号登录App',
          icon: Icons.mobile_friendly,
          isSelected: _selectedDeliveryMethod == 'package_id_app',
          onTap: () => _onDeliveryMethodChanged('package_id_app'),
        ),

        // 包裹号登录app展开内容
        if (_selectedDeliveryMethod == 'package_id_app')
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(left: 32, top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF444444),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('⭐ 为确保正确投递，客服会电联收件人并短信通知包裹号和使用方法。'),
                      _buildInfoItem('⭐ 收件人需下载本App。'),
                      _buildInfoItem('⭐ 收件人仅能看见和下载您指定包裹的内容。'),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDeliveryOption({
    required String value,
    required String title,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF333333) : const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF51A5FF)
                : const Color(0xFF444444),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? const Color(0xFF51A5FF) : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF51A5FF) : Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool canSubmit =
        _selectedDeliveryMethod.isNotEmpty &&
        _recipientController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: canSubmit ? _submitForm : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: canSubmit
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF51A5FF), Color(0xFF3d8bfd)],
                  )
                : null,
            color: canSubmit ? null : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(8),
            boxShadow: canSubmit
                ? [
                    BoxShadow(
                      color: const Color(0xFF51A5FF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            '确认修改',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: canSubmit ? Colors.white : const Color(0xFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
