# Cognito のローカル環境構築

## 概要

Cognito をローカル環境で動作させる環境と、ユーザー作成 -> 認証まで実施するスクリプトを作成したので、備忘録用としてメモする。

## 動作確認環境

- macOS Ventura 13.4
- Docker version 24.0.2
- Docker Compose version v2.18.1

## 使用方法

ユーザー認証をし、トークンを取得するまでの使用方法を以下に記載する。

1. 以下のコマンドを実行し、.env ファイルを作成する。
   ```
   cp -i .env.example .env
   ```
1. `.env` ファイルを任意な値に編集する。

1. Docker compose を起動する。

   ```
   docker-compose up -d
   ```

1. バッシュコマンドを実行し、ユーザーの登録およびトークンを取得する。
   ```
   sh bash/create-user-pool.sh
   ```
   上記のコマンドを実行することで、以下の操作が実施される。
   - ユーザープールの作成
   - アプリクライアントの作成
   - 管理者ユーザーの作成
   - 管理者ユーザーのパスワード設定
   - ユーザー認証
