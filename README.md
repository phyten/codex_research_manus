# Codex Research Manus

このリポジトリは、OpenAI Codex の活用方法をまとめた書籍「Codex Research Manus」の原稿を管理するためのものです。各章は Markdown 形式で `chapters/` に保存されており、Pandoc を用いて PDF を生成します。

## ディレクトリ構成

- `chapters/` - 各章の Markdown ファイル
- `pandoc/` - PDF 生成に利用する Pandoc 設定ファイル
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

GitHub Actions の `Build Book PDF` ワークフロー（`.github/workflows/build_pdf.yml`）を利用して、Markdown を結合し PDF に変換します。タグ `v*` の付いた push もしくは手動実行により、ワークフローが起動します。生成された PDF は成果物としてアップロードされ、リリースに添付されます。

ローカル環境で生成する場合は、Pandoc と LaTeX（xelatex）が必要です。以下は簡易的な例です。

```bash
mkdir -p build
ls chapters/*.md | sort | xargs cat > build/book.md
pandoc build/book.md --defaults pandoc/latex.yaml -o build/book.pdf
```

`pandoc/latex.yaml` では日本語フォントとして Noto 系フォントを指定しており、`pandoc/header.tex` で `xeCJK` を利用しています。

## 貢献方法

Issue や Pull Request を通じてのフィードバックを歓迎します。PDF ビルド用のワークフローを利用することで、誰でも原稿の更新内容を確認できます。

