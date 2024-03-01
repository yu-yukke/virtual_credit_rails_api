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

## 3. develop へ PR

Github workflow で Rubocop, RSpec(coverage), Brakeman をチェックしているので問題なければマージ

## 4. develop から main へマージ
