# 黑屏问题修复报告

## 问题描述
在 iOS 模拟器上运行应用时，创建包裹并点击"确认创建包裹"按钮后，应用出现黑屏。

## 问题原因
代码中存在双重 `Navigator.pop()` 调用，导致不仅关闭了模态框，还意外关闭了主屏幕：

1. **PackageCreationForm** 组件的 `_submitForm` 方法中：
   - 调用 `widget.onSubmit?.call(formData)` 传递数据
   - 然后又调用 `widget.onClose?.call()` 关闭表单

2. **CreatePackageButton** 组件中：
   - `onClose` 回调定义为 `() => Navigator.of(context).pop()`
   - `onSubmit` 回调中也调用了 `Navigator.of(context).pop()`

这导致了两次连续的 `pop()` 操作：
- 第一次关闭模态框（正确）
- 第二次关闭主屏幕（错误），导致黑屏

## 解决方案

### 1. 修改 PackageCreationForm (package_creation_form.dart)
移除 `_submitForm` 方法中的 `widget.onClose?.call()` 调用，让父组件统一处理导航逻辑。

```dart
// 修改前
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // ... 准备数据
    widget.onSubmit?.call(formData);
    
    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(...);
    
    // 关闭表单 - 这里导致了重复关闭
    widget.onClose?.call();
  }
}

// 修改后
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // ... 准备数据
    // 只调用onSubmit，让父组件处理导航和提示
    widget.onSubmit?.call(formData);
  }
}
```

### 2. 优化 CreatePackageButton (create_package_button.dart)
使用不同的 context 来区分模态框和主屏幕的导航：

```dart
// 修改前
showModalBottomSheet(
  builder: (context) => PackageCreationForm(
    onClose: () => Navigator.of(context).pop(),
    onSubmit: (formData) {
      // ... 创建包裹
      Navigator.of(context).pop(); // 可能关闭主屏幕
    },
  ),
);

// 修改后
showModalBottomSheet(
  builder: (modalContext) => PackageCreationForm(
    onClose: () => Navigator.of(modalContext).pop(),
    onSubmit: (formData) {
      // ... 创建包裹
      Navigator.of(modalContext).pop(); // 确保只关闭模态框
      
      // 使用原始context显示SnackBar
      ScaffoldMessenger.of(context).showSnackBar(...);
    },
  ),
);
```

## 测试步骤
1. 运行应用：`flutter run`
2. 点击"创建包裹"按钮
3. 填写包裹信息：
   - 收件人姓名
   - 手机号码
   - 选择投递方式
4. 点击"确认创建包裹"
5. 验证：
   - 模态框应该正常关闭
   - 主屏幕应该保持显示
   - 应该看到"包裹创建成功"的提示消息
   - 包裹列表应该更新

## 修复状态
✅ 已完成修复
- 移除了 PackageCreationForm 中的重复关闭调用
- 优化了 CreatePackageButton 中的 context 使用
- 确保导航操作只影响模态框，不会影响主屏幕

## 相关文件
- `/lib/widgets/package_creation_form.dart` - 第56-82行
- `/lib/widgets/create_package_button.dart` - 第15-52行
