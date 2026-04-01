#!/usr/bin/env bash
# 此令若未居首行，Bash 大人将不予受理。

export LC_ALL=C

# ===== 🎨 颜色定义 =====
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
MAGENTA="\033[35m"
RED="\033[31m"

echo -e "${DIM}⚠️ 启禀系统，奉皇上敕令，此执行令交由 Bash 大人审阅执行。${RESET}"

# ===== 🌟 启动横幅（轻设计感）=====
clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}        📦 哈希生成 + 校验工具${RESET}"
echo -e "${DIM}        by 棉花 · 优雅但不复杂${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo

success=0
fail=0
missing=0
generated=0
mode=""

# ===== 🚀 输入引导 =====
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}🫵🏻 操作指引：${RESET}"
    echo -e "   🫴🏻 请将待呈卷宗${DIM}${CYAN}悉数${RESET} ${BOLD}${GREEN}“拖入🫳🏻”${RESET} 此窗口，然后按下 ${BOLD}${CYAN}回车⏎${RESET}"
    echo -e "   ${DIM} （皇上可开始查验）${RESET}"
    echo

    # 微动效（假装在等待）
    echo -ne "${DIM}等待输入中"
    for i in 1 2 3; do
        echo -ne "."
        sleep 0.5
    done
    echo -e "${RESET}"
    echo

    read -r INPUT
    eval "set -- $INPUT"

    # 🧼 清屏 + 重绘界面
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}        📦 哈希生成 + 校验工具${RESET}"
    echo -e "${DIM}        by 棉花 · 优雅但不复杂${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
fi

first="$1"

if [[ "$first" == *.sha256 ]]; then
    mode="verify"
    echo -e "${DIM}📜 卷宗已呈，候命查验……${RESET}"
    echo -e "${MAGENTA}===== 🔍 封签查验 =====${RESET}"
else
    mode="generate"
    echo -e "${DIM}📜 卷宗已呈，候命封签……${RESET}"
    echo -e "${CYAN}===== 📦 封签制备 =====${RESET}"
fi

echo

# 自动选择哈希工具
if command -v shasum >/dev/null 2>&1; then
    HASH_CMD="shasum -a 256"
else
    HASH_CMD="sha256sum"
fi

for FILE in "$@"; do

    NAME=$(basename "$FILE")
    BASE=$(dirname "$FILE")

    if [[ "$FILE" == *.sha256 ]]; then
        echo -e "${BOLD}【查验封签】\"$NAME\"${RESET}"

        while IFS= read -r LINE || [ -n "$LINE" ]; do

            EXPECTED=$(echo "$LINE" | awk '{print $1}')
            REST=$(echo "$LINE" | cut -d' ' -f2-)

            NAME2="$REST"
            NAME2="${NAME2# }"

            TARGET="$BASE/$NAME2"

            if [ ! -f "$TARGET" ]; then
                echo -e "${YELLOW}⚠ 卷宗缺失：\"$NAME2\"${RESET}"
                ((missing++))
            else
                ACTUAL=$($HASH_CMD -- "$TARGET" | awk '{print $1}')

                if [[ "$ACTUAL" == "$EXPECTED" ]]; then
                    echo -e "${GREEN}✔ 卷宗无误：\"$NAME2\"${RESET}"
                    ((success++))
                else
                    echo -e "${RED}✖ 卷宗异常：\"$NAME2\"${RESET}"
                    echo -e "    ${DIM}期望值：$EXPECTED${RESET}"
                    echo -e "    ${DIM}实际值：$ACTUAL${RESET}"
                    ((fail++))
                fi
            fi

        done < "$FILE"

        echo

    else
        echo -e "${BOLD}【正封签】\"$NAME\"${RESET}"

        HASH=$($HASH_CMD "$FILE" | awk '{print $1}')

        if [ -z "$HASH" ]; then
            echo -e "${RED}⚠ 无法读取卷宗：\"$NAME\"${RESET}"
            echo
            ((fail++))
        else
            echo "$HASH  $NAME" > "$FILE.sha256"
            echo -e "${GREEN}✔ 已封签：\"$NAME.sha256\"${RESET}"
            echo
            ((generated++))
        fi
    fi

done

echo -e "${CYAN}===== 🔚 卷宗处理完毕 =====${RESET}"
echo

if [ "$mode" = "generate" ]; then
    echo -e "📜 本批 ${GREEN}$generated${RESET} 份封签已制备完毕！微臣告退～"
    echo -e "${DIM} （皇上请过目）${RESET}"
    if [ $fail -gt 0 ]; then
        echo -e "${YELLOW}⚠ 其中有 $fail 份封签制备失败${RESET}"
    fi
else
    echo "-------- 封签查验结果 --------"
    echo -e "${GREEN}✔ 卷宗无误：$success${RESET}"
    echo -e "${RED}✖ 卷宗异常：$fail${RESET}"
    echo -e "${YELLOW}⚠ 卷宗缺失：$missing${RESET}"
    echo "--------------------------"
    echo

    if [ $fail -eq 0 ] && [ $missing -eq 0 ]; then
        echo -e "${GREEN}📜 卷宗已尽数查验，无一差误。臣告退～${RESET}"
        echo -e "${DIM} （皇上安心便是）${RESET}"
    else
        echo -e "${YELLOW}🤨 于卷宗中发现异常，请准予逐项复核。${RESET}"
        echo -e "${DIM} （皇上请留意）${RESET}"
    fi
fi

echo
read -n 1 -s -r -p "Press any key to continue..."
echo