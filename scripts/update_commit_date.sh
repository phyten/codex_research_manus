#!/bin/bash

# 最新のコミット日付を取得（日本語形式）
COMMIT_DATE=$(git log -1 --format=%cd --date=format:'%Y年%m月%d日')

echo "Latest commit date: $COMMIT_DATE"

# pandoc/latex.yamlファイルの日付部分を更新
sed -i.bak "s|date: \"Written with manus, Gemini Pro 2.5, ChatGPT o3, and Claude 4\\\\\\\\.*\"|date: \"Written with manus, Gemini Pro 2.5, ChatGPT o3, and Claude 4\\\\\\\\$COMMIT_DATE\"|" pandoc/latex.yaml

echo "Updated pandoc/latex.yaml with commit date: $COMMIT_DATE" 