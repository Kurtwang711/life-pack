# Changelog

All notable changes to this project will be documented in this file.

## [1.4.5] - 2025-01-12

### Added
- ✅ 完整的资产管理功能
- ✅ 18种资产类别的线索卡片系统
  - 储蓄、房产、证券、保险、基金、理财、债权、藏品
  - 数字货币、储值卡、股权、车辆、跨境资产、信托
  - 专利、版权、手机解锁码、其他
- ✅ 每种资产类型的专业提示词和法律依据说明
- ✅ 统一的资产卡片展示和管理界面
- ✅ 资产详情预览功能
- ✅ 备注编辑功能
- ✅ 法律声明提示

### Fixed
- ✅ 修复了资产线索弹窗的状态管理问题
- ✅ 优化了数据传递机制，避免controller生命周期冲突
- ✅ 改进了弹窗关闭和数据创建的时序

### Known Issues
- ❌ **严重缺陷**: 创建资产信息卡片后应用崩溃
  - 错误信息: `Failed assertion: line 6161 pos 14: '_dependents.isEmpty': is not true`
  - 影响范围: 所有资产类型的创建功能
  - 临时解决方案: 重启应用后可查看已创建的资产
  - 状态: 待修复

### Technical Details
- 资产模型: `AssetFile` 类支持完整的资产信息存储
- 资产卡片: `AssetCard` 组件提供统一的展示界面
- 通用弹窗: `_AssetClueDialog` 支持所有资产类型的配置
- 数据持久化: 暂时使用内存存储，重启后数据丢失

### Next Version Plan (1.4.6)
- 🔧 修复资产创建后的崩溃问题
- 💾 添加数据持久化存储
- 🔍 优化资产搜索功能
- 📱 改进移动端适配

---

## [1.4.4] - Previous Version
### Features
- 基础的资产管理页面框架
- 录音管理功能
- 文档管理功能
- 图片和视频管理功能