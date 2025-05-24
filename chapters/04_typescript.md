# TypeScript言語でのCodex活用

## TypeScriptプロジェクトでの基本的な開発フロー

TypeScriptは静的型付けを提供するJavaScriptのスーパーセットとして、大規模なアプリケーション開発において高い人気を誇ります。Codexを活用することで、TypeScriptの型安全性を維持しながら、開発効率を大幅に向上させることができます。

### TypeScriptプロジェクトの初期設定

Codexを効果的に活用するためのTypeScriptプロジェクトの初期設定手順は以下の通りです：

1. **GitHubリポジトリの準備**：
   まず、GitHubリポジトリを用意し、Codexとの連携を設定します。

2. **AGENTS.mdファイルの作成**：
   TypeScript固有の設定を含むAGENTS.mdファイルを作成します。

   ```markdown
   # Agent Guidelines for TypeScript Project

   ## Project Overview
   このプロジェクトはTypeScriptで開発されたフロントエンドアプリケーションです。

   ## Code Style
   - [ESLint](https://eslint.org/)と[Prettier](https://prettier.io/)を使用しています
   - [Airbnb Style Guide](https://github.com/airbnb/javascript)に準拠してください
   - インデントはスペース2つを使用してください
   - 関数名はキャメルケースを使用してください
   - インターフェース名は`I`プレフィックスを使用しないでください

   ## Testing
   - Jestを使用してテストを記述してください
   - テスト実行コマンド: `npm test`
   - すべての新機能には対応するテストを追加してください
   - コンポーネントテストにはReact Testing Libraryを使用してください

   ## Type Safety
   - `any`型の使用は避けてください
   - 適切な型定義を常に提供してください
   - 型定義ファイル（.d.ts）は必要に応じて作成してください
   - ジェネリクスを活用して型の再利用性を高めてください

   ## Dependencies
   - 依存関係はnpmで管理しています
   - 新しいパッケージを追加する場合は、`npm install --save`または`npm install --save-dev`を使用してください
   ```

3. **セットアップスクリプトの準備**：
   Codexが自動的に実行するセットアップスクリプトを用意します。

   ```bash
   #!/bin/bash
   # setup.sh
   npm install
   npm run build
   ```

4. **tsconfig.jsonの設定**：
   TypeScriptの設定ファイルを適切に構成します。

   ```json
   {
     "compilerOptions": {
       "target": "es2020",
       "module": "esnext",
       "moduleResolution": "node",
       "jsx": "react-jsx",
       "strict": true,
       "esModuleInterop": true,
       "skipLibCheck": true,
       "forceConsistentCasingInFileNames": true,
       "noImplicitAny": true,
       "strictNullChecks": true,
       "noImplicitThis": true,
       "noUnusedLocals": true,
       "noUnusedParameters": true,
       "noImplicitReturns": true,
       "baseUrl": ".",
       "paths": {
         "@/*": ["src/*"]
       },
       "outDir": "dist"
     },
     "include": ["src/**/*"],
     "exclude": ["node_modules", "dist"]
   }
   ```

### TypeScriptプロジェクトでの開発サイクル

Codexを活用したTypeScriptプロジェクトの一般的な開発サイクルは以下の通りです：

1. **機能要件の定義**：
   自然言語で新機能の要件を定義します。

2. **Codexへのタスク依頼**：
   ChatGPTのサイドバーからCodexを開き、「Code」ボタンを使用して新機能の実装を依頼します。

   ```
   TypeScriptで以下の機能を実装してください：
   - ユーザー認証フォームコンポーネント
   - Formikとyupを使用したバリデーション
   - ダークモード対応
   - アクセシビリティ対応
   - 対応するテストも作成
   ```

3. **コード生成と検証**：
   Codexは独立した環境でコードを生成し、TypeScriptのコンパイルとテストを実行して検証します。

4. **プルリクエストの確認**：
   生成されたコードとテスト結果を確認し、必要に応じて修正を依頼します。

5. **プルリクエストのマージ**：
   問題がなければ、生成されたプルリクエストをマージします。

### TypeScriptプロジェクトでのベストプラクティス

TypeScriptプロジェクトでのCodex活用におけるベストプラクティスは以下の通りです：

- **型定義の明示的な要求**：
  Codexに対して、明示的に型定義を含めるよう指示することで、型安全性を確保します。

- **段階的な機能実装**：
  大きな機能を一度に実装するのではなく、小さな単位に分割して段階的に実装することで、管理しやすくします。

- **テスト駆動開発（TDD）の採用**：
  先にテスト要件を指定し、Codexにテストを満たすコードを生成させることで、品質を担保します。

- **コードレビューの徹底**：
  Codexが生成したコードも必ず人間がレビューし、TypeScriptの慣習やプロジェクト固有の要件に合致しているか確認します。

## 型定義の自動生成と最適化

Codexは、TypeScriptの型定義の自動生成と最適化に特に強みを発揮します。

### インターフェースとタイプの自動生成

既存のJavaScriptコードやJSONデータからTypeScriptの型定義を自動生成する例を示します：

```typescript
// 以下のJSONデータに対する型定義を生成してください
const userData = {
  id: 1,
  name: "John Doe",
  email: "john@example.com",
  age: 30,
  address: {
    street: "123 Main St",
    city: "New York",
    zipCode: "10001",
    country: "USA"
  },
  phoneNumbers: [
    { type: "home", number: "212-555-1234" },
    { type: "work", number: "646-555-5678" }
  ],
  isActive: true,
  roles: ["user", "admin"],
  lastLogin: "2025-05-15T14:30:00Z"
};
```

Codexは以下のような型定義を生成します：

```typescript
interface Address {
  street: string;
  city: string;
  zipCode: string;
  country: string;
}

interface PhoneNumber {
  type: string;
  number: string;
}

interface User {
  id: number;
  name: string;
  email: string;
  age: number;
  address: Address;
  phoneNumbers: PhoneNumber[];
  isActive: boolean;
  roles: string[];
  lastLogin: string;
}

// より厳密な型定義
type PhoneType = 'home' | 'work' | 'mobile';

interface StrictPhoneNumber {
  type: PhoneType;
  number: string;
}

type UserRole = 'user' | 'admin' | 'guest';

interface StrictUser {
  id: number;
  name: string;
  email: string;
  age: number;
  address: Address;
  phoneNumbers: StrictPhoneNumber[];
  isActive: boolean;
  roles: UserRole[];
  lastLogin: string; // ISO 8601形式の日付文字列
}
```

### APIレスポンスの型定義

外部APIのレスポンスに対する型定義を自動生成する例を示します：

```
以下のGitHub API（ユーザー情報取得）のレスポンスに対するTypeScript型定義を生成してください。
また、APIクライアント関数も実装してください。
```

```json
{
  "login": "octocat",
  "id": 1,
  "node_id": "MDQ6VXNlcjE=",
  "avatar_url": "https://github.com/images/error/octocat_happy.gif",
  "gravatar_id": "",
  "url": "https://api.github.com/users/octocat",
  "html_url": "https://github.com/octocat",
  "followers_url": "https://api.github.com/users/octocat/followers",
  "following_url": "https://api.github.com/users/octocat/following{/other_user}",
  "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
  "organizations_url": "https://api.github.com/users/octocat/orgs",
  "repos_url": "https://api.github.com/users/octocat/repos",
  "events_url": "https://api.github.com/users/octocat/events{/privacy}",
  "received_events_url": "https://api.github.com/users/octocat/received_events",
  "type": "User",
  "site_admin": false,
  "name": "monalisa octocat",
  "company": "GitHub",
  "blog": "https://github.com/blog",
  "location": "San Francisco",
  "email": "octocat@github.com",
  "hireable": false,
  "bio": "There once was...",
  "twitter_username": "monatheoctocat",
  "public_repos": 2,
  "public_gists": 1,
  "followers": 20,
  "following": 0,
  "created_at": "2008-01-14T04:33:35Z",
  "updated_at": "2008-01-14T04:33:35Z"
}
```

Codexは以下のような型定義とAPIクライアント関数を生成します：

```typescript
// github-api.ts

export interface GitHubUser {
  login: string;
  id: number;
  node_id: string;
  avatar_url: string;
  gravatar_id: string;
  url: string;
  html_url: string;
  followers_url: string;
  following_url: string;
  gists_url: string;
  starred_url: string;
  subscriptions_url: string;
  organizations_url: string;
  repos_url: string;
  events_url: string;
  received_events_url: string;
  type: string;
  site_admin: boolean;
  name: string | null;
  company: string | null;
  blog: string | null;
  location: string | null;
  email: string | null;
  hireable: boolean | null;
  bio: string | null;
  twitter_username: string | null;
  public_repos: number;
  public_gists: number;
  followers: number;
  following: number;
  created_at: string;
  updated_at: string;
}

export class GitHubApiError extends Error {
  constructor(
    public status: number,
    message: string
  ) {
    super(message);
    this.name = 'GitHubApiError';
  }
}

export async function fetchGitHubUser(username: string): Promise<GitHubUser> {
  try {
    const response = await fetch(`https://api.github.com/users/${username}`, {
      headers: {
        'Accept': 'application/vnd.github.v3+json'
      }
    });

    if (!response.ok) {
      throw new GitHubApiError(
        response.status,
        `Failed to fetch GitHub user: ${response.statusText}`
      );
    }

    return await response.json() as GitHubUser;
  } catch (error) {
    if (error instanceof GitHubApiError) {
      throw error;
    }
    throw new Error(`Network error: ${(error as Error).message}`);
  }
}

// 使用例
async function displayUserInfo(username: string): Promise<void> {
  try {
    const user = await fetchGitHubUser(username);
    console.log(`
      Name: ${user.name || 'N/A'}
      Company: ${user.company || 'N/A'}
      Location: ${user.location || 'N/A'}
      Public Repos: ${user.public_repos}
      Followers: ${user.followers}
    `);
  } catch (error) {
    console.error('Error fetching user:', error);
  }
}
```

### 型の最適化とリファクタリング

既存の型定義を最適化・リファクタリングする例を示します：

```typescript
// 以下の型定義を最適化・リファクタリングしてください
// 重複を排除し、より型安全にしてください

interface UserBase {
  id: number;
  name: string;
  email: string;
}

interface AdminUser extends UserBase {
  role: 'admin';
  permissions: string[];
  lastLogin: Date;
}

interface RegularUser extends UserBase {
  role: 'user';
  preferences: {
    theme: string;
    notifications: boolean;
    language: string;
  };
  lastLogin: Date;
}

interface GuestUser extends UserBase {
  role: 'guest';
  expiresAt: Date;
}

interface UserResponse {
  data: AdminUser | RegularUser | GuestUser;
  status: 'success' | 'error';
  timestamp: number;
}

interface ErrorResponse {
  error: {
    code: number;
    message: string;
  };
  status: 'error';
  timestamp: number;
}

type ApiResponse = UserResponse | ErrorResponse;

function processUser(user: AdminUser | RegularUser | GuestUser) {
  if (user.role === 'admin') {
    console.log(user.permissions);
  } else if (user.role === 'user') {
    console.log(user.preferences.theme);
  } else if (user.role === 'guest') {
    console.log(user.expiresAt);
  }
}
```

Codexによる最適化・リファクタリング結果：

```typescript
// 共通の基本型
interface BaseEntity {
  id: number;
}

// レスポンス共通型
interface BaseResponse {
  status: 'success' | 'error';
  timestamp: number;
}

// ユーザー基本情報
interface UserBase extends BaseEntity {
  name: string;
  email: string;
}

// ユーザーロールの型
type UserRole = 'admin' | 'user' | 'guest';

// ユーザー固有データの型
type UserRoleData = {
  admin: {
    permissions: string[];
    lastLogin: Date;
  };
  user: {
    preferences: {
      theme: string;
      notifications: boolean;
      language: string;
    };
    lastLogin: Date;
  };
  guest: {
    expiresAt: Date;
  };
};

// ユーザー型の統合
type User<R extends UserRole = UserRole> = UserBase & {
  role: R;
} & UserRoleData[R];

// 型エイリアスで具体的なユーザータイプを定義
type AdminUser = User<'admin'>;
type RegularUser = User<'user'>;
type GuestUser = User<'guest'>;

// 成功レスポンス型
interface SuccessResponse extends BaseResponse {
  status: 'success';
  data: User;
}

// エラーレスポンス型
interface ErrorResponse extends BaseResponse {
  status: 'error';
  error: {
    code: number;
    message: string;
  };
}

// API レスポンス型
type ApiResponse = SuccessResponse | ErrorResponse;

// 型ガードの実装
function isAdminUser(user: User): user is AdminUser {
  return user.role === 'admin';
}

function isRegularUser(user: User): user is RegularUser {
  return user.role === 'user';
}

function isGuestUser(user: User): user is GuestUser {
  return user.role === 'guest';
}

function isErrorResponse(response: ApiResponse): response is ErrorResponse {
  return response.status === 'error';
}

// ユーザー処理関数の改善
function processUser(user: User) {
  if (isAdminUser(user)) {
    console.log(user.permissions);
  } else if (isRegularUser(user)) {
    console.log(user.preferences.theme);
  } else if (isGuestUser(user)) {
    console.log(user.expiresAt);
  }
}

// API レスポンス処理の例
function handleApiResponse(response: ApiResponse) {
  if (isErrorResponse(response)) {
    console.error(`Error ${response.error.code}: ${response.error.message}`);
    return;
  }
  
  const user = response.data;
  processUser(user);
}
```

この最適化により、以下の改善が実現されています：
- 共通の基本型を抽出して重複を排除
- ユーザーロールに基づく型の統合
- 型ガードの実装による型安全性の向上
- ジェネリクスを活用した柔軟な型定義
- 条件分岐の型推論の改善

## フロントエンド開発での活用例

TypeScriptは特にフロントエンド開発で広く使用されています。ここでは、フロントエンド開発におけるCodexの活用例を示します。

### Reactコンポーネントの実装

Reactコンポーネントを実装する例を示します：

```
TypeScriptとReactで以下の要件を満たすデータテーブルコンポーネントを実装してください：
- ページネーション機能
- ソート機能
- フィルタリング機能
- レスポンシブデザイン
- アクセシビリティ対応
- テーマ切り替え対応
- 対応するテストも作成
```

Codexは以下のようなコードを生成します：

```typescript
// src/components/DataTable/types.ts
export interface Column<T> {
  id: string;
  label: string;
  accessor: (item: T) => React.ReactNode;
  sortable?: boolean;
  filterable?: boolean;
}

export interface SortConfig {
  key: string;
  direction: 'asc' | 'desc';
}

export interface FilterConfig {
  key: string;
  value: string;
}

export interface PaginationConfig {
  currentPage: number;
  pageSize: number;
  totalItems: number;
}

export interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  initialSort?: SortConfig;
  initialFilters?: FilterConfig[];
  initialPagination?: Partial<PaginationConfig>;
  isLoading?: boolean;
  emptyMessage?: string;
  theme?: 'light' | 'dark';
  onRowClick?: (item: T) => void;
}
```

```typescript
// src/components/DataTable/DataTable.tsx
import React, { useState, useMemo, useCallback } from 'react';
import { 
  Column, 
  SortConfig, 
  FilterConfig, 
  PaginationConfig, 
  DataTableProps 
} from './types';
import { 
  TableContainer, 
  Table, 
  TableHead, 
  TableBody, 
  TableRow, 
  TableCell, 
  TableSortLabel,
  TextField,
  Box,
  Typography,
  CircularProgress,
  Pagination,
  useTheme,
  styled
} from '@mui/material';
import { visuallyHidden } from '@mui/utils';

function DataTable<T extends Record<string, any>>({
  data,
  columns,
  initialSort,
  initialFilters = [],
  initialPagination = { currentPage: 0, pageSize: 10 },
  isLoading = false,
  emptyMessage = 'No data available',
  theme = 'light',
  onRowClick
}: DataTableProps<T>) {
  // State management
  const [sortConfig, setSortConfig] = useState<SortConfig | undefined>(initialSort);
  const [filters, setFilters] = useState<FilterConfig[]>(initialFilters);
  const [pagination, setPagination] = useState<PaginationConfig>({
    currentPage: initialPagination.currentPage || 0,
    pageSize: initialPagination.pageSize || 10,
    totalItems: data.length
  });

  // Apply sorting
  const handleSort = useCallback((key: string) => {
    setSortConfig(prevConfig => {
      if (!prevConfig || prevConfig.key !== key) {
        return { key, direction: 'asc' };
      }
      if (prevConfig.direction === 'asc') {
        return { key, direction: 'desc' };
      }
      return undefined;
    });
  }, []);

  // Apply filtering
  const handleFilter = useCallback((key: string, value: string) => {
    setFilters(prevFilters => {
      const existingFilterIndex = prevFilters.findIndex(filter => filter.key === key);
      if (existingFilterIndex >= 0) {
        if (!value) {
          return prevFilters.filter((_, index) => index !== existingFilterIndex);
        }
        const newFilters = [...prevFilters];
        newFilters[existingFilterIndex] = { key, value };
        return newFilters;
      }
      if (!value) return prevFilters;
      return [...prevFilters, { key, value }];
    });
    // Reset to first page when filtering
    setPagination(prev => ({ ...prev, currentPage: 0 }));
  }, []);

  // Handle pagination
  const handlePageChange = useCallback((_: React.ChangeEvent<unknown>, page: number) => {
    setPagination(prev => ({ ...prev, currentPage: page - 1 }));
  }, []);

  // Process data with sorting, filtering, and pagination
  const processedData = useMemo(() => {
    let result = [...data];

    // Apply filters
    filters.forEach(filter => {
      const column = columns.find(col => col.id === filter.key);
      if (column && column.filterable) {
        result = result.filter(item => {
          const value = column.accessor(item);
          return String(value).toLowerCase().includes(filter.value.toLowerCase());
        });
      }
    });

    // Apply sorting
    if (sortConfig) {
      const column = columns.find(col => col.id === sortConfig.key);
      if (column && column.sortable) {
        result.sort((a, b) => {
          const valueA = column.accessor(a);
          const valueB = column.accessor(b);
          
          if (valueA === valueB) return 0;
          
          const comparison = valueA < valueB ? -1 : 1;
          return sortConfig.direction === 'asc' ? comparison : -comparison;
        });
      }
    }

    // Update total items for pagination
    setPagination(prev => ({ ...prev, totalItems: result.length }));

    // Apply pagination
    const { currentPage, pageSize } = pagination;
    const start = currentPage * pageSize;
    const end = start + pageSize;
    return result.slice(start, end);
  }, [data, columns, sortConfig, filters, pagination.currentPage, pagination.pageSize]);

  // Calculate total pages
  const totalPages = Math.ceil(pagination.totalItems / pagination.pageSize);

  // Theme-aware styling
  const muiTheme = useTheme();
  const StyledTableContainer = styled(TableContainer)(({ theme }) => ({
    backgroundColor: theme.palette.mode === 'dark' ? '#333' : '#fff',
    borderRadius: theme.shape.borderRadius,
    boxShadow: theme.shadows[2]
  }));

  return (
    <Box>
      {/* Filter inputs */}
      <Box sx={{ mb: 2, display: 'flex', flexWrap: 'wrap', gap: 2 }}>
        {columns
          .filter(column => column.filterable)
          .map(column => (
            <TextField
              key={column.id}
              label={`Filter by ${column.label}`}
              size="small"
              variant="outlined"
              value={filters.find(f => f.key === column.id)?.value || ''}
              onChange={(e) => handleFilter(column.id, e.target.value)}
            />
          ))}
      </Box>

      {/* Table */}
      <StyledTableContainer>
        <Table aria-label="data table">
          <TableHead>
            <TableRow>
              {columns.map(column => (
                <TableCell 
                  key={column.id}
                  sortDirection={sortConfig?.key === column.id ? sortConfig.direction : false}
                >
                  {column.sortable ? (
                    <TableSortLabel
                      active={sortConfig?.key === column.id}
                      direction={sortConfig?.key === column.id ? sortConfig.direction : 'asc'}
                      onClick={() => handleSort(column.id)}
                    >
                      {column.label}
                      {sortConfig?.key === column.id && (
                        <Box component="span" sx={visuallyHidden}>
                          {sortConfig.direction === 'desc' ? 'sorted descending' : 'sorted ascending'}
                        </Box>
                      )}
                    </TableSortLabel>
                  ) : (
                    column.label
                  )}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={columns.length} align="center">
                  <CircularProgress />
                </TableCell>
              </TableRow>
            ) : processedData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={columns.length} align="center">
                  <Typography variant="body1">{emptyMessage}</Typography>
                </TableCell>
              </TableRow>
            ) : (
              processedData.map((item, index) => (
                <TableRow 
                  key={index}
                  hover={!!onRowClick}
                  onClick={onRowClick ? () => onRowClick(item) : undefined}
                  sx={{ cursor: onRowClick ? 'pointer' : 'default' }}
                  tabIndex={onRowClick ? 0 : undefined}
                  role={onRowClick ? 'button' : undefined}
                >
                  {columns.map(column => (
                    <TableCell key={column.id}>
                      {column.accessor(item)}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </StyledTableContainer>

      {/* Pagination */}
      {totalPages > 1 && (
        <Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
          <Pagination
            count={totalPages}
            page={pagination.currentPage + 1}
            onChange={handlePageChange}
            color="primary"
            showFirstButton
            showLastButton
          />
        </Box>
      )}
    </Box>
  );
}

export default DataTable;
```

```typescript
// src/components/DataTable/DataTable.test.tsx
import React from 'react';
import { render, screen, fireEvent, within } from '@testing-library/react';
import DataTable from './DataTable';
import { Column } from './types';

interface TestItem {
  id: number;
  name: string;
  age: number;
  email: string;
}

const testData: TestItem[] = [
  { id: 1, name: 'Alice', age: 28, email: 'alice@example.com' },
  { id: 2, name: 'Bob', age: 35, email: 'bob@example.com' },
  { id: 3, name: 'Charlie', age: 42, email: 'charlie@example.com' },
  { id: 4, name: 'David', age: 23, email: 'david@example.com' },
  { id: 5, name: 'Eve', age: 31, email: 'eve@example.com' },
];

const columns: Column<TestItem>[] = [
  { id: 'id', label: 'ID', accessor: (item) => item.id },
  { id: 'name', label: 'Name', accessor: (item) => item.name, sortable: true, filterable: true },
  { id: 'age', label: 'Age', accessor: (item) => item.age, sortable: true },
  { id: 'email', label: 'Email', accessor: (item) => item.email, filterable: true },
];

describe('DataTable', () => {
  test('renders table with data', () => {
    render(<DataTable data={testData} columns={columns} />);
    
    // Check column headers
    expect(screen.getByText('ID')).toBeInTheDocument();
    expect(screen.getByText('Name')).toBeInTheDocument();
    expect(screen.getByText('Age')).toBeInTheDocument();
    expect(screen.getByText('Email')).toBeInTheDocument();
    
    // Check data rows
    expect(screen.getByText('Alice')).toBeInTheDocument();
    expect(screen.getByText('Bob')).toBeInTheDocument();
    expect(screen.getByText('Charlie')).toBeInTheDocument();
  });
  
  test('handles sorting', () => {
    render(<DataTable data={testData} columns={columns} />);
    
    // Get the Name column header
    const nameHeader = screen.getByText('Name');
    
    // Click to sort ascending
    fireEvent.click(nameHeader);
    
    // Check order (should be alphabetical)
    const rows = screen.getAllByRole('row');
    const firstRowCells = within(rows[1]).getAllByRole('cell');
    const lastRowCells = within(rows[5]).getAllByRole('cell');
    
    expect(firstRowCells[1]).toHaveTextContent('Alice');
    expect(lastRowCells[1]).toHaveTextContent('Eve');
    
    // Click again to sort descending
    fireEvent.click(nameHeader);
    
    // Check order (should be reverse alphabetical)
    const updatedRows = screen.getAllByRole('row');
    const updatedFirstRowCells = within(updatedRows[1]).getAllByRole('cell');
    const updatedLastRowCells = within(updatedRows[5]).getAllByRole('cell');
    
    expect(updatedFirstRowCells[1]).toHaveTextContent('Eve');
    expect(updatedLastRowCells[1]).toHaveTextContent('Alice');
  });
  
  test('handles filtering', () => {
    render(<DataTable data={testData} columns={columns} />);
    
    // Find the name filter input
    const nameFilter = screen.getByLabelText('Filter by Name');
    
    // Filter for 'a' which should match Alice and Charlie and David
    fireEvent.change(nameFilter, { target: { value: 'a' } });
    
    // Check that only matching rows are displayed
    expect(screen.getByText('Alice')).toBeInTheDocument();
    expect(screen.getByText('Charlie')).toBeInTheDocument();
    expect(screen.getByText('David')).toBeInTheDocument();
    expect(screen.queryByText('Bob')).not.toBeInTheDocument();
    expect(screen.queryByText('Eve')).not.toBeInTheDocument();
  });
  
  test('handles row click', () => {
    const handleRowClick = jest.fn();
    render(<DataTable data={testData} columns={columns} onRowClick={handleRowClick} />);
    
    // Click on a row
    const rows = screen.getAllByRole('row');
    fireEvent.click(rows[1]); // First data row
    
    // Check that the handler was called with the correct item
    expect(handleRowClick).toHaveBeenCalledWith(testData[0]);
  });
  
  test('shows empty message when no data', () => {
    const emptyMessage = 'Custom empty message';
    render(<DataTable data={[]} columns={columns} emptyMessage={emptyMessage} />);
    
    expect(screen.getByText(emptyMessage)).toBeInTheDocument();
  });
  
  test('shows loading indicator', () => {
    render(<DataTable data={testData} columns={columns} isLoading={true} />);
    
    // CircularProgress is rendered, but we can't easily test for it directly
    // Instead, we check that the data is not rendered
    expect(screen.queryByText('Alice')).not.toBeInTheDocument();
  });
});
```

### 状態管理の実装

TypeScriptとRedux Toolkitを使用した状態管理の実装例を示します：

```
TypeScriptとRedux Toolkitを使用して、ユーザー認証の状態管理を実装してください。
以下の機能を含めてください：
- ログイン/ログアウト
- ユーザー情報の取得
- 認証状態の永続化
- 非認証ユーザーのリダイレクト
```

Codexは以下のようなコードを生成します：

```typescript
// src/features/auth/types.ts
export interface User {
  id: string;
  username: string;
  email: string;
  avatar?: string;
  roles: string[];
}

export interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface LoginResponse {
  user: User;
  token: string;
}

export interface AuthError {
  message: string;
}
```

```typescript
// src/features/auth/authSlice.ts
import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { AuthState, LoginCredentials, User, LoginResponse, AuthError } from './types';

// API calls
const API_URL = 'https://api.example.com';

async function loginApi(credentials: LoginCredentials): Promise<LoginResponse> {
  const response = await fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(credentials),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message || 'Login failed');
  }

  return response.json();
}

async function fetchUserApi(token: string): Promise<User> {
  const response = await fetch(`${API_URL}/auth/me`, {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message || 'Failed to fetch user');
  }

  return response.json();
}

// Async thunks
export const login = createAsyncThunk<
  LoginResponse,
  LoginCredentials,
  { rejectValue: AuthError }
>('auth/login', async (credentials, { rejectWithValue }) => {
  try {
    return await loginApi(credentials);
  } catch (error) {
    return rejectWithValue({ 
      message: error instanceof Error ? error.message : 'Login failed' 
    });
  }
});

export const fetchUser = createAsyncThunk<
  User,
  void,
  { state: { auth: AuthState }, rejectValue: AuthError }
>('auth/fetchUser', async (_, { getState, rejectWithValue }) => {
  try {
    const { token } = getState().auth;
    if (!token) {
      throw new Error('No token available');
    }
    return await fetchUserApi(token);
  } catch (error) {
    return rejectWithValue({ 
      message: error instanceof Error ? error.message : 'Failed to fetch user' 
    });
  }
});

// Load state from localStorage
const loadAuthState = (): Partial<AuthState> => {
  try {
    const serializedState = localStorage.getItem('authState');
    if (!serializedState) return {};
    return JSON.parse(serializedState);
  } catch (error) {
    console.error('Failed to load auth state from localStorage', error);
    return {};
  }
};

// Initial state
const initialState: AuthState = {
  user: null,
  token: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,
  ...loadAuthState(),
};

// Slice
const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.isAuthenticated = false;
      state.error = null;
      localStorage.removeItem('authState');
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      // Login
      .addCase(login.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.isLoading = false;
        state.user = action.payload.user;
        state.token = action.payload.token;
        state.isAuthenticated = true;
        
        // Persist auth state
        localStorage.setItem('authState', JSON.stringify({
          user: action.payload.user,
          token: action.payload.token,
          isAuthenticated: true,
        }));
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload?.message || 'Login failed';
      })
      
      // Fetch user
      .addCase(fetchUser.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchUser.fulfilled, (state, action) => {
        state.isLoading = false;
        state.user = action.payload;
        state.isAuthenticated = true;
        
        // Update persisted state
        localStorage.setItem('authState', JSON.stringify({
          user: action.payload,
          token: state.token,
          isAuthenticated: true,
        }));
      })
      .addCase(fetchUser.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload?.message || 'Failed to fetch user';
        
        // If token is invalid, logout
        if (action.payload?.message.includes('token')) {
          state.user = null;
          state.token = null;
          state.isAuthenticated = false;
          localStorage.removeItem('authState');
        }
      });
  },
});

export const { logout, clearError } = authSlice.actions;
export default authSlice.reducer;
```

```typescript
// src/app/store.ts
import { configureStore } from '@reduxjs/toolkit';
import authReducer from '../features/auth/authSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
```

```typescript
// src/hooks/useAuth.ts
import { useCallback } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { RootState, AppDispatch } from '../app/store';
import { login, logout, fetchUser, clearError } from '../features/auth/authSlice';
import { LoginCredentials } from '../features/auth/types';

export const useAuth = () => {
  const dispatch = useDispatch<AppDispatch>();
  const navigate = useNavigate();
  const { user, token, isAuthenticated, isLoading, error } = useSelector(
    (state: RootState) => state.auth
  );

  const handleLogin = useCallback(
    async (credentials: LoginCredentials, redirectTo = '/dashboard') => {
      try {
        const resultAction = await dispatch(login(credentials));
        if (login.fulfilled.match(resultAction)) {
          navigate(redirectTo);
          return true;
        }
        return false;
      } catch (error) {
        return false;
      }
    },
    [dispatch, navigate]
  );

  const handleLogout = useCallback(() => {
    dispatch(logout());
    navigate('/login');
  }, [dispatch, navigate]);

  const handleFetchUser = useCallback(async () => {
    if (token && !user) {
      return dispatch(fetchUser());
    }
    return Promise.resolve();
  }, [dispatch, token, user]);

  const handleClearError = useCallback(() => {
    dispatch(clearError());
  }, [dispatch]);

  return {
    user,
    token,
    isAuthenticated,
    isLoading,
    error,
    login: handleLogin,
    logout: handleLogout,
    fetchUser: handleFetchUser,
    clearError: handleClearError,
  };
};
```

```typescript
// src/components/PrivateRoute.tsx
import React, { useEffect } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

interface PrivateRouteProps {
  children: React.ReactNode;
}

const PrivateRoute: React.FC<PrivateRouteProps> = ({ children }) => {
  const { isAuthenticated, token, fetchUser, isLoading } = useAuth();
  const location = useLocation();

  useEffect(() => {
    if (token && !isAuthenticated) {
      fetchUser();
    }
  }, [token, isAuthenticated, fetchUser]);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return <>{children}</>;
};

export default PrivateRoute;
```

```typescript
// src/components/LoginForm.tsx
import React, { useState } from 'react';
import { useAuth } from '../hooks/useAuth';
import { 
  Box, 
  TextField, 
  Button, 
  Typography, 
  Alert, 
  CircularProgress 
} from '@mui/material';

const LoginForm: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login, isLoading, error, clearError } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await login({ email, password });
  };

  return (
    <Box 
      component="form" 
      onSubmit={handleSubmit} 
      sx={{ 
        maxWidth: 400, 
        mx: 'auto', 
        p: 3, 
        borderRadius: 2, 
        boxShadow: 3 
      }}
    >
      <Typography variant="h5" component="h1" gutterBottom>
        Login
      </Typography>
      
      {error && (
        <Alert 
          severity="error" 
          onClose={clearError} 
          sx={{ mb: 2 }}
        >
          {error}
        </Alert>
      )}
      
      <TextField
        label="Email"
        type="email"
        fullWidth
        margin="normal"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        disabled={isLoading}
      />
      
      <TextField
        label="Password"
        type="password"
        fullWidth
        margin="normal"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        disabled={isLoading}
      />
      
      <Button
        type="submit"
        variant="contained"
        color="primary"
        fullWidth
        sx={{ mt: 3 }}
        disabled={isLoading}
      >
        {isLoading ? <CircularProgress size={24} /> : 'Login'}
      </Button>
    </Box>
  );
};

export default LoginForm;
```

## 実践的なユースケースとサンプルコード

ここでは、TypeScriptプロジェクトにおける実践的なユースケースとサンプルコードを紹介します。

### ユースケース1: GraphQLクライアントの実装

TypeScriptとApolloクライアントを使用したGraphQLクライアントの実装例を示します：

```
TypeScriptとApollo Clientを使用して、以下の要件を満たすGraphQLクライアントを実装してください：
- 型安全なクエリとミューテーション
- キャッシュ管理
- エラーハンドリング
- 認証トークンの管理
```

Codexは以下のようなコードを生成します：

```typescript
// src/graphql/types.ts
export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
}

export interface Post {
  id: string;
  title: string;
  content: string;
  createdAt: string;
  author: User;
  comments: Comment[];
}

export interface Comment {
  id: string;
  content: string;
  createdAt: string;
  author: User;
}

export interface AuthPayload {
  token: string;
  user: User;
}
```

```typescript
// src/graphql/queries.ts
import { gql } from '@apollo/client';

export const GET_USER = gql`
  query GetUser($id: ID!) {
    user(id: $id) {
      id
      name
      email
      avatar
    }
  }
`;

export const GET_POSTS = gql`
  query GetPosts($limit: Int, $offset: Int) {
    posts(limit: $limit, offset: $offset) {
      id
      title
      content
      createdAt
      author {
        id
        name
        avatar
      }
    }
  }
`;

export const GET_POST_DETAILS = gql`
  query GetPostDetails($id: ID!) {
    post(id: $id) {
      id
      title
      content
      createdAt
      author {
        id
        name
        avatar
      }
      comments {
        id
        content
        createdAt
        author {
          id
          name
          avatar
        }
      }
    }
  }
`;
```

```typescript
// src/graphql/mutations.ts
import { gql } from '@apollo/client';

export const LOGIN = gql`
  mutation Login($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      token
      user {
        id
        name
        email
        avatar
      }
    }
  }
`;

export const CREATE_POST = gql`
  mutation CreatePost($title: String!, $content: String!) {
    createPost(title: $title, content: $content) {
      id
      title
      content
      createdAt
    }
  }
`;

export const CREATE_COMMENT = gql`
  mutation CreateComment($postId: ID!, $content: String!) {
    createComment(postId: $postId, content: $content) {
      id
      content
      createdAt
      author {
        id
        name
        avatar
      }
    }
  }
`;
```

```typescript
// src/graphql/client.ts
import { 
  ApolloClient, 
  InMemoryCache, 
  HttpLink, 
  ApolloLink, 
  from, 
  NormalizedCacheObject 
} from '@apollo/client';
import { onError } from '@apollo/client/link/error';
import { setContext } from '@apollo/client/link/context';

// Cache configuration with type policies
const cache = new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        posts: {
          // Merge function for paginated posts
          keyArgs: false,
          merge(existing = { __typename: 'PostConnection', posts: [] }, incoming) {
            return {
              ...incoming,
              posts: [...(existing.posts || []), ...(incoming.posts || [])],
            };
          },
        },
      },
    },
    Post: {
      fields: {
        comments: {
          merge(existing = [], incoming) {
            return [...existing, ...incoming];
          },
        },
      },
    },
  },
});

// HTTP link
const httpLink = new HttpLink({
  uri: process.env.REACT_APP_GRAPHQL_URL || 'https://api.example.com/graphql',
});

// Auth link for adding the token to requests
const authLink = setContext((_, { headers }) => {
  // Get the authentication token from local storage if it exists
  const token = localStorage.getItem('authToken');
  
  // Return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : '',
    },
  };
});

// Error handling link
const errorLink = onError(({ graphQLErrors, networkError, operation, forward }) => {
  if (graphQLErrors) {
    for (const err of graphQLErrors) {
      console.error(
        `[GraphQL error]: Message: ${err.message}, Location: ${err.locations}, Path: ${err.path}`,
        operation,
        err
      );
      
      // Handle authentication errors
      if (err.extensions?.code === 'UNAUTHENTICATED') {
        // Redirect to login or refresh token logic could go here
        localStorage.removeItem('authToken');
        window.location.href = '/login';
      }
    }
  }
  
  if (networkError) {
    console.error(`[Network error]: ${networkError}`, operation);
  }
  
  return forward(operation);
});

// Create the Apollo Client
export const createApolloClient = (): ApolloClient<NormalizedCacheObject> => {
  return new ApolloClient({
    link: from([errorLink, authLink, httpLink]),
    cache,
    defaultOptions: {
      watchQuery: {
        fetchPolicy: 'cache-and-network',
        errorPolicy: 'all',
      },
      query: {
        fetchPolicy: 'network-only',
        errorPolicy: 'all',
      },
      mutate: {
        errorPolicy: 'all',
      },
    },
  });
};

// Singleton instance
let apolloClient: ApolloClient<NormalizedCacheObject>;

// Initialize or reuse the Apollo Client
export const initializeApollo = (initialState = {}): ApolloClient<NormalizedCacheObject> => {
  const _apolloClient = apolloClient ?? createApolloClient();
  
  // If your page has Next.js data fetching methods that use Apollo Client,
  // the initial state gets hydrated here
  if (initialState) {
    // Get existing cache, loaded during client side data fetching
    const existingCache = _apolloClient.extract();
    
    // Restore the cache using the data passed from getStaticProps/getServerSideProps
    // combined with the existing cached data
    _apolloClient.cache.restore({ ...existingCache, ...initialState });
  }
  
  // For SSG and SSR always create a new Apollo Client
  if (typeof window === 'undefined') return _apolloClient;
  
  // Create the Apollo Client once in the client
  if (!apolloClient) apolloClient = _apolloClient;
  return apolloClient;
};
```

```typescript
// src/hooks/useAuth.ts
import { useCallback } from 'react';
import { useMutation, ApolloError } from '@apollo/client';
import { LOGIN } from '../graphql/mutations';
import { AuthPayload } from '../graphql/types';

interface LoginVariables {
  email: string;
  password: string;
}

interface UseAuthResult {
  login: (variables: LoginVariables) => Promise<AuthPayload | null>;
  logout: () => void;
  loading: boolean;
  error: ApolloError | undefined;
}

export const useAuth = (): UseAuthResult => {
  const [loginMutation, { loading, error }] = useMutation<
    { login: AuthPayload },
    LoginVariables
  >(LOGIN);

  const login = useCallback(
    async (variables: LoginVariables): Promise<AuthPayload | null> => {
      try {
        const { data } = await loginMutation({ variables });
        
        if (data?.login) {
          // Store the token
          localStorage.setItem('authToken', data.login.token);
          return data.login;
        }
        
        return null;
      } catch (error) {
        console.error('Login error:', error);
        return null;
      }
    },
    [loginMutation]
  );

  const logout = useCallback(() => {
    localStorage.removeItem('authToken');
    
    // Optional: Clear Apollo cache
    // client.resetStore();
    
    // Redirect to login page or update state
  }, []);

  return { login, logout, loading, error };
};
```

```typescript
// src/hooks/usePosts.ts
import { useQuery, useMutation } from '@apollo/client';
import { GET_POSTS, GET_POST_DETAILS } from '../graphql/queries';
import { CREATE_POST } from '../graphql/mutations';
import { Post } from '../graphql/types';

interface GetPostsVariables {
  limit?: number;
  offset?: number;
}

interface GetPostDetailsVariables {
  id: string;
}

interface CreatePostVariables {
  title: string;
  content: string;
}

export const usePosts = (variables?: GetPostsVariables) => {
  const { data, loading, error, fetchMore } = useQuery<
    { posts: Post[] },
    GetPostsVariables
  >(GET_POSTS, {
    variables: variables || { limit: 10, offset: 0 },
    notifyOnNetworkStatusChange: true,
  });

  const loadMore = (offset: number) => {
    return fetchMore({
      variables: {
        ...variables,
        offset,
      },
    });
  };

  return {
    posts: data?.posts || [],
    loading,
    error,
    loadMore,
  };
};

export const usePostDetails = (id: string) => {
  const { data, loading, error } = useQuery<
    { post: Post },
    GetPostDetailsVariables
  >(GET_POST_DETAILS, {
    variables: { id },
    skip: !id,
  });

  return {
    post: data?.post,
    loading,
    error,
  };
};

export const useCreatePost = () => {
  const [createPostMutation, { loading, error }] = useMutation<
    { createPost: Post },
    CreatePostVariables
  >(CREATE_POST, {
    update(cache, { data }) {
      if (!data) return;
      
      // Update the cache to include the new post
      cache.modify({
        fields: {
          posts(existingPosts = []) {
            const newPostRef = cache.writeFragment({
              data: data.createPost,
              fragment: gql`
                fragment NewPost on Post {
                  id
                  title
                  content
                  createdAt
                }
              `,
            });
            return [newPostRef, ...existingPosts];
          },
        },
      });
    },
  });

  const createPost = async (variables: CreatePostVariables) => {
    try {
      const { data } = await createPostMutation({ variables });
      return data?.createPost || null;
    } catch (error) {
      console.error('Create post error:', error);
      return null;
    }
  };

  return {
    createPost,
    loading,
    error,
  };
};
```

### ユースケース2: マイクロフロントエンドのモジュールフェデレーション

TypeScriptとWebpackのモジュールフェデレーションを使用したマイクロフロントエンドの実装例を示します：

```
TypeScriptとWebpackのモジュールフェデレーションを使用して、以下の要件を満たすマイクロフロントエンドアーキテクチャを実装してください：
- ホストアプリケーションと複数のリモートアプリケーション
- 共有コンポーネントライブラリ
- 型安全な連携
- 状態の共有
```

Codexは以下のようなコードを生成します：

```typescript
// 共有型定義 (shared-types/index.ts)
export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
}

export interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
}

export interface SharedConfig {
  apiUrl: string;
  version: string;
}

// 共有コンポーネントの型定義
export interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  label: string;
  onClick?: () => void;
  disabled?: boolean;
}

export interface CardProps {
  title: string;
  content: React.ReactNode;
  footer?: React.ReactNode;
  className?: string;
}
```

```typescript
// ホストアプリケーション (webpack.config.js)
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { ModuleFederationPlugin } = require('webpack').container;
const path = require('path');
const deps = require('./package.json').dependencies;

module.exports = {
  entry: './src/index',
  mode: 'development',
  devServer: {
    static: {
      directory: path.join(__dirname, 'dist'),
    },
    port: 3000,
    historyApiFallback: true,
  },
  output: {
    publicPath: 'http://localhost:3000/',
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.json'],
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        loader: 'ts-loader',
        exclude: /node_modules/,
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  plugins: [
    new ModuleFederationPlugin({
      name: 'host',
      filename: 'remoteEntry.js',
      remotes: {
        dashboard: 'dashboard@http://localhost:3001/remoteEntry.js',
        profile: 'profile@http://localhost:3002/remoteEntry.js',
        settings: 'settings@http://localhost:3003/remoteEntry.js',
      },
      exposes: {
        './AuthContext': './src/contexts/AuthContext',
        './SharedConfig': './src/config/SharedConfig',
      },
      shared: {
        ...deps,
        react: {
          singleton: true,
          requiredVersion: deps.react,
        },
        'react-dom': {
          singleton: true,
          requiredVersion: deps['react-dom'],
        },
        'react-router-dom': {
          singleton: true,
          requiredVersion: deps['react-router-dom'],
        },
        '@shared/ui': {
          singleton: true,
        },
        '@shared/types': {
          singleton: true,
        },
      },
    }),
    new HtmlWebpackPlugin({
      template: './public/index.html',
    }),
  ],
};
```

```typescript
// ホストアプリケーション (src/App.tsx)
import React, { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { SharedConfigProvider } from './config/SharedConfig';
import { Navbar, Spinner } from '@shared/ui';

// Lazy-loaded remote modules
const Dashboard = lazy(() => import('dashboard/Dashboard'));
const Profile = lazy(() => import('profile/Profile'));
const Settings = lazy(() => import('settings/Settings'));

// Fallback for loading remote modules
const RemoteModuleFallback = () => (
  <div className="flex justify-center items-center h-64">
    <Spinner size="large" />
  </div>
);

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <AuthProvider>
        <SharedConfigProvider>
          <div className="min-h-screen bg-gray-100">
            <Navbar>
              <Link to="/" className="nav-link">Dashboard</Link>
              <Link to="/profile" className="nav-link">Profile</Link>
              <Link to="/settings" className="nav-link">Settings</Link>
            </Navbar>
            
            <main className="container mx-auto py-6 px-4">
              <Suspense fallback={<RemoteModuleFallback />}>
                <Routes>
                  <Route path="/" element={<Dashboard />} />
                  <Route path="/profile" element={<Profile />} />
                  <Route path="/settings" element={<Settings />} />
                </Routes>
              </Suspense>
            </main>
          </div>
        </SharedConfigProvider>
      </AuthProvider>
    </BrowserRouter>
  );
};

export default App;
```

```typescript
// ホストアプリケーション (src/contexts/AuthContext.tsx)
import React, { createContext, useContext, useState, useEffect } from 'react';
import { User, AuthState } from '@shared/types';

interface AuthContextType extends AuthState {
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
  updateUser: (user: Partial<User>) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [authState, setAuthState] = useState<AuthState>({
    user: null,
    isAuthenticated: false,
  });

  // Load auth state from localStorage on mount
  useEffect(() => {
    const storedAuth = localStorage.getItem('auth');
    if (storedAuth) {
      try {
        const parsedAuth = JSON.parse(storedAuth);
        setAuthState(parsedAuth);
      } catch (error) {
        console.error('Failed to parse stored auth state', error);
        localStorage.removeItem('auth');
      }
    }
  }, []);

  // Persist auth state to localStorage
  useEffect(() => {
    if (authState.isAuthenticated) {
      localStorage.setItem('auth', JSON.stringify(authState));
    } else {
      localStorage.removeItem('auth');
    }
  }, [authState]);

  const login = async (email: string, password: string): Promise<boolean> => {
    try {
      // Simulate API call
      const response = await fetch('https://api.example.com/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      if (!response.ok) {
        throw new Error('Login failed');
      }

      const data = await response.json();
      setAuthState({
        user: data.user,
        isAuthenticated: true,
      });

      return true;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  };

  const logout = () => {
    setAuthState({
      user: null,
      isAuthenticated: false,
    });
  };

  const updateUser = (userData: Partial<User>) => {
    if (!authState.user) return;

    setAuthState({
      ...authState,
      user: {
        ...authState.user,
        ...userData,
      },
    });
  };

  return (
    <AuthContext.Provider
      value={{
        ...authState,
        login,
        logout,
        updateUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export default AuthContext;
```

```typescript
// リモートアプリケーション (dashboard/webpack.config.js)
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { ModuleFederationPlugin } = require('webpack').container;
const path = require('path');
const deps = require('./package.json').dependencies;

module.exports = {
  entry: './src/index',
  mode: 'development',
  devServer: {
    static: {
      directory: path.join(__dirname, 'dist'),
    },
    port: 3001,
  },
  output: {
    publicPath: 'http://localhost:3001/',
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.json'],
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        loader: 'ts-loader',
        exclude: /node_modules/,
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  plugins: [
    new ModuleFederationPlugin({
      name: 'dashboard',
      filename: 'remoteEntry.js',
      exposes: {
        './Dashboard': './src/Dashboard',
      },
      remotes: {
        host: 'host@http://localhost:3000/remoteEntry.js',
      },
      shared: {
        ...deps,
        react: {
          singleton: true,
          requiredVersion: deps.react,
        },
        'react-dom': {
          singleton: true,
          requiredVersion: deps['react-dom'],
        },
        'react-router-dom': {
          singleton: true,
          requiredVersion: deps['react-router-dom'],
        },
        '@shared/ui': {
          singleton: true,
        },
        '@shared/types': {
          singleton: true,
        },
      },
    }),
    new HtmlWebpackPlugin({
      template: './public/index.html',
    }),
  ],
};
```

```typescript
// リモートアプリケーション (dashboard/src/Dashboard.tsx)
import React, { useEffect, useState } from 'react';
import { Card, Button, Chart } from '@shared/ui';
import { useAuth } from 'host/AuthContext';
import { SharedConfig } from 'host/SharedConfig';

interface DashboardStats {
  totalUsers: number;
  activeUsers: number;
  revenue: number;
  growth: number;
}

const Dashboard: React.FC = () => {
  const { user, isAuthenticated } = useAuth();
  const { apiUrl, version } = SharedConfig.useConfig();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        setLoading(true);
        // Use the shared API URL from config
        const response = await fetch(`${apiUrl}/dashboard/stats`);
        const data = await response.json();
        setStats(data);
      } catch (error) {
        console.error('Failed to fetch dashboard stats', error);
      } finally {
        setLoading(false);
      }
    };

    if (isAuthenticated) {
      fetchStats();
    }
  }, [apiUrl, isAuthenticated]);

  if (!isAuthenticated) {
    return (
      <Card title="Dashboard">
        <p>Please log in to view your dashboard.</p>
      </Card>
    );
  }

  if (loading) {
    return (
      <Card title="Dashboard">
        <div className="flex justify-center p-4">
          <span className="loading-spinner" />
        </div>
      </Card>
    );
  }

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Welcome, {user?.name}</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <Card title="Total Users">
          <div className="text-3xl font-bold">{stats?.totalUsers.toLocaleString()}</div>
        </Card>
        
        <Card title="Active Users">
          <div className="text-3xl font-bold">{stats?.activeUsers.toLocaleString()}</div>
        </Card>
        
        <Card title="Revenue">
          <div className="text-3xl font-bold">${stats?.revenue.toLocaleString()}</div>
        </Card>
        
        <Card title="Growth">
          <div className="text-3xl font-bold">{stats?.growth}%</div>
        </Card>
      </div>
      
      <Card title="Performance Overview">
        <Chart
          type="line"
          data={{
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [
              {
                label: 'Users',
                data: [1200, 1900, 3000, 5000, 8000, 12000],
                borderColor: '#3b82f6',
              },
              {
                label: 'Revenue',
                data: [1000, 2000, 5000, 10000, 15000, 25000],
                borderColor: '#10b981',
              },
            ],
          }}
          options={{
            responsive: true,
            maintainAspectRatio: false,
          }}
          height={300}
        />
      </Card>
      
      <div className="mt-4 text-sm text-gray-500">
        Dashboard Module v{version}
      </div>
    </div>
  );
};

export default Dashboard;
```

TypeScriptプロジェクトにおいて、Codexはこのように様々な場面で開発効率を向上させることができます。次章では、Go言語でのCodex活用について解説します。
