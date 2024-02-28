FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# ワークディレクトリの設定
RUN mkdir /myapp
WORKDIR /myapp

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerを使ってGemをインストール
RUN bundle install

# プロジェクトのファイルをコンテナにコピー
COPY . /myapp

# ポート4000番を開放
EXPOSE 4000

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
