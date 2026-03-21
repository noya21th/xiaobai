#!/usr/bin/env bash
# xiaobai 一键安装脚本
# 让天下没有不会编程的小白 (=^・ω・^=)
#
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.sh | bash -s -- --platform cursor
#   curl -fsSL https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.sh | bash -s -- --platform all

set -e

REPO="noya21th/xiaobai"
BRANCH="main"
ZIP_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"
RAW_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
TMP_DIR=$(mktemp -d)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# ─── 语言检测 ───

detect_lang() {
    local sys_lang="${LANG:-${LC_ALL:-${LC_MESSAGES:-en}}}"
    case "$sys_lang" in
        zh*|ZH*) echo "zh" ;;
        *)       echo "en" ;;
    esac
}

LANG_CODE=$(detect_lang)

if [ "$LANG_CODE" = "zh" ]; then
    SKILL_DIR="xiaobai"
    echo ""
    echo -e "  ${CYAN}(=^・ω・^=)${NC}  xiaobai 安装工具"
    echo -e "  ${DIM}让天下没有不会编程的小白${NC}"
    echo ""
else
    SKILL_DIR="xiaobai-en"
    echo ""
    echo -e "  ${CYAN}(=^・ω・^=)${NC}  xiaobai installer"
    echo -e "  ${DIM}No beginner left behind${NC}"
    echo ""
fi

# ─── 下载并解压 ───

download_zip() {
    echo -e "  ${DIM}正在下载...${NC}"
    if command -v curl &> /dev/null; then
        curl -fsSL "$ZIP_URL" -o "$TMP_DIR/xiaobai.zip"
    elif command -v wget &> /dev/null; then
        wget -q "$ZIP_URL" -O "$TMP_DIR/xiaobai.zip"
    else
        echo "  需要 curl 或 wget，但都没找到"
        exit 1
    fi

    if command -v unzip &> /dev/null; then
        unzip -q "$TMP_DIR/xiaobai.zip" -d "$TMP_DIR"
    elif command -v tar &> /dev/null; then
        # macOS 的 tar 也能解 zip
        cd "$TMP_DIR" && tar -xf xiaobai.zip && cd - > /dev/null
    else
        echo "  需要 unzip 或 tar，但都没找到"
        exit 1
    fi

    SRC="$TMP_DIR/xiaobai-$BRANCH"
    echo -e "  ${GREEN}下载完成${NC}"
}

# ─── 各平台安装函数 ───

install_claude() {
    local msg_install msg_done msg_hint
    if [ "$LANG_CODE" = "zh" ]; then
        msg_install="安装到 Claude Code"
        msg_done="已安装到"
        msg_hint="新开对话后输入 /xiaobai 即可使用"
    else
        msg_install="Installing to Claude Code"
        msg_done="Installed to"
        msg_hint="Start a new conversation and type /xiaobai to use"
    fi
    echo -e "  ${GREEN}${msg_install}${NC}"
    mkdir -p "$HOME/.claude/skills/xiaobai"
    cp "$SRC/skills/$SKILL_DIR/SKILL.md" "$HOME/.claude/skills/xiaobai/SKILL.md"
    echo -e "  ${GREEN}✓${NC} ${msg_done} ~/.claude/skills/xiaobai/"
    echo -e "  ${DIM}${msg_hint}${NC}"
}

install_cursor() {
    echo -e "  ${GREEN}安装到 Cursor${NC}"
    mkdir -p .cursor/rules 2>/dev/null || mkdir -p "$HOME/.cursor/rules"
    local target=".cursor/rules"
    [ ! -d ".cursor" ] && target="$HOME/.cursor/rules"
    cp "$SRC/cursor/rules/xiaobai.mdc" "$target/xiaobai.mdc"
    echo -e "  ${GREEN}✓${NC} 已安装到 $target/xiaobai.mdc"
    echo -e "  ${DIM}重启 Cursor 后自动生效${NC}"
}

install_vscode() {
    echo -e "  ${GREEN}安装到 VS Code (GitHub Copilot)${NC}"
    mkdir -p .github 2>/dev/null || mkdir -p "$HOME/.github"
    local target=".github"
    [ ! -d ".github" ] && target="$HOME/.github"
    cp "$SRC/vscode/copilot-instructions.md" "$target/copilot-instructions.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 $target/copilot-instructions.md"
    echo -e "  ${YELLOW}记得在设置里开启：${NC}"
    echo -e "  ${DIM}github.copilot.chat.codeGeneration.useInstructionFiles: true${NC}"
}

install_codex() {
    echo -e "  ${GREEN}安装到 OpenAI Codex CLI${NC}"
    mkdir -p .codex/xiaobai 2>/dev/null || mkdir -p "$HOME/.codex/xiaobai"
    local target=".codex/xiaobai"
    [ ! -d ".codex" ] && target="$HOME/.codex/xiaobai"
    cp "$SRC/codex/xiaobai/SKILL.md" "$target/SKILL.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 $target/SKILL.md"
}

install_kiro() {
    echo -e "  ${GREEN}安装到 Amazon Kiro${NC}"
    mkdir -p .kiro/steering 2>/dev/null || mkdir -p "$HOME/.kiro/steering"
    local target=".kiro/steering"
    [ ! -d ".kiro" ] && target="$HOME/.kiro/steering"
    cp "$SRC/kiro/steering/xiaobai.md" "$target/xiaobai.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 $target/xiaobai.md"
}

install_codebuddy() {
    echo -e "  ${GREEN}安装到 Tencent CodeBuddy${NC}"
    mkdir -p .codebuddy 2>/dev/null || mkdir -p "$HOME/.codebuddy"
    local target=".codebuddy"
    [ ! -d ".codebuddy" ] && target="$HOME/.codebuddy"
    cp "$SRC/codebuddy/xiaobai.md" "$target/xiaobai.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 $target/xiaobai.md"
}

install_openclaw() {
    echo -e "  ${GREEN}安装到 OpenClaw${NC}"
    mkdir -p "$HOME/.openclaw/skills/xiaobai"
    cp "$SRC/skills/$SKILL_DIR/SKILL.md" "$HOME/.openclaw/skills/xiaobai/SKILL.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 ~/.openclaw/skills/xiaobai/"
}

install_antigravity() {
    echo -e "  ${GREEN}安装到 Google Antigravity${NC}"
    mkdir -p "$HOME/.antigravity/skills/xiaobai"
    cp "$SRC/skills/$SKILL_DIR/SKILL.md" "$HOME/.antigravity/skills/xiaobai/SKILL.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 ~/.antigravity/skills/xiaobai/"
}

install_opencode() {
    echo -e "  ${GREEN}安装到 OpenCode${NC}"
    mkdir -p "$HOME/.opencode/skills/xiaobai"
    cp "$SRC/skills/$SKILL_DIR/SKILL.md" "$HOME/.opencode/skills/xiaobai/SKILL.md"
    echo -e "  ${GREEN}✓${NC} 已安装到 ~/.opencode/skills/xiaobai/"
}

install_all() {
    echo -e "  ${CYAN}安装到所有平台${NC}"
    echo ""
    install_claude
    install_cursor
    install_vscode
    install_codex
    install_kiro
    install_codebuddy
    install_openclaw
    install_antigravity
    install_opencode
}

# ─── 平台检测 ───

detect_platform() {
    local found=""
    command -v claude &> /dev/null && found="${found}claude,"
    [ -d ".cursor" ] || [ -d "$HOME/.cursor" ] && found="${found}cursor,"
    [ -d ".vscode" ] || [ -d "$HOME/.vscode" ] && found="${found}vscode,"
    command -v codex &> /dev/null && found="${found}codex,"
    [ -d ".kiro" ] || [ -d "$HOME/.kiro" ] && found="${found}kiro,"
    [ -d ".codebuddy" ] || [ -d "$HOME/.codebuddy" ] && found="${found}codebuddy,"
    echo "$found"
}

# ─── 卸载 ───

uninstall() {
    echo -e "  ${YELLOW}正在卸载 xiaobai...${NC}"
    echo ""

    local removed=0

    for path in \
        "$HOME/.claude/skills/xiaobai" \
        "$HOME/.claude/skills/xiaobai-en" \
        ".cursor/rules/xiaobai.mdc" \
        "$HOME/.cursor/rules/xiaobai.mdc" \
        ".github/copilot-instructions.md" \
        ".codex/xiaobai" \
        "$HOME/.codex/xiaobai" \
        ".kiro/steering/xiaobai.md" \
        "$HOME/.kiro/steering/xiaobai.md" \
        ".codebuddy/xiaobai.md" \
        "$HOME/.codebuddy/xiaobai.md" \
        "$HOME/.openclaw/skills/xiaobai" \
        "$HOME/.antigravity/skills/xiaobai" \
        "$HOME/.opencode/skills/xiaobai"
    do
        if [ -e "$path" ]; then
            rm -rf "$path"
            echo -e "  ${GREEN}✓${NC} 已删除 $path"
            removed=$((removed + 1))
        fi
    done

    if [ $removed -eq 0 ]; then
        echo "  没找到已安装的 xiaobai"
    else
        echo ""
        echo -e "  已卸载 $removed 个平台的 xiaobai"
    fi

    echo ""
    if [ "$LANG_CODE" = "zh" ]; then
        echo -e "  ${DIM}(=_ _=)..zZZ  下次再见${NC}"
    else
        echo -e "  ${DIM}(=_ _=)..zZZ  See you next time${NC}"
    fi
    echo ""
    exit 0
}

# ─── 主流程 ───

# 解析参数
PLATFORM_ARG=""
UNINSTALL=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --platform|-p) PLATFORM_ARG="$2"; shift 2 ;;
        --uninstall|--remove|uninstall|remove) UNINSTALL=true; shift ;;
        *) shift ;;
    esac
done

# 卸载模式
if [ "$UNINSTALL" = true ]; then
    uninstall
fi

# 下载
download_zip

# 如果指定了平台
if [ -n "$PLATFORM_ARG" ]; then
    case $PLATFORM_ARG in
        claude)       install_claude ;;
        cursor)       install_cursor ;;
        vscode)       install_vscode ;;
        codex)        install_codex ;;
        kiro)         install_kiro ;;
        codebuddy)    install_codebuddy ;;
        openclaw)     install_openclaw ;;
        antigravity)  install_antigravity ;;
        opencode)     install_opencode ;;
        all)          install_all ;;
        *)
            echo "  未知平台：$PLATFORM_ARG"
            echo "  支持：claude, cursor, vscode, codex, kiro, codebuddy, openclaw, antigravity, opencode, all"
            exit 1
            ;;
    esac
else
    # 自动检测
    DETECTED=$(detect_platform)

    if [ -n "$DETECTED" ]; then
        echo -e "  ${CYAN}检测到以下平台：${NC}"
        echo ""
        [[ "$DETECTED" == *"claude"* ]] && echo "    · Claude Code"
        [[ "$DETECTED" == *"cursor"* ]] && echo "    · Cursor"
        [[ "$DETECTED" == *"vscode"* ]] && echo "    · VS Code"
        [[ "$DETECTED" == *"codex"* ]] && echo "    · Codex CLI"
        [[ "$DETECTED" == *"kiro"* ]] && echo "    · Kiro"
        [[ "$DETECTED" == *"codebuddy"* ]] && echo "    · CodeBuddy"
        echo ""

        [[ "$DETECTED" == *"claude"* ]] && install_claude
        [[ "$DETECTED" == *"cursor"* ]] && install_cursor
        [[ "$DETECTED" == *"vscode"* ]] && install_vscode
        [[ "$DETECTED" == *"codex"* ]] && install_codex
        [[ "$DETECTED" == *"kiro"* ]] && install_kiro
        [[ "$DETECTED" == *"codebuddy"* ]] && install_codebuddy
    else
        echo -e "  ${YELLOW}没检测到已知平台，你用的是哪个？${NC}"
        echo ""
        echo "   1) Claude Code          6) Tencent CodeBuddy"
        echo "   2) OpenAI Codex CLI     7) OpenClaw"
        echo "   3) Cursor               8) Google Antigravity"
        echo "   4) Amazon Kiro          9) OpenCode"
        echo "   5) VS Code (Copilot)    0) 全部安装"
        echo ""
        read -p "  输入数字（多选用空格隔开，如 1 3 5）: " -a choices

        for choice in "${choices[@]}"; do
            case $choice in
                1) install_claude ;;
                2) install_codex ;;
                3) install_cursor ;;
                4) install_kiro ;;
                5) install_vscode ;;
                6) install_codebuddy ;;
                7) install_openclaw ;;
                8) install_antigravity ;;
                9) install_opencode ;;
                0) install_all ;;
                *) echo "  跳过无效选项：$choice" ;;
            esac
        done
    fi
fi

echo ""
if [ "$LANG_CODE" = "zh" ]; then
    echo -e "  ${CYAN}(^・ω・^)${NC} 安装好了。别怕，有我在。"
else
    echo -e "  ${CYAN}(^・ω・^)${NC} Installed. Don't worry, I got you."
fi
echo ""
