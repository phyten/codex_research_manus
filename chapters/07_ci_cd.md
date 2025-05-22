# 7. CI/CDとCodexの連携

継続的インテグレーション（CI）と継続的デリバリー/デプロイメント（CD）は、現代のソフトウェア開発において不可欠なプラクティスです。CodexをCI/CDパイプラインに統合することで、コードの品質向上、テストの自動化、デプロイメントの効率化をさらに推進できます。

## 7.1 GitHub Actionsとの統合

GitHub Actionsは、GitHubリポジトリ内で直接CI/CDワークフローを構築・実行できるプラットフォームです。Codex CLIはオープンソースであるため、GitHub Actionsのワークフローに容易に組み込むことができます。

### Codex CLIをワークフローで使用する

GitHub Actionsワークフロー内でCodex CLIを使用する基本的な手順は以下の通りです：

1. **Node.js環境のセットアップ**：Codex CLIはnpmパッケージとして提供されるため、Node.js環境が必要です。
2. **Codex CLIのインストール**：`npm install -g @openai/codex` コマンドでCLIをインストールします。
3. **OpenAI APIキーの設定**：Codex CLIを使用するにはOpenAI APIキーが必要です。GitHub SecretsにAPIキーを保存し、ワークフロー内で環境変数として設定します。
4. **Codexコマンドの実行**：`codex` コマンドに必要な指示を与えて実行します。

以下は、プルリクエスト時にCodex CLIを使用してコードレビューを自動化するワークフローの例です：

```yaml
# .github/workflows/codex-review.yml
name: Codex Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0 # 変更差分を取得するために全履歴を取得

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install Codex CLI
        run: npm install -g @openai/codex

      - name: Get changed files
        id: changed-files
        uses: tj-actions/changed-files@v35
        with:
          files: |
            src/**
            tests/**

      - name: Run Codex review on changed files
        if: steps.changed-files.outputs.any_changed == 'true'
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: |
          echo "Reviewing changed files:"
          echo "${{ steps.changed-files.outputs.all_changed_files }}"
          
          # 各変更ファイルに対してCodexレビューを実行
          for file in ${{ steps.changed-files.outputs.all_changed_files }}; do
            echo "--- Reviewing $file ---"
            codex "ファイル $file のコードレビューを実行し、改善点を提案してください。特に潜在的なバグ、パフォーマンスの問題、コーディング規約違反に注目してください。" >> codex_review_comments.txt
            echo "\n---\n" >> codex_review_comments.txt
          done
          
          echo "Codex review complete. Comments saved to codex_review_comments.txt"

      - name: Post review comments to PR
        if: steps.changed-files.outputs.any_changed == 'true'
        uses: actions/github-script@v6
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const fs = require('fs');
            const comments = fs.readFileSync('codex_review_comments.txt', 'utf8');
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## Codex Code Review Comments\n\n${comments}`
            });
```

このワークフローは、プルリクエストで変更されたファイルに対してCodexによるコードレビューを実行し、その結果をプルリクエストのコメントとして投稿します。

## 7.2 自動テストとコード品質チェック

Codexは、CI/CDパイプラインにおける自動テストとコード品質チェックの強化にも役立ちます。

### テストカバレッジの向上

テストカバレッジが低い箇所を特定し、Codexに不足しているテストケースの生成を依頼することができます。

```yaml
# .github/workflows/enhance-coverage.yml
name: Enhance Test Coverage

on:
  schedule:
    - cron: '0 0 * * 0' # 毎週日曜日の午前0時に実行
  workflow_dispatch:

jobs:
  enhance-coverage:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run tests and generate coverage report
        run: npm test -- --coverage --coverageReporters="json-summary"

      - name: Install Codex CLI
        run: npm install -g @openai/codex

      - name: Analyze coverage and generate missing tests
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: |
          # カバレッジレポートを解析してカバレッジが低いファイルを特定
          # (jqなどのツールを使用)
          low_coverage_files=$(jq -r '.[][] | select(.lines.pct < 80) | .path' coverage/coverage-summary.json)
          
          if [ -z "$low_coverage_files" ]; then
            echo "Test coverage is sufficient."
            exit 0
          fi
          
          echo "Files with low coverage:"
          echo "$low_coverage_files"
          
          # 各ファイルに対して不足しているテストを生成
          for file in $low_coverage_files; do
            echo "--- Generating tests for $file ---"
            # 対応するテストファイルパスを決定 (例: src/utils.ts -> tests/utils.test.ts)
            test_file=$(echo $file | sed 's|^src/|tests/|' | sed 's|\.ts$|.test.ts|')
            
            codex "ファイル $file のテストカバレッジを向上させるために、不足しているJestテストケースを $test_file に追加してください。既存のテストは変更しないでください。" >> generated_tests.ts
            echo "\n---\n" >> generated_tests.ts
          done
          
          echo "Generated tests saved to generated_tests.ts"

      - name: Create Pull Request with generated tests
        uses: peter-evans/create-pull-request@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "feat: Add generated tests to improve coverage"
          title: "Improve Test Coverage with Codex Generated Tests"
          body: |
            This PR adds test cases generated by OpenAI Codex to improve test coverage for files with less than 80% line coverage.
            
            **Generated Tests:**
            ```typescript
            ${{ env.GENERATED_TESTS }} 
            ```
            *Please review the generated tests carefully before merging.*
          branch: "codex/improve-coverage"
          base: "main"
          delete-branch: true
        env:
          GENERATED_TESTS: "$(cat generated_tests.ts)"
```

このワークフローは、定期的にテストカバレッジをチェックし、カバレッジが低いファイルに対してCodexにテストケースの生成を依頼し、その結果をプルリクエストとして作成します。

### コード品質チェックと自動修正

Codexを使用して、リンターや静的解析ツールの警告を自動的に修正することも可能です。

```yaml
# .github/workflows/auto-fix.yml
name: Auto Code Fix

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  auto-fix:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          ref: ${{ github.head_ref }} # PRブランチをチェックアウト

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies and linters
        run: |
          npm ci
          npm install eslint prettier --save-dev

      - name: Run linters and capture issues
        id: lint-issues
        run: |
          # ESLintを実行し、結果をファイルに保存
          npx eslint . --format json -o eslint-report.json || true
          # Prettierを実行し、整形が必要なファイルをリストアップ
          npx prettier --check . > prettier-check.txt || true
          
          # 問題があるかどうかを判断（簡易的なチェック）
          if [ -s eslint-report.json ] || grep -q -v '^All matched files use Prettier' prettier-check.txt; then
            echo "issues_found=true" >> $GITHUB_OUTPUT
          else
            echo "issues_found=false" >> $GITHUB_OUTPUT
          fi

      - name: Install Codex CLI
        if: steps.lint-issues.outputs.issues_found == 'true'
        run: npm install -g @openai/codex

      - name: Auto-fix linting issues with Codex
        if: steps.lint-issues.outputs.issues_found == 'true'
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: |
          echo "Attempting to auto-fix linting issues..."
          # ESLintレポートを解析し、問題のあるファイルとルールを取得
          # Prettierチェック結果から整形が必要なファイルを取得
          # (詳細な解析ロジックが必要)
          
          # 例：ESLintレポートから最初の問題を取得
          first_issue_file=$(jq -r '.[0].filePath' eslint-report.json)
          first_issue_message=$(jq -r '.[0].messages[0].message' eslint-report.json)
          first_issue_rule=$(jq -r '.[0].messages[0].ruleId' eslint-report.json)
          
          if [ -n "$first_issue_file" ]; then
            echo "Fixing issue in $first_issue_file: $first_issue_message (Rule: $first_issue_rule)"
            codex "ファイル $first_issue_file の ESLint ルール '$first_issue_rule' ($first_issue_message) に違反している箇所を修正してください。" --apply
          fi
          
          # 例：Prettierで整形が必要な最初のファイルを取得
          first_prettier_file=$(grep -v '^All matched files use Prettier' prettier-check.txt | head -n 1)
          if [ -n "$first_prettier_file" ]; then
            echo "Formatting file with Prettier: $first_prettier_file"
            codex "ファイル $first_prettier_file を Prettier のルールに従ってフォーマットしてください。" --apply
          fi
          
          # 実際には、すべての問題をループ処理するか、より高度な指示をCodexに与える

      - name: Commit and push fixes
        if: steps.lint-issues.outputs.issues_found == 'true'
        uses: stefanzweifel/git-auto-commit-action@v4
        with:
          commit_message: "chore: Apply automated code fixes by Codex"
          branch: ${{ github.head_ref }}
          commit_options: '--no-verify --signoff'
          file_pattern: 'src/**/*.ts tests/**/*.ts'
          push_options: '--force'
```

このワークフローは、プルリクエスト時にリンターを実行し、問題が検出された場合にCodexに自動修正を試みさせ、修正結果をプルリクエストブランチに直接コミットします。

**注意点：**
- Codexによる自動修正は、意図しない変更を引き起こす可能性があるため、慎重に導入し、修正結果を必ずレビューする必要があります。
- 大規模な修正や複雑なリファクタリングは、Codexに任せるよりも人間が介入する方が安全な場合があります。

## 7.3 デプロイメントの自動化

Codexは、デプロイメントスクリプトの生成や、デプロイメントプロセスのトラブルシューティングにも活用できます。

### デプロイメントスクリプトの生成

特定のクラウドプロバイダーやオーケストレーションツール向けのデプロイメントスクリプトをCodexに生成させることができます。

```
AWS CDK (TypeScript) を使用して、以下のリソースをデプロイするスタックを作成してください：
- Fargateサービス
- Application Load Balancer
- ECRリポジトリ
- VPCとサブネット
```

Codexは、指定された要件に基づいたAWS CDKのコードを生成します。

### デプロイメントエラーのトラブルシューティング

CI/CDパイプラインのデプロイメントステップでエラーが発生した場合、エラーログをCodexに提供し、原因分析と解決策の提案を依頼することができます。

```
以下のKubernetesデプロイメントエラーログを分析し、原因と解決策を教えてください。

Error: ImagePullBackOff
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  5m                 default-scheduler  Successfully assigned default/my-app-deployment-xxxx-yyyy to node-1
  Normal   Pulling    4m                 kubelet, node-1    Pulling image "my-registry/my-app:latest"
  Warning  Failed     3m                 kubelet, node-1    Failed to pull image "my-registry/my-app:latest": rpc error: code = Unknown desc = Error response from daemon: pull access denied for my-registry/my-app, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
  Warning  Failed     3m                 kubelet, node-1    Error: ErrImagePull
  Normal   BackOff    2m (x2 over 3m)    kubelet, node-1    Back-off pulling image "my-registry/my-app:latest"
  Warning  Failed     1m (x2 over 3m)    kubelet, node-1    Error: ImagePullBackOff
```

Codexは以下のような分析結果を提供します：

```
# Kubernetesデプロイメントエラー分析

## エラー概要

`ImagePullBackOff` エラーが発生しており、Kubernetesクラスターが指定されたDockerイメージ `my-registry/my-app:latest` をプルできていません。

## 主な原因

イベントログの以下のメッセージが原因を示唆しています：
```
Failed to pull image "my-registry/my-app:latest": rpc error: code = Unknown desc = Error response from daemon: pull access denied for my-registry/my-app, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
```
これは、以下のいずれかの理由でイメージのプルに失敗したことを意味します：
1. **認証エラー**: Kubernetesクラスターが `my-registry` にアクセスするための認証情報を持っていないか、認証情報が正しくない。
2. **リポジトリ/イメージが存在しない**: 指定されたリポジトリ `my-registry/my-app` またはタグ `latest` が存在しない。
3. **権限不足**: 認証は成功したが、指定されたリポジトリへのアクセス権限がない。

## 解決策

以下の点を確認・修正してください：

1. **イメージ名の確認**: デプロイメントマニフェスト（Deployment YAML）で指定されているイメージ名 (`my-registry/my-app:latest`) が正しいか確認してください。タイポがないか、リポジトリ名、イメージ名、タグが正確かを確認します。

2. **リポジトリの存在確認**: Dockerレジストリ (`my-registry`) に `my-app` というリポジトリと `latest` というタグが存在するか確認してください。

3. **認証情報の設定 (ImagePullSecrets)**: プライベートレジストリを使用している場合、Kubernetesクラスターがレジストリにアクセスするための認証情報が必要です。
   - `docker login` コマンドで使用する認証情報から Kubernetes Secret (`type: kubernetes.io/dockerconfigjson`) を作成します。
   - 作成したSecretを、DeploymentのPodテンプレート内の `spec.imagePullSecrets` フィールドで参照します。

   ```yaml
   # deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: my-app-deployment
   spec:
     template:
       spec:
         containers:
         - name: my-app
           image: my-registry/my-app:latest
         imagePullSecrets:
         - name: my-registry-secret # 作成したSecretの名前
   ```

4. **サービスアカウントへの紐付け**: Namespace内のデフォルトのサービスアカウントに `imagePullSecrets` を紐付けることもできます。これにより、そのNamespace内のすべてのPodが自動的にSecretを使用できるようになります。

5. **IAM/権限設定**: クラウドプロバイダーのコンテナレジストリ（例: AWS ECR, GCP GCR, Azure ACR）を使用している場合、Kubernetesノード（またはノードグループのIAMロール）にレジストリからイメージをプルする権限が付与されているか確認してください。

これらの手順を確認・実行することで、`ImagePullBackOff` エラーが解決するはずです。
```

## 7.4 実践的なワークフロー設計

CodexをCI/CDパイプラインに効果的に組み込むための実践的なワークフロー設計のポイントをいくつか紹介します。

### プルリクエスト中心のワークフロー

- **自動レビュー**: プルリクエスト作成時にCodexによる自動コードレビューを実行し、基本的な問題を早期に検出します。
- **テスト実行**: 変更されたコードに関連するテストを自動実行します。
- **プレビュー環境**: 必要に応じて、プルリクエストごとに一時的なプレビュー環境をデプロイし、動作確認を行います。

### mainブランチへのマージ後のワークフロー

- **統合テスト**: アプリケーション全体の統合テストを実行します。
- **ビルドとプッシュ**: Dockerイメージをビルドし、コンテナレジストリにプッシュします。
- **ステージング環境へのデプロイ**: 自動的にステージング環境へデプロイし、最終確認を行います。
- **本番環境へのデプロイ**: 手動承認または自動で本番環境へデプロイします。

### 定期的なメンテナンスワークフロー

- **依存関係の更新チェック**: 定期的に依存関係の脆弱性スキャンや更新チェックを行い、Codexに更新作業のプルリクエスト作成を依頼します。
- **テストカバレッジ向上**: 定期的にテストカバレッジを分析し、Codexに不足テストの生成を依頼します。
- **コードのリファクタリング提案**: 定期的にコードベース全体を分析し、Codexにリファクタリングや最適化の提案を依頼します。

### Codex利用の注意点

- **コスト管理**: Codex APIの利用にはコストがかかります。CI/CDパイプラインでの頻繁な利用はコスト増につながるため、実行頻度や対象範囲を適切に設定する必要があります。
- **実行時間**: Codexの処理には時間がかかる場合があります。CI/CDパイプラインの実行時間に影響を与えないように、非同期処理や必要なステップのみでの実行を検討します。
- **結果の検証**: Codexが生成したコードや提案は必ずしも完璧ではありません。自動修正や自動デプロイを行う場合は、その結果を検証する仕組みや、問題発生時のロールバック計画を用意することが重要です。

CodexをCI/CDパイプラインに戦略的に組み込むことで、開発プロセスの自動化と効率化を大幅に進めることができます。次章では、Codexの導入と運用におけるベストプラクティスについて解説します。
