# xiaobai Windows 一键安装脚本
# 小白编程：让小白爱上编程！ (=^・ω・^=)
#
# 用法：
#   irm https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.ps1 | iex
#   irm https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.ps1 | iex -platform cursor
#
# 指定平台：
#   $env:XIAOBAI_PLATFORM="claude"; irm https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.ps1 | iex
#
# 卸载：
#   $env:XIAOBAI_UNINSTALL="1"; irm https://raw.githubusercontent.com/noya21th/xiaobai/main/scripts/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "noya21th/xiaobai"
$Branch = "main"
$ZipUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"

# ─── 语言检测 ───

function Get-SystemLang {
    $culture = (Get-Culture).Name
    if ($culture -like "zh*") { return "zh" }
    return "en"
}

$LangCode = Get-SystemLang

if ($LangCode -eq "zh") {
    $SkillDir = "xiaobai"
    Write-Host ""
    Write-Host "  (=^・ω・^=)  xiaobai 安装工具" -ForegroundColor Cyan
    Write-Host "  小白编程：让小白爱上编程！" -ForegroundColor DarkGray
    Write-Host ""
} else {
    $SkillDir = "xiaobai-en"
    Write-Host ""
    Write-Host "  (=^・ω・^=)  xiaobai installer" -ForegroundColor Cyan
    Write-Host "  Xiaobai Coding: Make beginners fall in love with coding!" -ForegroundColor DarkGray
    Write-Host ""
}

# ─── 下载并解压 ───

function Download-And-Extract {
    $TmpDir = Join-Path $env:TEMP "xiaobai-install-$(Get-Random)"
    New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null
    $ZipPath = Join-Path $TmpDir "xiaobai.zip"
    $ExtractPath = Join-Path $TmpDir "extracted"

    if ($LangCode -eq "zh") {
        Write-Host "  正在下载..." -ForegroundColor DarkGray
    } else {
        Write-Host "  Downloading..." -ForegroundColor DarkGray
    }

    try {
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
    } catch {
        Write-Host "  下载失败，请检查网络连接" -ForegroundColor Red
        exit 1
    }

    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force

    $script:SrcDir = Join-Path $ExtractPath "xiaobai-$Branch"
    $script:TmpDir = $TmpDir

    if ($LangCode -eq "zh") {
        Write-Host "  下载完成" -ForegroundColor Green
    } else {
        Write-Host "  Download complete" -ForegroundColor Green
    }
}

# ─── 各平台安装函数 ───

function Install-Claude {
    $TargetDir = Join-Path $env:USERPROFILE ".claude\skills\xiaobai"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "skills\$SkillDir\SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
    Write-Host "  ✓ Claude Code → $TargetDir" -ForegroundColor Green
    if ($LangCode -eq "zh") {
        Write-Host "    新开对话后输入 /xiaobai 即可使用" -ForegroundColor DarkGray
    } else {
        Write-Host "    Start a new conversation and type /xiaobai to use" -ForegroundColor DarkGray
    }
}

function Install-Cursor {
    $TargetDir = Join-Path (Get-Location) ".cursor\rules"
    if (-not (Test-Path (Join-Path (Get-Location) ".cursor"))) {
        $TargetDir = Join-Path $env:USERPROFILE ".cursor\rules"
    }
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "cursor\rules\xiaobai.mdc") (Join-Path $TargetDir "xiaobai.mdc") -Force
    Write-Host "  ✓ Cursor → $TargetDir\xiaobai.mdc" -ForegroundColor Green
    if ($LangCode -eq "zh") {
        Write-Host "    重启 Cursor 后自动生效" -ForegroundColor DarkGray
    } else {
        Write-Host "    Restart Cursor to activate" -ForegroundColor DarkGray
    }
}

function Install-VSCode {
    $TargetDir = Join-Path (Get-Location) ".github"
    if (-not (Test-Path (Join-Path (Get-Location) ".github"))) {
        $TargetDir = Join-Path $env:USERPROFILE ".github"
    }
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "vscode\copilot-instructions.md") (Join-Path $TargetDir "copilot-instructions.md") -Force
    Write-Host "  ✓ VS Code (Copilot) → $TargetDir\copilot-instructions.md" -ForegroundColor Green
    if ($LangCode -eq "zh") {
        Write-Host "    记得在设置里开启：github.copilot.chat.codeGeneration.useInstructionFiles: true" -ForegroundColor Yellow
    } else {
        Write-Host "    Enable in settings: github.copilot.chat.codeGeneration.useInstructionFiles: true" -ForegroundColor Yellow
    }
}

function Install-Codex {
    $TargetDir = Join-Path (Get-Location) ".codex\xiaobai"
    if (-not (Test-Path (Join-Path (Get-Location) ".codex"))) {
        $TargetDir = Join-Path $env:USERPROFILE ".codex\xiaobai"
    }
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "codex\xiaobai\SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
    Write-Host "  ✓ Codex CLI → $TargetDir\SKILL.md" -ForegroundColor Green
}

function Install-Kiro {
    $TargetDir = Join-Path (Get-Location) ".kiro\steering"
    if (-not (Test-Path (Join-Path (Get-Location) ".kiro"))) {
        $TargetDir = Join-Path $env:USERPROFILE ".kiro\steering"
    }
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "kiro\steering\xiaobai.md") (Join-Path $TargetDir "xiaobai.md") -Force
    Write-Host "  ✓ Kiro → $TargetDir\xiaobai.md" -ForegroundColor Green
}

function Install-CodeBuddy {
    $TargetDir = Join-Path (Get-Location) ".codebuddy"
    if (-not (Test-Path (Join-Path (Get-Location) ".codebuddy"))) {
        $TargetDir = Join-Path $env:USERPROFILE ".codebuddy"
    }
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "codebuddy\xiaobai.md") (Join-Path $TargetDir "xiaobai.md") -Force
    Write-Host "  ✓ CodeBuddy → $TargetDir\xiaobai.md" -ForegroundColor Green
}

function Install-OpenClaw {
    $TargetDir = Join-Path $env:USERPROFILE ".openclaw\skills\xiaobai"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "skills\$SkillDir\SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
    Write-Host "  ✓ OpenClaw → $TargetDir" -ForegroundColor Green
}

function Install-Antigravity {
    $TargetDir = Join-Path $env:USERPROFILE ".antigravity\skills\xiaobai"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "skills\$SkillDir\SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
    Write-Host "  ✓ Antigravity → $TargetDir" -ForegroundColor Green
}

function Install-OpenCode {
    $TargetDir = Join-Path $env:USERPROFILE ".opencode\skills\xiaobai"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Copy-Item (Join-Path $script:SrcDir "skills\$SkillDir\SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
    Write-Host "  ✓ OpenCode → $TargetDir" -ForegroundColor Green
}

function Install-All {
    if ($LangCode -eq "zh") {
        Write-Host "  安装到所有平台" -ForegroundColor Cyan
    } else {
        Write-Host "  Installing to all platforms" -ForegroundColor Cyan
    }
    Write-Host ""
    Install-Claude
    Install-Cursor
    Install-VSCode
    Install-Codex
    Install-Kiro
    Install-CodeBuddy
    Install-OpenClaw
    Install-Antigravity
    Install-OpenCode
}

# ─── 平台检测 ───

function Detect-Platform {
    $found = @()
    if (Get-Command claude -ErrorAction SilentlyContinue) { $found += "claude" }
    if ((Test-Path ".cursor") -or (Test-Path (Join-Path $env:USERPROFILE ".cursor"))) { $found += "cursor" }
    if ((Test-Path ".vscode") -or (Test-Path (Join-Path $env:USERPROFILE ".vscode"))) { $found += "vscode" }
    if (Get-Command codex -ErrorAction SilentlyContinue) { $found += "codex" }
    if ((Test-Path ".kiro") -or (Test-Path (Join-Path $env:USERPROFILE ".kiro"))) { $found += "kiro" }
    if ((Test-Path ".codebuddy") -or (Test-Path (Join-Path $env:USERPROFILE ".codebuddy"))) { $found += "codebuddy" }
    return $found
}

# ─── 卸载 ───

function Uninstall-Xiaobai {
    if ($LangCode -eq "zh") {
        Write-Host "  正在卸载 xiaobai..." -ForegroundColor Yellow
    } else {
        Write-Host "  Uninstalling xiaobai..." -ForegroundColor Yellow
    }
    Write-Host ""

    $removed = 0
    $paths = @(
        (Join-Path $env:USERPROFILE ".claude\skills\xiaobai"),
        (Join-Path $env:USERPROFILE ".claude\skills\xiaobai-en"),
        ".cursor\rules\xiaobai.mdc",
        (Join-Path $env:USERPROFILE ".cursor\rules\xiaobai.mdc"),
        ".github\copilot-instructions.md",
        ".codex\xiaobai",
        (Join-Path $env:USERPROFILE ".codex\xiaobai"),
        ".kiro\steering\xiaobai.md",
        (Join-Path $env:USERPROFILE ".kiro\steering\xiaobai.md"),
        ".codebuddy\xiaobai.md",
        (Join-Path $env:USERPROFILE ".codebuddy\xiaobai.md"),
        (Join-Path $env:USERPROFILE ".openclaw\skills\xiaobai"),
        (Join-Path $env:USERPROFILE ".antigravity\skills\xiaobai"),
        (Join-Path $env:USERPROFILE ".opencode\skills\xiaobai")
    )

    foreach ($p in $paths) {
        if (Test-Path $p) {
            Remove-Item -Recurse -Force $p
            Write-Host "  ✓ 已删除 $p" -ForegroundColor Green
            $removed++
        }
    }

    if ($removed -eq 0) {
        if ($LangCode -eq "zh") {
            Write-Host "  没找到已安装的 xiaobai"
        } else {
            Write-Host "  No xiaobai installation found"
        }
    } else {
        Write-Host ""
        if ($LangCode -eq "zh") {
            Write-Host "  已卸载 $removed 个平台的 xiaobai"
        } else {
            Write-Host "  Uninstalled xiaobai from $removed platform(s)"
        }
    }

    Write-Host ""
    if ($LangCode -eq "zh") {
        Write-Host "  (=_ _=)..zZZ  下次再见" -ForegroundColor DarkGray
    } else {
        Write-Host "  (=_ _=)..zZZ  See you next time" -ForegroundColor DarkGray
    }
    Write-Host ""
    exit 0
}

# ─── 主流程 ───

$PlatformArg = $env:XIAOBAI_PLATFORM
$DoUninstall = $env:XIAOBAI_UNINSTALL

# 清除环境变量，避免影响后续运行
$env:XIAOBAI_PLATFORM = $null
$env:XIAOBAI_UNINSTALL = $null

# 卸载模式
if ($DoUninstall -eq "1") {
    Uninstall-Xiaobai
}

# 下载
Download-And-Extract

# 如果指定了平台
if ($PlatformArg) {
    switch ($PlatformArg) {
        "claude"       { Install-Claude }
        "cursor"       { Install-Cursor }
        "vscode"       { Install-VSCode }
        "codex"        { Install-Codex }
        "kiro"         { Install-Kiro }
        "codebuddy"    { Install-CodeBuddy }
        "openclaw"     { Install-OpenClaw }
        "antigravity"  { Install-Antigravity }
        "opencode"     { Install-OpenCode }
        "all"          { Install-All }
        default {
            Write-Host "  未知平台：$PlatformArg" -ForegroundColor Red
            Write-Host "  支持：claude, cursor, vscode, codex, kiro, codebuddy, openclaw, antigravity, opencode, all"
            exit 1
        }
    }
} else {
    # 自动检测
    $Detected = Detect-Platform

    if ($Detected.Count -gt 0) {
        if ($LangCode -eq "zh") {
            Write-Host "  检测到以下平台：" -ForegroundColor Cyan
        } else {
            Write-Host "  Detected platforms:" -ForegroundColor Cyan
        }
        Write-Host ""
        $platformNames = @{
            "claude" = "Claude Code"; "cursor" = "Cursor"; "vscode" = "VS Code"
            "codex" = "Codex CLI"; "kiro" = "Kiro"; "codebuddy" = "CodeBuddy"
        }
        foreach ($p in $Detected) {
            Write-Host "    · $($platformNames[$p])"
        }
        Write-Host ""

        foreach ($p in $Detected) {
            switch ($p) {
                "claude"    { Install-Claude }
                "cursor"    { Install-Cursor }
                "vscode"    { Install-VSCode }
                "codex"     { Install-Codex }
                "kiro"      { Install-Kiro }
                "codebuddy" { Install-CodeBuddy }
            }
        }
    } else {
        if ($LangCode -eq "zh") {
            Write-Host "  没检测到已知平台，你用的是哪个？" -ForegroundColor Yellow
        } else {
            Write-Host "  No known platform detected. Which one do you use?" -ForegroundColor Yellow
        }
        Write-Host ""
        Write-Host "   1) Claude Code          6) Tencent CodeBuddy"
        Write-Host "   2) OpenAI Codex CLI     7) OpenClaw"
        Write-Host "   3) Cursor               8) Google Antigravity"
        Write-Host "   4) Amazon Kiro          9) OpenCode"
        Write-Host "   5) VS Code (Copilot)    0) 全部安装"
        Write-Host ""
        $choices = (Read-Host "  输入数字（多选用空格隔开，如 1 3 5）") -split '\s+'

        foreach ($choice in $choices) {
            switch ($choice) {
                "1" { Install-Claude }
                "2" { Install-Codex }
                "3" { Install-Cursor }
                "4" { Install-Kiro }
                "5" { Install-VSCode }
                "6" { Install-CodeBuddy }
                "7" { Install-OpenClaw }
                "8" { Install-Antigravity }
                "9" { Install-OpenCode }
                "0" { Install-All }
                default { Write-Host "  跳过无效选项：$choice" }
            }
        }
    }
}

# 清理临时文件
if ($script:TmpDir -and (Test-Path $script:TmpDir)) {
    Remove-Item -Recurse -Force $script:TmpDir -ErrorAction SilentlyContinue
}

Write-Host ""
if ($LangCode -eq "zh") {
    Write-Host "  (^・ω・^) 安装好了。别怕，有我在。" -ForegroundColor Cyan
} else {
    Write-Host "  (^・ω・^) Installed. Don't worry, I got you." -ForegroundColor Cyan
}
Write-Host ""
