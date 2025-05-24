# Codex Research Manus

このリポジトリは、OpenAI Codex の活用方法をまとめた書籍「Codex Research Manus」の原稿を管理するためのものです。各章は Markdown 形式で `chapters/` に保存されており、Pandoc を用いて技術書らしい美しい PDF を生成します。

## 特徴

### 📚 技術書らしい美しいレイアウト
- **A4サイズ**での出力、適切な余白設定
- **日本語組版に最適化**されたLuaLaTeX + ltjsarticleを採用
- **日本語用Noto CJK・HaranoAji フォント**で美しい日本語表示
- **ページ番号とヘッダー**による読みやすいナビゲーション
- **章・節の番号付け**で構造化された文書

### 💻 コードブロックの強化
- **シンタックスハイライト**による見やすいコード表示
- **言語名の自動表示**でコードの種類が一目瞭然
- **tcolorboxによる美しいボックス**でコードブロックを明確に区別
- **listings パッケージ**でプログラミング文字の視認性向上
- **長いコードも美しく表示**される改行対応

### 🎨 プロフェッショナルなデザイン
- マイクロタイポグラフィによる美しい文字組み
- 適切な行間と文字間隔
- 技術書らしい色使いと構成
- ハイパーリンクの適切な色設定

## ディレクトリ構成

- `chapters/` - 各章の Markdown ファイル
- `pandoc/` - PDF 生成に利用する Pandoc 設定ファイル
  - `latex.yaml` - Pandoc のメイン設定（LuaLaTeX + ltjsarticle）
  - `header.tex` - LaTeX ヘッダー（luatexja、tcolorbox、レイアウト設定）
  - `codeblock-filter.lua` - コードブロック処理用 Lua フィルター
- `Dockerfile` - PDF生成用のDocker環境定義
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
- **英文**: Latin Modern（LaTeX標準フォント）
- **日本語**: HaranoAji Mincho/Gothic（Adobe-Japan1 対応の高品質フォント）
- **コード**: listings パッケージの等幅フォント

### コードブロックのサポート言語
JavaScript, TypeScript, Python, Ruby, Go, Rust, Java, C, C++, C#, PHP, SQL, HTML, CSS, JSON, YAML, Bash, Docker, Markdown など、主要なプログラミング言語をサポート。

## ローカル環境での生成

ローカル環境でPDFを生成する方法は2つあります。

### 方法1: Docker を使用（推奨）

**必要なソフトウェア**: Docker のみ

# Dockerイメージをビルド
docker build -t texlive-pandoc .

# Markdownファイルを結合
mkdir -p build
ls chapters/*.md | sort | xargs cat > build/book.md

# PDF生成
docker run --rm -v "$(pwd):/workspace" texlive-pandoc \
  pandoc build/book.md --defaults pandoc/latex.yaml \
  --lua-filter pandoc/codeblock-filter.lua -o build/book.pdf

**メリット**: 
- 環境構築が簡単
- GitHub Actionsと同じ環境で生成可能
- 日本語フォントが自動で含まれる

### 方法2: ローカルインストール

**必要なソフトウェア**:
- Pandoc（3.0以降推奨）
- LuaLaTeX（TeXLive 2022以降推奨）
- 必要なパッケージ：
  - luatexja
  - tcolorbox
  - listings
  - その他（header.texで指定されたパッケージ）
- 日本語フォント（Noto CJK、HaranoAji など）

```bash
# Markdownファイルを結合
mkdir -p build
ls chapters/*.md | sort | xargs cat > build/book.md

# PDF生成
pandoc build/book.md --defaults pandoc/latex.yaml \
  --lua-filter pandoc/codeblock-filter.lua -o build/book.pdf
```

### 生成されるファイル
- `build/book.pdf` - 完成した書籍PDF（通常1MB以上のサイズ）

## 貢献方法

Issue や Pull Request を通じてのフィードバックを歓迎します。PDF ビルド用のワークフローを利用することで、誰でも原稿の更新内容を確認できます。

### 執筆ガイドライン
- Markdownの標準的な記法を使用
- コードブロックには必ず言語名を指定（例：```javascript）
- 長い行はできるだけ改行を入れる
- 日本語と英語の間に適切なスペースを入れる

