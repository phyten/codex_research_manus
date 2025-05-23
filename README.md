# Codex Research Manus

このリポジトリは、OpenAI Codex の活用方法をまとめた書籍「Codex Research Manus」の原稿を管理するためのものです。各章は Markdown 形式で `chapters/` に保存されており、Pandoc を用いて技術書らしい美しい PDF を生成します。

## 特徴

### 📚 技術書らしい美しいレイアウト
- **A4サイズ**での出力、適切な余白設定
- **TeXらしいLibertinusフォント**を採用（英文部分）
- **日本語用Noto CJKフォント**で美しい日本語表示
- **ページ番号とヘッダー**による読みやすいナビゲーション
- **章・節の番号付け**で構造化された文書

### 💻 コードブロックの強化
- **シンタックスハイライト**による見やすいコード表示
- **言語名の自動表示**でコードの種類が一目瞭然
- **枠線とタイトル付きボックス**でコードブロックを明確に区別
- **JetBrains Monoフォント**でプログラミング文字の視認性向上
- **英語の文字はみ出し対策**で長いコードも美しく表示

### 🎨 プロフェッショナルなデザイン
- マイクロタイポグラフィによる美しい文字組み
- 適切な行間と文字間隔
- 技術書らしい色使いと構成
- ハイパーリンクの適切な色設定

## ディレクトリ構成

- `chapters/` - 各章の Markdown ファイル
- `pandoc/` - PDF 生成に利用する Pandoc 設定ファイル
  - `latex.yaml` - Pandoc のメイン設定
  - `header.tex` - LaTeX ヘッダー（フォント、レイアウト、コードブロック設定）
  - `codeblock-filter.lua` - コードブロック処理用 Lua フィルター
- `.github/workflows/` - GitHub Actions 用ワークフロー

## 章一覧

以下のファイルが章として含まれています（ファイル名の昇順で結合されます）。

1. `00_document_structure.md` - ドキュメント構成
2. `01_introduction.md` - はじめに
3. `02_basic_features.md` - Codex の基本機能
4. `03_ruby.md` - Ruby 言語での Codex 活用
5. `04_typescript.md` - TypeScript 言語での Codex 活用
6. `05_go.md` - Go 言語での Codex 活用
7. `06_docker.md` - Docker を使ったリポジトリでの活用
8. `07_ci_cd.md` - CI/CD との連携
9. `08_best_practices.md` - 導入と運用のベストプラクティス
10. `09_future.md` - 今後の展望
11. `10_references.md` - 参考文献

## PDF の生成方法

GitHub Actions の `Build Book PDF` ワークフロー（`.github/workflows/build_pdf.yml`）を利用して、Markdown を結合し技術書らしい美しい PDF に変換します。タグ `v*` の付いた push もしくは手動実行により、ワークフローが起動します。生成された PDF は成果物としてアップロードされ、リリースに添付されます。

### 使用フォント
- **英文**: Libertinus Serif（数学的な美しさを持つフォント）
- **日本語**: Noto Serif CJK JP（Google開発の高品質フォント）
- **コード**: JetBrains Mono（プログラマー向けに最適化されたフォント）

### コードブロックのサポート言語
JavaScript, TypeScript, Python, Ruby, Go, Rust, Java, C, C++, C#, PHP, SQL, HTML, CSS, JSON, YAML, Bash, Docker など、主要なプログラミング言語をサポート。

## ローカル環境での生成

ローカル環境で生成する場合は、以下の要件を満たす必要があります：

### 必要なソフトウェア
- Pandoc（2.0以降推奨）
- XeLaTeX（TeXLive 2020以降推奨）
- 必要なフォント：
  - Libertinus Serif/Sans
  - JetBrains Mono
  - Noto CJK fonts

### 生成コマンド
```bash
mkdir -p build
ls chapters/*.md | sort | xargs cat > build/book.md
pandoc build/book.md --defaults pandoc/latex.yaml -o build/book.pdf
```

## 貢献方法

Issue や Pull Request を通じてのフィードバックを歓迎します。PDF ビルド用のワークフローを利用することで、誰でも原稿の更新内容を確認できます。

### 執筆ガイドライン
- Markdownの標準的な記法を使用
- コードブロックには必ず言語名を指定（例：```javascript）
- 長い行はできるだけ改行を入れる
- 日本語と英語の間に適切なスペースを入れる

