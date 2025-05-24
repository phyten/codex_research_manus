#!/bin/bash

# buildディレクトリを作成
mkdir -p build

# 結合するファイルをクリア
> build/book.md

# chaptersディレクトリのMarkdownファイルを順番に処理
for file in $(ls chapters/*.md | sort); do
    echo "Processing: $file"
    
    # ファイルの内容を追加
    cat "$file" >> build/book.md
    
    # ファイルの最後に改行を追加（ファイル間の区切りを確保）
    echo "" >> build/book.md
    echo "" >> build/book.md
done

echo "Combined Markdown file created: build/book.md" 