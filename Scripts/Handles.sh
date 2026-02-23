#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"

#修改argon主题字体和颜色
if [ -d *"luci-theme-argon"* ]; then
	cd ./luci-theme-argon/

	sed -i '/font-weight:/ {/!important/! s/\(font-weight:\s*\)[^;]*;/\1normal;/}' $(find ./luci-theme-argon -type f -iname "*.css")
	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/" ./luci-app-argon-config/root/etc/config/argon

	cd $PKG_PATH && echo "theme-argon has been fixed!"
fi

#修复Coremark编译失败
CM_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/coremark/Makefile")
if [ -f "$CM_FILE" ]; then
	sed -i 's/mkdir/mkdir -p/g' $CM_FILE

	cd $PKG_PATH && echo "coremark has been fixed!"
fi

#修改aurora菜单式样
if [ -d *"luci-app-aurora-config"* ]; then
	echo " "

	cd ./luci-app-aurora-config/

	sed -i "s/nav_submenu_type '.*'/nav_submenu_type 'boxed-dropdown'/g" $(find ./root/ -type f -name "*aurora")

	cd $PKG_PATH && echo "theme-aurora has been fixed!"
fi

#修复Rust编译失败
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "

	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE

	cd $PKG_PATH && echo "rust has been fixed!"
fi

# 修复 Tailscale 配置文件冲突
# 使用 find 确保在云端环境下也能正确定位到 feeds 中的 Makefile
TS_FILE=$(find ../feeds/packages/ -maxdepth 4 -type f -wholename "*/tailscale/Makefile")

if [ -f "$TS_FILE" ]; then
    echo "Tailscale 修复补丁正在应用: $TS_FILE"

    # 1. 删除 Makefile 中的 conffiles 定义段落 (防止包管理器标记文件归属)
    # 匹配从 define Package/tailscale/conffiles 到 endef 的所有内容并删除
    sed -i '/define Package\/tailscale\/conffiles/,/endef/d' "$TS_FILE"

    # 2. 删除具体的安装指令行
    # 针对你提供的双斜杠路径进行精准匹配删除
    sed -i '/\/etc\/init.d\/tailscale/d' "$TS_FILE"
    sed -i '/\/etc\/config\/tailscale/d' "$TS_FILE"

    # 3. 修正目录创建指令
    # 原本会创建 /etc/init.d 和 /etc/config，现在只保留 /usr/sbin
    sed -i 's/\$(INSTALL_DIR) \$(1)\/usr\/sbin \$(1)\/etc\/init.d \$(1)\/etc\/config/\$(INSTALL_DIR) \$(1)\/usr\/sbin/g' "$TS_FILE"

    echo "Tailscale 修复完成！"
fi