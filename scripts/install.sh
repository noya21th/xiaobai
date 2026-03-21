#!/usr/bin/env bash
# xiaobai installer — 自动检测平台并安装
# 让天下没有不会编程的小白 (=^・ω・^=)

set -e

REPO="noya21th/xiaobai"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "  (=^・ω・^=)  xiaobai installer"
echo "  让天下没有不会编程的小白"
echo ""

detect_platform() {
    if command -v claude &> /dev/null; then
        echo "claude"
    elif [ -d ".cursor" ] || [ -d "$(pwd)/.cursor" ]; then
        echo "cursor"
    elif [ -d ".vscode" ] || [ -d "$(pwd)/.vscode" ]; then
        echo "vscode"
    elif [ -d ".codex" ]; then
        echo "codex"
    elif [ -d ".kiro" ]; then
        echo "kiro"
    elif [ -d ".codebuddy" ]; then
        echo "codebuddy"
    else
        echo "unknown"
    fi
}

install_claude() {
    echo -e "${GREEN}检测到 Claude Code${NC}"
    claude install-skill "github:$REPO/skills/xiaobai"
    echo -e "${GREEN}安装完成！输入 /xiaobai 开始使用${NC}"
}

install_cursor() {
    echo -e "${GREEN}检测到 Cursor${NC}"
    mkdir -p .cursor/rules
    curl -sL "$BASE_URL/cursor/rules/xiaobai.mdc" -o .cursor/rules/xiaobai.mdc
    echo -e "${GREEN}安装完成！重启 Cursor 即可使用${NC}"
}

install_vscode() {
    echo -e "${GREEN}检测到 VS Code${NC}"
    mkdir -p .github
    curl -sL "$BASE_URL/vscode/copilot-instructions.md" -o .github/copilot-instructions.md
    echo -e "${YELLOW}记得在设置里开启：github.copilot.chat.codeGeneration.useInstructionFiles${NC}"
    echo -e "${GREEN}安装完成！${NC}"
}

install_codex() {
    echo -e "${GREEN}检测到 Codex CLI${NC}"
    mkdir -p .codex/xiaobai
    curl -sL "$BASE_URL/codex/xiaobai/SKILL.md" -o .codex/xiaobai/SKILL.md
    echo -e "${GREEN}安装完成！${NC}"
}

install_kiro() {
    echo -e "${GREEN}检测到 Kiro${NC}"
    mkdir -p .kiro/steering
    curl -sL "$BASE_URL/kiro/steering/xiaobai.md" -o .kiro/steering/xiaobai.md
    echo -e "${GREEN}安装完成！${NC}"
}

install_codebuddy() {
    echo -e "${GREEN}检测到 CodeBuddy${NC}"
    mkdir -p .codebuddy
    curl -sL "$BASE_URL/codebuddy/xiaobai.md" -o .codebuddy/xiaobai.md
    echo -e "${GREEN}安装完成！${NC}"
}

PLATFORM=$(detect_platform)

case $PLATFORM in
    claude)     install_claude ;;
    cursor)     install_cursor ;;
    vscode)     install_vscode ;;
    codex)      install_codex ;;
    kiro)       install_kiro ;;
    codebuddy)  install_codebuddy ;;
    *)
        echo -e "${YELLOW}没检测到已知平台，你用的是哪个？${NC}"
        echo ""
        echo "  1) Claude Code"
        echo "  2) Cursor"
        echo "  3) VS Code (GitHub Copilot)"
        echo "  4) OpenAI Codex CLI"
        echo "  5) Amazon Kiro"
        echo "  6) Tencent CodeBuddy"
        echo ""
        read -p "输入数字: " choice
        case $choice in
            1) install_claude ;;
            2) install_cursor ;;
            3) install_vscode ;;
            4) install_codex ;;
            5) install_kiro ;;
            6) install_codebuddy ;;
            *) echo "无效选择" && exit 1 ;;
        esac
        ;;
esac

echo ""
echo "  (^・ω・^) 安装好了。别怕，有我在。"
echo ""
