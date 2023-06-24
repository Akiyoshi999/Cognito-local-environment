#!/bin/bash

# 設定ファイルから変数を取得
source ./.env

# ユーザープールの作成
USER_POOL_ID=$(
  aws cognito-idp create-user-pool \
    --pool-name MyUserPool \
    --query UserPool.Id \
    --output text \
    --endpoint-url ${ENDPOINT_URL} \
)

# アプリクライアントの作成
CLIENT_ID=$(
  aws cognito-idp create-user-pool-client \
    --client-name MyUserPoolClient \
    --user-pool-id ${USER_POOL_ID} \
    --output text \
    --query UserPoolClient.ClientId \
    --endpoint-url ${ENDPOINT_URL} \
)
  
# 管理者ユーザーの作成
User=$(
  aws cognito-idp admin-create-user \
    --user-pool-id ${USER_POOL_ID} \
    --username ${COGNITO_USER_NAME} \
    --user-attributes Name=email,Value=${COGNITO_USER_EMAIL} Name=email_verified,Value=true \
    --message-action SUPPRESS \
    --endpoint-url ${ENDPOINT_URL} \
)

# 管理者ユーザーのパスワード設定
aws cognito-idp admin-set-user-password \
  --user-pool-id ${USER_POOL_ID} \
  --username ${COGNITO_USER_NAME} \
  --password ${COGNITO_USER_PASSWORD} \
  --permanent \
  --endpoint-url ${ENDPOINT_URL} 

# ユーザーリストおよび書くユーザーステータスの確認
# 出力結果のユーザーステータスに"CONFIRMED"があればOK
aws cognito-idp list-users \
  --user-pool-id ${USER_POOL_ID} \
  --query Users[0].[Username,UserStatus] \
  --endpoint-url ${ENDPOINT_URL}


# ユーザー認証
# アクセストークンを払い出す
aws cognito-idp admin-initiate-auth \
  --user-pool-id ${USER_POOL_ID} \
  --client-id ${CLIENT_ID} \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters "USERNAME=${COGNITO_USER_NAME},PASSWORD=${COGNITO_USER_PASSWORD}" \
  --endpoint-url ${ENDPOINT_URL} \
  --query "AuthenticationResult.IdToken" 

