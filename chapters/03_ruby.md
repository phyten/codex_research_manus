## Ruby言語でのCodex活用

### Rubyプロジェクトでの基本的な開発フロー

Ruby言語を使用したプロジェクトでは、Codexを活用することで開発効率を大幅に向上させることができます。ここでは、Rubyプロジェクトにおける基本的な開発フローを解説します。

#### Rubyプロジェクトの初期設定

Codexを効果的に活用するためには、プロジェクトの初期設定が重要です。以下の手順で設定を行います：

1. **GitHubリポジトリの準備**：
   Codexを使用するには、まずGitHubリポジトリを用意し、Codexとの連携を設定します。

2. **AGENTS.mdファイルの作成**：
   Rubyプロジェクト用のAGENTS.mdファイルを作成し、Ruby固有の設定を記述します。

   ```markdown
   # Agent Guidelines for Ruby Project

   ## Project Overview
   このプロジェクトはRubyで開発されたWebアプリケーションです。

   ## Code Style
   - [RuboCop](https://rubocop.org)のスタイルガイドに従ってください
   - インデントはスペース2つを使用してください
   - メソッド名はスネークケースを使用してください

   ## Testing
   - RSpecを使用してテストを記述してください
   - テスト実行コマンド: `bundle exec rspec`
   - すべての新機能には対応するテストを追加してください

   ## Dependencies
   - 依存関係はBundlerで管理しています
   - 新しいgemを追加する場合は、Gemfileに追加し、`bundle install`を実行してください
   ```

3. **セットアップスクリプトの準備**：
   Codexが自動的に実行するセットアップスクリプトを用意します。

   ```bash
   #!/bin/bash
   # setup.sh
   gem install bundler
   bundle install
   bundle exec rake db:setup
   ```

#### Rubyプロジェクトでの開発サイクル

Codexを活用したRubyプロジェクトの一般的な開発サイクルは以下の通りです：

1. **機能要件の定義**：
   自然言語で新機能の要件を定義します。

2. **Codexへのタスク依頼**：
   ChatGPTのサイドバーからCodexを開き、「Code」ボタンを使用して新機能の実装を依頼します。

   ```
   Rubyで以下の機能を実装してください：
   - ユーザーモデルにメールアドレス検証機能を追加
   - ActiveRecordのバリデーションを使用
   - 対応するRSpecテストも作成
   ```

3. **コード生成と検証**：
   Codexは独立した環境でコードを生成し、テストを実行して検証します。

4. **プルリクエストの確認**：
   生成されたコードとテスト結果を確認し、必要に応じて修正を依頼します。

5. **プルリクエストのマージ**：
   問題がなければ、生成されたプルリクエストをマージします。

#### Rubyプロジェクトでのベストプラクティス

RubyプロジェクトでのCodex活用におけるベストプラクティスは以下の通りです：

- **明確なコーディング規約の定義**：
  RuboCopの設定ファイル（.rubocop.yml）を用意し、プロジェクト固有のルールを定義します。

- **テスト駆動開発（TDD）の採用**：
  先にテスト要件を指定し、Codexにテストを満たすコードを生成させることで、品質を担保します。

- **段階的な機能実装**：
  大きな機能を一度に実装するのではなく、小さな単位に分割して段階的に実装することで、管理しやすくします。

- **コードレビューの徹底**：
  Codexが生成したコードも必ず人間がレビューし、Rubyの慣習やプロジェクト固有の要件に合致しているか確認します。

### テストコード自動生成とリファクタリング

Codexは、Rubyプロジェクトにおけるテストコードの自動生成とリファクタリングに特に強みを発揮します。

#### RSpecテストの自動生成

既存のRubyコードに対するRSpecテストを自動生成する例を示します：

```ruby
# user.rb
class User
  attr_accessor :name, :email, :age
  
  def initialize(name, email, age)
    @name = name
    @email = email
    @age = age
  end
  
  def adult?
    @age >= 18
  end
  
  def valid_email?
    email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end
end
```

このクラスに対して、Codexに以下のようにテスト生成を依頼します：

```
user.rbクラスに対するRSpecテストを作成してください。
すべてのメソッドをカバーし、エッジケースも考慮してください。
```

Codexは以下のようなRSpecテストを生成します：

```ruby
# spec/user_spec.rb
require 'spec_helper'
require_relative '../user'

RSpec.describe User do
  describe '#initialize' do
    it 'sets the name, email and age' do
      user = User.new('John Doe', 'john@example.com', 25)
      expect(user.name).to eq('John Doe')
      expect(user.email).to eq('john@example.com')
      expect(user.age).to eq(25)
    end
  end
  
  describe '#adult?' do
    it 'returns true when age is 18 or above' do
      user = User.new('John', 'john@example.com', 18)
      expect(user.adult?).to be true
      
      user.age = 25
      expect(user.adult?).to be true
    end
    
    it 'returns false when age is below 18' do
      user = User.new('John', 'john@example.com', 17)
      expect(user.adult?).to be false
    end
  end
  
  describe '#valid_email?' do
    it 'returns true for valid email formats' do
      user = User.new('John', 'john@example.com', 25)
      expect(user.valid_email?).to be true
      
      user.email = 'john.doe@example.co.uk'
      expect(user.valid_email?).to be true
      
      user.email = 'john-doe@example.io'
      expect(user.valid_email?).to be true
    end
    
    it 'returns false for invalid email formats' do
      user = User.new('John', 'invalid-email', 25)
      expect(user.valid_email?).to be false
      
      user.email = 'john@example'
      expect(user.valid_email?).to be false
      
      user.email = '@example.com'
      expect(user.valid_email?).to be false
    end
  end
end
```

#### Rubyコードのリファクタリング

Codexを使用して既存のRubyコードをリファクタリングする例を示します。以下は、リファクタリングが必要な典型的なRubyコードです：

```ruby
# orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = Order.all
    @orders = @orders.where(status: params[:status]) if params[:status].present?
    @orders = @orders.where(user_id: params[:user_id]) if params[:user_id].present?
    @orders = @orders.where('created_at >= ?', params[:start_date]) if params[:start_date].present?
    @orders = @orders.where('created_at <= ?', params[:end_date]) if params[:end_date].present?
    @orders = @orders.order(created_at: :desc)
    
    respond_to do |format|
      format.html
      format.json { render json: @orders }
      format.csv do
        csv_data = CSV.generate do |csv|
          csv << ['ID', 'User', 'Status', 'Total', 'Created At']
          @orders.each do |order|
            csv << [
              order.id,
              order.user.name,
              order.status,
              order.total,
              order.created_at
            ]
          end
        end
        send_data csv_data, filename: "orders-#{Date.today}.csv"
      end
    end
  end
end
```

このコードに対して、Codexに以下のようにリファクタリングを依頼します：

```
orders_controller.rbをリファクタリングしてください。
- クエリロジックをスコープに移動
- レスポンス処理をシンプルに
- CSVエクスポート機能を別のサービスに抽出
```

Codexは以下のようなリファクタリング結果を提案します：

```ruby
# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  
  scope :filter_by_status, ->(status) { where(status: status) if status.present? }
  scope :filter_by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :filter_by_date_range, ->(start_date, end_date) {
    result = all
    result = result.where('created_at >= ?', start_date) if start_date.present?
    result = result.where('created_at <= ?', end_date) if end_date.present?
    result
  }
  
  def self.apply_filters(filters)
    result = all
    result = result.filter_by_status(filters[:status])
    result = result.filter_by_user(filters[:user_id])
    result = result.filter_by_date_range(filters[:start_date], filters[:end_date])
    result.order(created_at: :desc)
  end
end

# app/services/order_csv_exporter.rb
class OrderCsvExporter
  def initialize(orders)
    @orders = orders
  end
  
  def generate
    CSV.generate do |csv|
      csv << ['ID', 'User', 'Status', 'Total', 'Created At']
      @orders.each do |order|
        csv << [
          order.id,
          order.user.name,
          order.status,
          order.total,
          order.created_at
        ]
      end
    end
  end
  
  def export_file
    filename = "orders-#{Date.today}.csv"
    { data: generate, filename: filename }
  end
end

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = Order.apply_filters(filter_params)
    
    respond_to do |format|
      format.html
      format.json { render json: @orders }
      format.csv do
        export = OrderCsvExporter.new(@orders).export_file
        send_data export[:data], filename: export[:filename]
      end
    end
  end
  
  private
  
  def filter_params
    params.permit(:status, :user_id, :start_date, :end_date)
  end
end
```

このリファクタリングにより、以下の改善が実現されています：
- クエリロジックがモデルのスコープに移動し、コントローラーがシンプルになった
- CSVエクスポート機能が専用のサービスクラスに抽出された
- パラメーター処理が明示的になり、セキュリティが向上した
- コードの責務が適切に分離され、保守性が向上した

### Railsアプリケーション開発での活用例

Codexは、Ruby on Railsアプリケーション開発において特に強力なツールとなります。以下に、Railsアプリケーション開発でのCodex活用例を示します。

#### APIエンドポイントの自動生成

RESTful APIエンドポイントを自動生成する例を示します。以下のようにCodexに依頼します：

```
Railsで商品（Product）のRESTful APIを実装してください。
- 商品は名前、説明、価格、在庫数を持ちます
- JSONレスポンスを返すエンドポイント
- JWTによる認証
- RSpecでのテスト
```

Codexは以下のようなコードを生成します：

```ruby
# app/models/product.rb
class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end

# db/migrate/YYYYMMDDHHMMSS_create_products.rb
class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0
      t.integer :stock, default: 0

      t.timestamps
    end
  end
end

# app/controllers/api/v1/products_controller.rb
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_product, only: [:show, :update, :destroy]

      # GET /api/v1/products
      def index
        @products = Product.all
        render json: @products
      end

      # GET /api/v1/products/1
      def show
        render json: @product
      end

      # POST /api/v1/products
      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/1
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/1
      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :description, :price, :stock)
      end
    end
  end
end

# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products
    end
  end
end

# JWT認証の設定（devise_jwt_auth gemを使用）
# Gemfile
# gem 'devise'
# gem 'devise-jwt'

# spec/requests/api/v1/products_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:product) { create(:product) }

  describe "GET /api/v1/products" do
    it "returns all products" do
      create_list(:product, 3)
      
      get "/api/v1/products", headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "returns a specific product" do
      get "/api/v1/products/#{product.id}", headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(product.id)
    end
  end

  describe "POST /api/v1/products" do
    let(:valid_attributes) { { product: { name: "New Product", price: 19.99, stock: 100 } } }

    it "creates a new product" do
      expect {
        post "/api/v1/products", params: valid_attributes, headers: auth_headers
      }.to change(Product, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /api/v1/products/:id" do
    it "updates the product" do
      put "/api/v1/products/#{product.id}", 
          params: { product: { name: "Updated Name" } }, 
          headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      expect(product.reload.name).to eq("Updated Name")
    end
  end

  describe "DELETE /api/v1/products/:id" do
    it "deletes the product" do
      product # create product
      
      expect {
        delete "/api/v1/products/#{product.id}", headers: auth_headers
      }.to change(Product, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end
```

#### ActiveJobの実装

バックグラウンドジョブを実装する例を示します：

```
Railsで注文確認メールを送信するActiveJobを実装してください。
- Sidekiqをバックエンドとして使用
- 失敗時のリトライ機能
- ログ出力
```

Codexは以下のようなコードを生成します：

```ruby
# Gemfile
# gem 'sidekiq'

# app/jobs/order_confirmation_job.rb
class OrderConfirmationJob < ApplicationJob
  queue_as :mailers
  
  retry_on StandardError, wait: :exponentially_longer, attempts: 5
  
  def perform(order_id)
    order = Order.find_by(id: order_id)
    
    if order.nil?
      logger.error "OrderConfirmationJob failed: Order ##{order_id} not found"
      return
    end
    
    logger.info "Sending confirmation email for Order ##{order.id}"
    
    begin
      OrderMailer.confirmation(order).deliver_now
      logger.info "Successfully sent confirmation email for Order ##{order.id}"
    rescue => e
      logger.error "Failed to send confirmation email for Order ##{order.id}: #{e.message}"
      raise e
    end
  end
end

# app/mailers/order_mailer.rb
class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user = order.user
    
    mail(
      to: @user.email,
      subject: "Order Confirmation ##{@order.id}"
    )
  end
end

# app/views/order_mailer/confirmation.html.erb
<h1>Thank you for your order, <%= @user.name %>!</h1>

<p>Your order #<%= @order.id %> has been confirmed.</p>

<h2>Order Details</h2>
<table>
  <thead>
    <tr>
      <th>Product</th>
      <th>Quantity</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <% @order.line_items.each do |item| %>
      <tr>
        <td><%= item.product.name %></td>
        <td><%= item.quantity %></td>
        <td><%= number_to_currency(item.price) %></td>
      </tr>
    <% end %>
  </tbody>
  <tfoot>
    <tr>
      <th colspan="2">Total:</th>
      <td><%= number_to_currency(@order.total) %></td>
    </tr>
  </tfoot>
</table>

<p>Thank you for shopping with us!</p>

# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  
  config.logger.level = Rails.env.production? ? Logger::INFO : Logger::DEBUG
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

# config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do
  # Sidekiq Web UI
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
end

# 使用例
# OrderConfirmationJob.perform_later(order.id)
```

### 実践的なユースケースとサンプルコード

ここでは、Rubyプロジェクトにおける実践的なユースケースとサンプルコードを紹介します。

#### ユースケース1: レガシーコードのリファクタリングと型付け

Rubyは動的型付け言語ですが、Codexを使用してRBSファイル（Ruby 3の型定義ファイル）を生成することができます。

```
以下のRubyクラスに対するRBS型定義ファイルを生成してください。
また、メソッドの責務を分割し、より保守性の高いコードにリファクタリングしてください。
```

```ruby
# payment_processor.rb
class PaymentProcessor
  def process(order, payment_method, options = {})
    case payment_method
    when 'credit_card'
      # クレジットカード処理
      validate_credit_card(options[:card_number], options[:expiry], options[:cvv])
      response = api_request('https://payment.example.com/api/v1/credit_card', {
        amount: order.total,
        currency: order.currency,
        card_number: options[:card_number],
        expiry: options[:expiry],
        cvv: options[:cvv],
        customer_id: order.user_id
      })
      
      if response[:status] == 'success'
        order.update(payment_status: 'paid', transaction_id: response[:transaction_id])
        OrderMailer.payment_success(order).deliver_later
        return { success: true, message: 'Payment successful', transaction_id: response[:transaction_id] }
      else
        order.update(payment_status: 'failed', error_message: response[:error])
        OrderMailer.payment_failed(order).deliver_later
        return { success: false, message: response[:error] }
      end
    when 'paypal'
      # PayPal処理
      response = api_request('https://payment.example.com/api/v1/paypal', {
        amount: order.total,
        currency: order.currency,
        paypal_email: options[:paypal_email],
        customer_id: order.user_id
      })
      
      if response[:status] == 'success'
        order.update(payment_status: 'paid', transaction_id: response[:transaction_id])
        OrderMailer.payment_success(order).deliver_later
        return { success: true, message: 'Payment successful', transaction_id: response[:transaction_id] }
      else
        order.update(payment_status: 'failed', error_message: response[:error])
        OrderMailer.payment_failed(order).deliver_later
        return { success: false, message: response[:error] }
      end
    else
      return { success: false, message: 'Unsupported payment method' }
    end
  end
  
  private
  
  def validate_credit_card(number, expiry, cvv)
    raise ArgumentError, 'Invalid card number' unless number =~ /^\d{16}$/
    raise ArgumentError, 'Invalid expiry date' unless expiry =~ /^\d{2}\/\d{2}$/
    raise ArgumentError, 'Invalid CVV' unless cvv =~ /^\d{3,4}$/
  end
  
  def api_request(url, params)
    # 実際のAPI呼び出しをシミュレート
    { status: 'success', transaction_id: SecureRandom.hex(10) }
  end
end
```

Codexによるリファクタリングと型定義の結果：

```ruby
# payment_processor.rb
class PaymentProcessor
  PaymentResult = Struct.new(:success, :message, :transaction_id, keyword_init: true)
  
  def initialize(api_client: ApiClient.new)
    @api_client = api_client
  end
  
  def process(order, payment_method, options = {})
    processor = payment_processor_for(payment_method)
    return unsupported_payment_method_result unless processor
    
    begin
      result = processor.call(order, options)
      update_order_status(order, result)
      send_notification(order, result)
      result
    rescue ArgumentError => e
      PaymentResult.new(success: false, message: e.message)
    end
  end
  
  private
  
  def payment_processor_for(payment_method)
    {
      'credit_card' => method(:process_credit_card),
      'paypal' => method(:process_paypal)
    }[payment_method]
  end
  
  def unsupported_payment_method_result
    PaymentResult.new(success: false, message: 'Unsupported payment method')
  end
  
  def process_credit_card(order, options)
    validate_credit_card(options[:card_number], options[:expiry], options[:cvv])
    
    response = @api_client.request('credit_card', {
      amount: order.total,
      currency: order.currency,
      card_number: options[:card_number],
      expiry: options[:expiry],
      cvv: options[:cvv],
      customer_id: order.user_id
    })
    
    create_result_from_response(response)
  end
  
  def process_paypal(order, options)
    response = @api_client.request('paypal', {
      amount: order.total,
      currency: order.currency,
      paypal_email: options[:paypal_email],
      customer_id: order.user_id
    })
    
    create_result_from_response(response)
  end
  
  def create_result_from_response(response)
    if response[:status] == 'success'
      PaymentResult.new(
        success: true, 
        message: 'Payment successful', 
        transaction_id: response[:transaction_id]
      )
    else
      PaymentResult.new(
        success: false, 
        message: response[:error]
      )
    end
  end
  
  def update_order_status(order, result)
    if result.success
      order.update(payment_status: 'paid', transaction_id: result.transaction_id)
    else
      order.update(payment_status: 'failed', error_message: result.message)
    end
  end
  
  def send_notification(order, result)
    if result.success
      OrderMailer.payment_success(order).deliver_later
    else
      OrderMailer.payment_failed(order).deliver_later
    end
  end
  
  def validate_credit_card(number, expiry, cvv)
    raise ArgumentError, 'Invalid card number' unless number =~ /^\d{16}$/
    raise ArgumentError, 'Invalid expiry date' unless expiry =~ /^\d{2}\/\d{2}$/
    raise ArgumentError, 'Invalid CVV' unless cvv =~ /^\d{3,4}$/
  end
end

# api_client.rb
class ApiClient
  BASE_URL = 'https://payment.example.com/api/v1'.freeze
  
  def request(endpoint, params)
    url = "#{BASE_URL}/#{endpoint}"
    # 実際のAPI呼び出しをシミュレート
    { status: 'success', transaction_id: SecureRandom.hex(10) }
  end
end
```

```ruby
# sig/payment_processor.rbs
class PaymentProcessor
  class PaymentResult
    attr_reader success: bool
    attr_reader message: String
    attr_reader transaction_id: String?

    def initialize: (success: bool, message: String, ?transaction_id: String?) -> void
  end

  def initialize: (?api_client: ApiClient) -> void
  def process: (Order, String, ?Hash[Symbol, untyped]) -> PaymentResult

  private
  def payment_processor_for: (String) -> (^(Order, Hash[Symbol, untyped]) -> PaymentResult)?
  def unsupported_payment_method_result: -> PaymentResult
  def process_credit_card: (Order, Hash[Symbol, untyped]) -> PaymentResult
  def process_paypal: (Order, Hash[Symbol, untyped]) -> PaymentResult
  def create_result_from_response: (Hash[Symbol, untyped]) -> PaymentResult
  def update_order_status: (Order, PaymentResult) -> void
  def send_notification: (Order, PaymentResult) -> void
  def validate_credit_card: (String, String, String) -> void
end

class ApiClient
  BASE_URL: String

  def request: (String, Hash[Symbol, untyped]) -> Hash[Symbol, untyped]
end

class Order
  attr_reader total: Numeric
  attr_reader currency: String
  attr_reader user_id: Integer

  def update: (Hash[Symbol, untyped]) -> bool
end
```

このリファクタリングにより、以下の改善が実現されています：
- 単一責任の原則に従ったクラス設計
- 依存性の注入によるテスト容易性の向上
- 戦略パターンを用いた支払い方法の拡張性
- 明示的な型定義による安全性の向上
- 重複コードの排除

#### ユースケース2: GraphQLスキーマとリゾルバーの実装

Rubyでの GraphQL API 実装例：

```
Ruby on RailsでGraphQL APIを実装してください。
- ユーザー、記事、コメントのモデル
- クエリとミューテーション
- N+1問題の解決
```

Codexによる実装：

```ruby
# Gemfile
# gem 'graphql'
# gem 'batch-loader'

# app/graphql/types/user_type.rb
module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :articles, [Types::ArticleType], null: false
    field :articles_count, Integer, null: false
    
    def articles_count
      BatchLoader::GraphQL.for(object.id).batch do |user_ids, loader|
        Article.where(user_id: user_ids).group(:user_id).count.each do |user_id, count|
          loader.call(user_id, count)
        end
      end
    end
  end
end

# app/graphql/types/article_type.rb
module Types
  class ArticleType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :content, String, null: false
    field :user, Types::UserType, null: false
    field :comments, [Types::CommentType], null: false
    field :comments_count, Integer, null: false
    
    def comments_count
      BatchLoader::GraphQL.for(object.id).batch do |article_ids, loader|
        Comment.where(article_id: article_ids).group(:article_id).count.each do |article_id, count|
          loader.call(article_id, count)
        end
      end
    end
  end
end

# app/graphql/types/comment_type.rb
module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :user, Types::UserType, null: false
    field :article, Types::ArticleType, null: false
  end
end

# app/graphql/types/query_type.rb
module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false do
      argument :limit, Integer, required: false, default_value: 20
    end
    
    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
    end
    
    field :articles, [Types::ArticleType], null: false do
      argument :limit, Integer, required: false, default_value: 20
      argument :user_id, ID, required: false
    end
    
    field :article, Types::ArticleType, null: true do
      argument :id, ID, required: true
    end
    
    def users(limit:)
      User.limit(limit)
    end
    
    def user(id:)
      User.find_by(id: id)
    end
    
    def articles(limit:, user_id: nil)
      articles = Article.all
      articles = articles.where(user_id: user_id) if user_id
      articles.limit(limit)
    end
    
    def article(id:)
      Article.find_by(id: id)
    end
  end
end

# app/graphql/types/mutation_type.rb
module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :create_article, mutation: Mutations::CreateArticle
    field :update_article, mutation: Mutations::UpdateArticle
    field :delete_article, mutation: Mutations::DeleteArticle
    field :create_comment, mutation: Mutations::CreateComment
  end
end

# app/graphql/mutations/create_user.rb
module Mutations
  class CreateUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    
    field :user, Types::UserType, null: true
    field :errors, [String], null: false
    
    def resolve(name:, email:, password:)
      user = User.new(name: name, email: email, password: password)
      
      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end

# app/graphql/mutations/create_article.rb
module Mutations
  class CreateArticle < BaseMutation
    argument :title, String, required: true
    argument :content, String, required: true
    argument :user_id, ID, required: true
    
    field :article, Types::ArticleType, null: true
    field :errors, [String], null: false
    
    def resolve(title:, content:, user_id:)
      article = Article.new(
        title: title,
        content: content,
        user_id: user_id
      )
      
      if article.save
        { article: article, errors: [] }
      else
        { article: nil, errors: article.errors.full_messages }
      end
    end
  end
end

# app/graphql/mutations/create_comment.rb
module Mutations
  class CreateComment < BaseMutation
    argument :content, String, required: true
    argument :user_id, ID, required: true
    argument :article_id, ID, required: true
    
    field :comment, Types::CommentType, null: true
    field :errors, [String], null: false
    
    def resolve(content:, user_id:, article_id:)
      comment = Comment.new(
        content: content,
        user_id: user_id,
        article_id: article_id
      )
      
      if comment.save
        { comment: comment, errors: [] }
      else
        { comment: nil, errors: comment.errors.full_messages }
      end
    end
  end
end

# config/application.rb
# BatchLoader の設定
require 'batch-loader'
BatchLoader::Middleware.ensure_configured

Rails.application.configure do
  config.middleware.use BatchLoader::Middleware
end
```

このGraphQL実装により、以下のような柔軟なAPIが実現されています：
- 必要なデータだけを取得できる効率的なクエリ
- BatchLoaderによるN+1問題の解決
- 型安全なAPI設計
- 複雑なデータ関係の表現

Rubyプロジェクトにおいて、Codexはこのように様々な場面で開発効率を向上させることができます。次章では、TypeScript言語でのCodex活用について解説します。
