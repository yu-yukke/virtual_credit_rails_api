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

# 各ポートへの割り当て

## 4000

- API

## 5432

- PostgresQL

## 5050

- pgadmin

## 8080

- Swagger UI

# マイグレーション

- ridgepole を採用

```bash
 docker-compose exec app bundle exec ridge:run
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
