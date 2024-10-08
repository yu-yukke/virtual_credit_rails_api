# Ruby

- 3.2.2

# Rails

- 7.0.8

# 環境構築

- docker コンテナをビルド

```bash
docker-compose build
```

- docker コンテナを起動

```bash
docker-compose up
```

- データベース作成

```bash
docker-compose exec app bundle exec rails db:create
```

- データベース接続

```bash
docker exec -it virtual_credit_db psql -U admin -d virtual_credit_development
```

- seed 投入

```bash
docker-compose exec app bundle exec rails db:seed
```

**既存のレコードは全て削除されるので注意**

# 各ポートへの割り当て

## 4000

- API

## 5432

- PostgresQL

## 5050

- pgadmin

## 8080

- Swagger UI

## 9001

- MinIO

# マイグレーション

- 基本は ridgepole を採用

```bash
 docker-compose exec app bundle exec rake ridge:run
```

- ActiveStorage 等の Rails 標準機能は自動生成される migaration ファイルをそのまま使用する

```bash
 docker-compose exec app bundle exec rails db:migrate
```

# テスト

- RSpec
  - simplecov で網羅率チェック

```bash
 docker-compose exec app bundle exec rspec
```

# コード品質

- Rubocop

```bash
docker-compose exec app bundle exec rubocop
```

# 開発フロー

## 1. develop ブランチからチェックアウト

### ブランチ名の統一

`prefix/#issue-number/branch-name`

#### 例

`feature/#10/add-hoge-to-fuga`

## 2. コミット

### コミットメッセージの統一

[git-cz](https://github.com/streamich/git-cz)をインストールしておく。

コミット時に、`git commit -m`の代わりに

```bash
git cz
```

で適切な prefix を選択してコミットメッセージを入力する。

コミットメッセージの末尾に issue 番号を振っておくと自動で issue と紐づく。

#### 例

`chore: update README.md #1`

### Overcommit

コミット時に Overcommit が Rubocop をチェックするのでそこでコケたら修正してコミット

## 3. develop へ PR

Github workflow で Rubocop, RSpec(coverage), Brakeman をチェックしているので問題なければマージ

## 4. develop から main へマージ

## デバッグ

Docker 上でデバッグするため、まず

```bash
docker compose up
```

でコンテナを起動し、別ターミナルで

```bash
docker attach virtual_credit_rails_api_app
```

で Docker へコンテナをアタッチすると pry でデバッグできるようになる

# ステータスコード備忘録

## 200 系

### 200

- 基本 GET 時のリクエストが成功したとき
- 該当のリソースを返却する

### 201

- POST が成功した時
- 該当のリソースを返却する

### 204

- POST, PUT, DELETE が成功した時
- 返却値すべきコンテンツがない場合

## 400 系

### 400

- クライアント側のリクエスト方式が間違っている場合
- パラメーターの型が違う / 必須パラメーター不足 / etc

### 401

- そのまま認証エラー

### 403

- アクセス制限
- 純粋に制限されているページ / 他社向けのページ / etc

### 404

- 純粋にリソースが見つからない場合
- 存在しない id 等

### 409

- 単一であるべきリソースを複数作成しようとした場合

### 422

- クライアントからのリクエストは正しいがバックエンドが処理が失敗した場合
- 基本的にはバリデーションエラーはこれで返す
- 例外を発火させるようにコミットすると、自動的にキャッチしてフォーマットされたものが 422 で返るようになっている

## 500 系

### 500

- 上で処理できないものは最上位 Exception として 500 でキャッチしている
