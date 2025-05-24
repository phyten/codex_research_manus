# Dockerを使ったリポジトリでのCodex活用

## Dockerリポジトリの基本構成

Dockerを使用したプロジェクトでは、開発環境、テスト環境、本番環境の一貫性を確保するために、コンテナ化されたアプリケーションとその依存関係が定義されています。Codexを活用することで、Dockerを使ったリポジトリの管理と開発フローを効率化できます。

### 典型的なDockerリポジトリの構造

Dockerを使用したプロジェクトの典型的なディレクトリ構造は以下のようになります：

```
project-root/
├── .github/
│   └── workflows/        # GitHub Actions ワークフロー定義
├── src/                  # アプリケーションのソースコード
├── tests/                # テストコード
├── docker/               # Docker関連ファイル
│   ├── development/      # 開発環境用の設定
│   ├── test/             # テスト環境用の設定
│   └── production/       # 本番環境用の設定
├── docker-compose.yml    # 開発環境用のDocker Compose設定
├── docker-compose.test.yml # テスト環境用のDocker Compose設定
├── Dockerfile            # メインのDockerfile
├── .dockerignore         # Dockerビルド時に無視するファイル
├── AGENTS.md             # Codex用の設定ファイル
└── README.md             # プロジェクトの説明
```

### AGENTS.mdファイルの設定

Dockerを使用したプロジェクトでCodexを効果的に活用するためには、AGENTS.mdファイルに適切な設定を記述することが重要です。以下は、Dockerプロジェクト用のAGENTS.mdファイルの例です：

```markdown
# Agent Guidelines for Docker Project

## Project Overview
このプロジェクトはDockerを使用してコンテナ化されたアプリケーションです。
開発、テスト、本番の各環境に対応するDockerfile設定があります。

## Docker Configuration
- Dockerfileはマルチステージビルドを使用しています
- 開発環境はdocker-compose.ymlで定義されています
- テスト環境はdocker-compose.test.ymlで定義されています
- 本番環境はKubernetesマニフェストで定義されています

## Development Workflow
- 開発環境の起動: `docker-compose up -d`
- テストの実行: `docker-compose -f docker-compose.test.yml up --build`
- コンテナ内でのコマンド実行: `docker-compose exec app <command>`

## Testing
- テストはコンテナ内で実行されます
- CI/CDパイプラインでは専用のテストコンテナが使用されます
- テスト実行コマンド: `docker-compose -f docker-compose.test.yml run --rm app npm test`

## CI/CD Integration
- GitHub Actionsを使用しています
- テスト、ビルド、デプロイの各ステップがあります
- イメージはGitHub Container Registryにプッシュされます

## Best Practices
- 軽量なベースイメージを使用してください
- マルチステージビルドで最終イメージサイズを最小化してください
- 環境変数を適切に使用してください
- シークレット情報はDockerfileに含めないでください
```

### Dockerリポジトリに対するCodexの初期設定

Codexを使用してDockerリポジトリを操作する際の初期設定手順は以下の通りです：

1. **GitHubリポジトリの準備**：
   Dockerを使用したプロジェクトのGitHubリポジトリを用意し、Codexとの連携を設定します。

2. **Dockerコンテナ内での実行環境の設定**：
   Codexがコンテナ内でコードを実行できるように、適切な設定を行います。

3. **セットアップスクリプトの準備**：
   Codexが自動的に実行するセットアップスクリプトを用意します。

   ```bash
   #!/bin/bash
   # setup.sh
   docker-compose build
   docker-compose up -d
   ```

4. **テスト実行スクリプトの準備**：
   Codexがテストを実行するためのスクリプトを用意します。

   ```bash
   #!/bin/bash
   # run-tests.sh
   docker-compose -f docker-compose.test.yml up --build --exit-code-from app
   ```

## Codexによるテスト自動化

Dockerを使用したリポジトリでは、Codexを活用してテストの自動化を効率的に行うことができます。

### コンテナ内でのテスト実行

Dockerコンテナ内でテストを実行するための設定例を示します：

```yaml
# docker-compose.test.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: docker/test/Dockerfile
    volumes:
      - ./src:/app/src
      - ./tests:/app/tests
    environment:
      - NODE_ENV=test
      - DATABASE_URL=postgres://postgres:postgres@db:5432/testdb
    command: npm test
    depends_on:
      - db

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=testdb
    volumes:
      - postgres-test-data:/var/lib/postgresql/data

volumes:
  postgres-test-data:
```

```dockerfile
# docker/test/Dockerfile
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

CMD ["npm", "test"]
```

### Codexによるテストケース生成

Codexを使用して、Dockerコンテナ内で実行するテストケースを生成する例を示します：

```
TypeScriptとJestを使用して、以下のユーザーサービスのテストケースを生成してください。
テストはDockerコンテナ内で実行されます。
モックを使用してデータベース依存を分離してください。
```

```typescript
// src/services/userService.ts
import { User, UserRepository } from '../repositories/userRepository';

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async createUser(name: string, email: string, age: number): Promise<User> {
    if (!name || !email) {
      throw new Error('Name and email are required');
    }

    if (age < 18) {
      throw new Error('User must be at least 18 years old');
    }

    const existingUser = await this.userRepository.findByEmail(email);
    if (existingUser) {
      throw new Error('User with this email already exists');
    }

    return this.userRepository.create({ name, email, age });
  }

  async getUserById(id: string): Promise<User | null> {
    return this.userRepository.findById(id);
  }

  async getAllUsers(): Promise<User[]> {
    return this.userRepository.findAll();
  }

  async updateUser(id: string, data: Partial<User>): Promise<User | null> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      return null;
    }

    return this.userRepository.update(id, data);
  }

  async deleteUser(id: string): Promise<boolean> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      return false;
    }

    return this.userRepository.delete(id);
  }
}
```

Codexは以下のようなテストコードを生成します：

```typescript
// tests/services/userService.test.ts
import { UserService } from '../../src/services/userService';
import { User, UserRepository } from '../../src/repositories/userRepository';

// モックユーザーリポジトリの作成
const mockUserRepository: jest.Mocked<UserRepository> = {
  create: jest.fn(),
  findById: jest.fn(),
  findByEmail: jest.fn(),
  findAll: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    // 各テスト前にモックをリセット
    jest.clearAllMocks();
    userService = new UserService(mockUserRepository);
  });

  describe('createUser', () => {
    it('should create a user when all inputs are valid', async () => {
      // Arrange
      const userData = { name: 'John Doe', email: 'john@example.com', age: 25 };
      const expectedUser: User = { id: '1', ...userData };
      
      mockUserRepository.findByEmail.mockResolvedValue(null);
      mockUserRepository.create.mockResolvedValue(expectedUser);

      // Act
      const result = await userService.createUser(userData.name, userData.email, userData.age);

      // Assert
      expect(mockUserRepository.findByEmail).toHaveBeenCalledWith(userData.email);
      expect(mockUserRepository.create).toHaveBeenCalledWith(userData);
      expect(result).toEqual(expectedUser);
    });

    it('should throw an error when name is missing', async () => {
      // Act & Assert
      await expect(userService.createUser('', 'john@example.com', 25))
        .rejects.toThrow('Name and email are required');
    });

    it('should throw an error when email is missing', async () => {
      // Act & Assert
      await expect(userService.createUser('John Doe', '', 25))
        .rejects.toThrow('Name and email are required');
    });

    it('should throw an error when age is less than 18', async () => {
      // Act & Assert
      await expect(userService.createUser('John Doe', 'john@example.com', 17))
        .rejects.toThrow('User must be at least 18 years old');
    });

    it('should throw an error when user with email already exists', async () => {
      // Arrange
      const existingUser: User = { 
        id: '1', 
        name: 'Existing User', 
        email: 'john@example.com', 
        age: 30 
      };
      
      mockUserRepository.findByEmail.mockResolvedValue(existingUser);

      // Act & Assert
      await expect(userService.createUser('John Doe', 'john@example.com', 25))
        .rejects.toThrow('User with this email already exists');
    });
  });

  describe('getUserById', () => {
    it('should return a user when user exists', async () => {
      // Arrange
      const userId = '1';
      const expectedUser: User = { 
        id: userId, 
        name: 'John Doe', 
        email: 'john@example.com', 
        age: 25 
      };
      
      mockUserRepository.findById.mockResolvedValue(expectedUser);

      // Act
      const result = await userService.getUserById(userId);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(result).toEqual(expectedUser);
    });

    it('should return null when user does not exist', async () => {
      // Arrange
      const userId = 'nonexistent';
      mockUserRepository.findById.mockResolvedValue(null);

      // Act
      const result = await userService.getUserById(userId);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(result).toBeNull();
    });
  });

  describe('getAllUsers', () => {
    it('should return all users', async () => {
      // Arrange
      const expectedUsers: User[] = [
        { id: '1', name: 'John Doe', email: 'john@example.com', age: 25 },
        { id: '2', name: 'Jane Smith', email: 'jane@example.com', age: 30 },
      ];
      
      mockUserRepository.findAll.mockResolvedValue(expectedUsers);

      // Act
      const result = await userService.getAllUsers();

      // Assert
      expect(mockUserRepository.findAll).toHaveBeenCalled();
      expect(result).toEqual(expectedUsers);
    });
  });

  describe('updateUser', () => {
    it('should update a user when user exists', async () => {
      // Arrange
      const userId = '1';
      const userData = { name: 'Updated Name' };
      const existingUser: User = { 
        id: userId, 
        name: 'John Doe', 
        email: 'john@example.com', 
        age: 25 
      };
      const updatedUser: User = { 
        ...existingUser, 
        ...userData 
      };
      
      mockUserRepository.findById.mockResolvedValue(existingUser);
      mockUserRepository.update.mockResolvedValue(updatedUser);

      // Act
      const result = await userService.updateUser(userId, userData);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(mockUserRepository.update).toHaveBeenCalledWith(userId, userData);
      expect(result).toEqual(updatedUser);
    });

    it('should return null when user does not exist', async () => {
      // Arrange
      const userId = 'nonexistent';
      const userData = { name: 'Updated Name' };
      
      mockUserRepository.findById.mockResolvedValue(null);

      // Act
      const result = await userService.updateUser(userId, userData);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(mockUserRepository.update).not.toHaveBeenCalled();
      expect(result).toBeNull();
    });
  });

  describe('deleteUser', () => {
    it('should delete a user when user exists', async () => {
      // Arrange
      const userId = '1';
      const existingUser: User = { 
        id: userId, 
        name: 'John Doe', 
        email: 'john@example.com', 
        age: 25 
      };
      
      mockUserRepository.findById.mockResolvedValue(existingUser);
      mockUserRepository.delete.mockResolvedValue(true);

      // Act
      const result = await userService.deleteUser(userId);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(mockUserRepository.delete).toHaveBeenCalledWith(userId);
      expect(result).toBe(true);
    });

    it('should return false when user does not exist', async () => {
      // Arrange
      const userId = 'nonexistent';
      
      mockUserRepository.findById.mockResolvedValue(null);

      // Act
      const result = await userService.deleteUser(userId);

      // Assert
      expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      expect(mockUserRepository.delete).not.toHaveBeenCalled();
      expect(result).toBe(false);
    });
  });
});
```

### Dockerコンテナ内でのテスト実行コマンド

Codexを使用してDockerコンテナ内でテストを実行するコマンドの例を示します：

```bash
# コンテナをビルドしてテストを実行
docker-compose -f docker-compose.test.yml up --build --exit-code-from app

# 既存のコンテナでテストを実行
docker-compose exec app npm test

# 特定のテストファイルのみ実行
docker-compose exec app npm test -- tests/services/userService.test.ts

# カバレッジレポートを生成
docker-compose exec app npm test -- --coverage
```

## CI/CDパイプラインとの連携

Dockerを使用したリポジトリでは、Codexを活用してCI/CDパイプラインとの連携を効率化することができます。

### GitHub Actionsとの統合

GitHub Actionsを使用したCI/CDパイプラインの設定例を示します：

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Run tests
        run: docker-compose -f docker-compose.test.yml up --build --exit-code-from app
  
  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: echo "Deploying to production..."
        # 実際のデプロイコマンド
```

### Codexによるワークフロー生成

Codexを使用して、CI/CDワークフローファイルを生成する例を示します：

```
GitHub Actionsを使用して、以下の要件を満たすCI/CDワークフローを作成してください：
1. Dockerコンテナ内でテストを実行
2. テスト成功後にDockerイメージをビルドしてGitHub Container Registryにプッシュ
3. 本番環境へのデプロイ（AWS ECSを使用）
4. プルリクエストでは1のみ実行、mainブランチへのプッシュでは1-3を実行
```

Codexは以下のようなワークフローファイルを生成します：

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: my-app
  ECS_SERVICE: my-app-service
  ECS_CLUSTER: my-app-cluster
  ECS_TASK_DEFINITION: .aws/task-definition.json
  CONTAINER_NAME: app

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Cache Docker layers
        uses: actions/cache@v3
        with:
          path: /tmp/.buildx-cache
          key: ${{ runner.os }}-buildx-${{ github.sha }}
          restore-keys: |
            ${{ runner.os }}-buildx-

      - name: Run tests in Docker
        run: |
          docker-compose -f docker-compose.test.yml up --build --exit-code-from app
          
  build-and-push:
    name: Build and Push Docker image
    needs: test
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
        
      - name: Cache Docker layers
        uses: actions/cache@v3
        with:
          path: /tmp/.buildx-cache
          key: ${{ runner.os }}-buildx-${{ github.sha }}
          restore-keys: |
            ${{ runner.os }}-buildx-
            
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Extract metadata for Docker
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=sha,format=long
            type=ref,event=branch
            latest
            
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=local,src=/tmp/.buildx-cache
          cache-to: type=local,dest=/tmp/.buildx-cache-new
          
      # キャッシュの最適化
      - name: Move cache
        run: |
          rm -rf /tmp/.buildx-cache
          mv /tmp/.buildx-cache-new /tmp/.buildx-cache
          
  deploy:
    name: Deploy to Amazon ECS
    needs: build-and-push
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
          
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
        
      - name: Download task definition
        run: |
          aws ecs describe-task-definition --task-definition ${{ env.ECS_TASK_DEFINITION }} \
          --query taskDefinition > task-definition.json
          
      - name: Fill in the new image ID in the Amazon ECS task definition
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: task-definition.json
          container-name: ${{ env.CONTAINER_NAME }}
          image: ghcr.io/${{ github.repository }}:latest
          
      - name: Deploy Amazon ECS task definition
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ env.ECS_SERVICE }}
          cluster: ${{ env.ECS_CLUSTER }}
          wait-for-service-stability: true
```

### Codexによるテスト結果の解析

Codexを使用して、CI/CDパイプラインで生成されたテスト結果を解析する例を示します：

```
以下のJestテスト結果を解析し、失敗したテストの原因と修正方法を提案してください。
```

```
FAIL  tests/services/userService.test.ts
  UserService
    createUser
      ✓ should create a user when all inputs are valid (5ms)
      ✓ should throw an error when name is missing (2ms)
      ✓ should throw an error when email is missing (1ms)
      ✓ should throw an error when age is less than 18 (1ms)
      ✓ should throw an error when user with email already exists (1ms)
    getUserById
      ✓ should return a user when user exists (1ms)
      ✓ should return null when user does not exist
    getAllUsers
      ✓ should return all users
    updateUser
      ✓ should update a user when user exists (1ms)
      ✓ should return null when user does not exist
    deleteUser
      ✓ should delete a user when user exists
      ✕ should return false when user does not exist (3ms)

  ● UserService › deleteUser › should return false when user does not exist

    expect(received).toBe(expected) // Object.is equality

    Expected: false
    Received: undefined

      69 |       expect(mockUserRepository.findById).toHaveBeenCalledWith(userId);
      70 |       expect(mockUserRepository.delete).not.toHaveBeenCalled();
    > 71 |       expect(result).toBe(false);
         |                      ^
      72 |     });
      73 |   });
      74 | });

      at Object.<anonymous> (tests/services/userService.test.ts:71:22)

Test Suites: 1 failed, 0 passed, 1 total
Tests:       1 failed, 11 passed, 12 total
Snapshots:   0 total
Time:        1.5s
Ran all test suites matching /tests\/services\/userService.test.ts/i.
```

Codexは以下のような解析結果を提供します：

```
# テスト結果の解析

## 失敗したテスト

`UserService › deleteUser › should return false when user does not exist` テストが失敗しています。

## 失敗の原因

テストでは、ユーザーが存在しない場合に `deleteUser` メソッドが `false` を返すことを期待していますが、実際には `undefined` が返されています。

エラーメッセージ:
```
expect(received).toBe(expected) // Object.is equality

Expected: false
Received: undefined
```

## 問題のコード

`userService.ts` ファイルの `deleteUser` メソッドに問題があります。ユーザーが存在しない場合に明示的に `false` を返していないようです。

## 修正方法

`userService.ts` ファイルの `deleteUser` メソッドを以下のように修正してください：

```typescript
async deleteUser(id: string): Promise<boolean> {
  const user = await this.userRepository.findById(id);
  if (!user) {
    return false; // 明示的に false を返す
  }

  return this.userRepository.delete(id);
}
```

この修正により、ユーザーが存在しない場合に明示的に `false` が返されるようになり、テストが成功するはずです。

## 追加の推奨事項

1. 他のメソッドも同様に、エラーケースで明示的な戻り値を返すようにしてください。
2. 型の厳密なチェックを行うために、TypeScriptの厳格モード (`strict: true`) を有効にすることを検討してください。
3. 非同期メソッドのエラーハンドリングを改善するために、try-catchブロックの使用を検討してください。
```

## マルチステージビルドの最適化

Dockerを使用したリポジトリでは、マルチステージビルドを活用して効率的なイメージを構築することが重要です。Codexを使用してマルチステージビルドを最適化する例を示します。

### 基本的なマルチステージビルド

Node.jsアプリケーションのマルチステージビルドの例を示します：

```dockerfile
# ビルドステージ
FROM node:16-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# 実行ステージ
FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

RUN npm ci --only=production

USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Codexによるマルチステージビルドの最適化

Codexを使用して、マルチステージビルドを最適化する例を示します：

```
以下のDockerfileを最適化してください：
1. ビルド時間を短縮するためにキャッシュを効果的に活用
2. 最終イメージのサイズを最小化
3. セキュリティを向上させる
4. 環境変数を適切に使用
```

```dockerfile
FROM node:16 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:16

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

RUN npm install

EXPOSE 3000
CMD ["node", "dist/main.js"]
```

Codexは以下のような最適化されたDockerfileを提案します：

```dockerfile
# ビルドステージ
FROM node:16-alpine AS builder

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係のインストール（キャッシュ活用のため、package.jsonとpackage-lock.jsonのみをコピー）
COPY package.json package-lock.json ./
RUN npm ci

# ソースコードをコピー
COPY tsconfig*.json ./
COPY src/ ./src/

# アプリケーションをビルド
RUN npm run build

# 本番依存関係のインストール
FROM node:16-alpine AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --only=production

# 実行ステージ
FROM node:16-alpine AS runner

# 非rootユーザーを作成
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# 作業ディレクトリを設定し、非rootユーザーに所有権を与える
WORKDIR /app
RUN chown -R nodejs:nodejs /app

# 本番依存関係をコピー
COPY --from=dependencies --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist

# package.jsonをコピー（アプリケーション情報のため）
COPY --chown=nodejs:nodejs package.json ./

# 環境変数を設定
ENV NODE_ENV=production
ENV PORT=3000

# 非rootユーザーに切り替え
USER nodejs

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:$PORT/health || exit 1

# アプリケーションポートを公開
EXPOSE $PORT

# アプリケーションを実行
CMD ["node", "dist/main.js"]
```

### マルチステージビルドの利点

Codexを使用して最適化されたマルチステージビルドの利点は以下の通りです：

1. **ビルド時間の短縮**：
   - 依存関係のインストールとソースコードのビルドを分離することで、キャッシュを効果的に活用
   - 変更が少ない層を先に配置することで、再ビルド時間を短縮

2. **イメージサイズの最小化**：
   - 開発依存関係を最終イメージから除外
   - 必要なファイルのみをコピーすることで、イメージサイズを削減

3. **セキュリティの向上**：
   - 非rootユーザーでアプリケーションを実行
   - 最小限のベースイメージを使用
   - 不要なツールやファイルを含めない

4. **環境変数の適切な使用**：
   - 設定を環境変数として外部化
   - ビルド時と実行時の環境変数を分離

Dockerを使用したリポジトリにおいて、Codexはこのように様々な場面で開発効率を向上させることができます。次章では、CI/CDとCodexの連携について詳しく解説します。
