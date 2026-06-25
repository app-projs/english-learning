# 开发文档

本文档提供英语学习App的详细开发指南和技术文档。

## 📚 文档目录

### 开发指南
- [环境搭建](./development/01-setup.md) - 开发环境配置
- [代码规范](./development/02-coding-standards.md) - 编码规范和最佳实践
- [架构设计](./development/03-architecture.md) - 应用架构说明
- [测试指南](./development/04-testing.md) - 单元测试和集成测试

### 功能文档
- [阅读模块](./features/01-reading.md) - 文章阅读功能详解
- [练习模块](./features/02-practice.md) - 各种练习功能说明
- [对话模块](./features/03-dialogue.md) - 对话练习功能详解
- [用户系统](./features/03-user-system.md) - 用户管理和进度追踪
- [设置功能](./features/04-settings.md) - 应用设置和配置

### 计划文档
- [主产品需求文档 (Master PRD)](./prd/master_prd.md) - 最新的产品需求与设计规范
- [V1 MVP 版本需求文档](./prd/v1_mvp.md) - 第一阶段 MVP 范围
- [V2 AI与社交版本需求文档](./prd/v2_ai_social.md) - 第二阶段网络/社交/听力/AI 规划
- [V3 深度学习与云同步版本需求文档](./prd/v3_cloud_sync.md) - 第三阶段完全体规划
- [Google Stitch 提示词指南](./prd/stitch_prompts.md) - 配合 Stitch 快速生成 UI 视觉设计图的 AI 提示词
- [开发进度](./plan/development-progress.md) - 详细的开发进度追踪
- [功能分解](./plan/feature-breakdown.md) - 完整的功能模块分解
- [执行计划](./plan/module-execution-plan.md) - 可执行的功能开发计划
- [技术栈](./plan/tech-stack.md) - 技术选型和架构规划

### API文档
- [数据模型](./api/01-data-models.md) - 完整的数据模型定义
- [本地存储](./api/02-local-storage.md) - 本地数据存储方案
- [API接口](./api/03-rest-api.md) - 后端API接口文档

### 部署指南
- [Android部署](./deployment/01-android.md) - Android应用打包发布
- [iOS部署](./deployment/02-ios.md) - iOS应用打包发布
- [CI/CD配置](./deployment/03-ci-cd.md) - 持续集成和部署

## 🚀 快速导航

### 新手开发者
1. 先阅读 [环境搭建](./development/01-setup.md) 配置开发环境
2. 了解 [代码规范](./development/02-coding-standards.md) 
3. 查看 [架构设计](./development/03-architecture.md) 理解项目结构

### 功能开发者
1. 查看对应的功能文档了解需求
2. 阅读 [数据模型](./api/01-data-models.md) 了解数据结构
3. 参考 [测试指南](./development/04-testing.md) 编写测试

### 运维人员
1. 查看 [部署指南](./deployment/) 了解发布流程
2. 配置 [CI/CD](./deployment/03-ci-cd.md) 自动化部署

## 📝 文档维护

### 更新原则
1. **及时性**：功能变更后及时更新文档
2. **准确性**：确保文档与代码保持一致
3. **完整性**：包含必要的示例和说明
4. **可读性**：使用清晰的结构和语言

### 贡献流程
1. 修改代码时同步更新相关文档
2. 文档变更包含在代码提交中
3. 定期检查文档的时效性和准确性

---

**最后更新**：2026年2月12日  
**维护者**：开发团队