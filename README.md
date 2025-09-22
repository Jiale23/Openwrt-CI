# OpenWrt 固件持续集成 (CI/CD) 构建系统
个人自用

[![构建状态](https://img.shields.io/github/actions/workflow/status/Jiale23/Openwrt-CI/build-openwrt.yml?branch=main&label=构建状态)](https://github.com/Jiale23/Openwrt-CI/actions)
[![GitHub 最后提交](https://img.shields.io/github/last-commit/Jiale23/Openwrt-CI?label=最后更新)](https://github.com/Jiale23/Openwrt-CI/commits/main)

## 📌 简介

本项目旨在通过自动化流程，编译OpenWrt 固件。利用 GitHub Actions，可以在每次推送代码或按计划自动构建最新固件，无需本地环境，节省时间和资源。

## 🎯 特性

*   **自动化构建**: 基于 Git 提交或定时任务自动触发 OpenWrt 固件构建。
*   **配置灵活**: 通过版本控制管理 `.config` 配置文件和 `feeds.conf`，轻松复现和共享构建环境。
*   **多设备支持**: 可配置为同时或分别构建适用于不同硬件平台的固件。
*   **构建缓存**: 利用 CI 的缓存机制加速后续构建过程。
*   **构建日志**: 完整的在线构建日志，便于排查问题。

## 🛠️ 准备工作

*   **利用本仓库作为模板**: 点击仓库页面右上角的 "Use this template" 按钮，创建您自己的副本。

## 🚀 使用方法

### 1. 自定义配置

*   **修改 OpenWrt 源码和版本**:
    *   编辑 `.github/workflows/AutoBuild.yml` 文件中的 `SOURCE` 和 `BRANCH` 变量，指向您想要构建的 OpenWrt 源码仓库和分支。
*   **配置固件选项**:
    *   将您编译好的 `.config` 文件替换仓库根目录下的 `Config/General.txt` 文件。您可以使用 `make menuconfig` 在本地生成，或者从现有固件提取。
<!-- *   **配置软件包源 (Feeds)**:
    *   修改 `feeds.conf.default` 文件以添加或修改软件包源。如果需要使用自定义的 feeds 配置文件，请确保在构建脚本中正确引用它。 -->

### 2. 启动构建

<!-- *   **自动触发**: 推送 (`git push`) 更改到 `main` 分支，或者创建一个 Pull Request。 -->
*   **手动触发**: 在您的 GitHub 仓库页面，转到 `Actions` 选项卡，选择 `Build OpenWrt` 工作流，然后点击 `Run workflow` 按钮。
*   **定时触发**: 可以配置工作流以按计划（例如，每天凌晨）自动运行。

### 3. 获取固件

*   构建成功后，固件会自动上传到仓库的 [Actions](https://github.com/Jiale23/Openwrt-CI/actions) 页面。
*   您可以在对应的构建运行日志中找到详细的构建信息和产物列表。

## 📁 项目结构

*   `.github/workflows/AutoBuild.yml`: 主构建触发工作流文件。
*   `.github/workflows/OpenWrt-CI.yml`: 核心的可重用 OpenWrt 构建工作流。
*   `.github/workflows/AutoClean.yml`: 触发此构建的清理工作流（需存在）。
*   `configs/` 根目录下的 `.config` 文件
*   `README.md`: 本说明文件。

## 🧰 可配置参数 (在 `.github/workflows/AutoBuild.yml` 中传递给 `OpenWrt-CI.yml`)

| 参数名 (Key)     | 描述                                     | 示例值                 |
| :--------------- | :--------------------------------------- | :--------------------- |
| `WRT_CONFIG`     | 要构建的设备配置名称 (对应 matrix CONFIG) | `X86_64`               |
| `WRT_THEME`      | 默认 LuCI 主题                           | `argon`                |
| `WRT_NAME`       | 默认主机名                               | `Openwrt`              |
| `WRT_IP`         | 默认 LAN IP 地址                         | `192.168.31.1`         |
| `WRT_REPO`       | OpenWrt 源码仓库地址 (由 matrix SOURCE 构建) | `https://github.com/openwrt/openwrt.git` |
| `WRT_BRANCH`     | OpenWrt 源码分支 (对应 matrix BRANCH)    | `openwrt-24.10`        |
| `WRT_SOURCE`     | OpenWrt 源码仓库路径 (对应 matrix SOURCE) | `openwrt/openwrt`      |
| `WRT_PW`         | 默认 root 密码提示信息                   | `无`                   |
| `WRT_SSID`       | 默认 WiFi SSID                           | `Openwrt`              |
| `WRT_WORD`       | 默认 WiFi 密码                           | `12345678`             |


## ⚠️ 免责声明

*   本项目仅供学习和研究使用。
*   固件构建过程可能因网络、配置或源码问题而失败。
*   请在刷写固件前务必备份原始固件，并了解相关风险。
*   作者不对因使用此固件而导致的任何设备损坏负责。