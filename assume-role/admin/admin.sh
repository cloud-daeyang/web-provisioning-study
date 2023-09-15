#!/bin/bash
aws iam create-user --user-name admin01
aws iam create-policy --policy-name admin-policy --policy-document file://admin-role-policy.json
aws iam create-role --role-name admin --assume-role-policy-document file://admin-role-trust-policy.json
aws iam attach-role-policy --role-name admin --policy-arn arn:aws:iam::635867519280:policy/admin-role-policy
aws iam attach-user-policy --user-name admin01 --policy-arn arn:aws:iam:635867519280:policy/admin-role-policy
aws iam create-access-key --user-name admin01

# admin01 access key & secret key 입력
aws configure --profile admin01

creds=$(aws sts assume-role --role-arn arn:aws:iam::635867519280:role/admin --role-session-name admin-session --profile admin01)
export AWS_ACCESS_KEY_ID=$(echo $creds | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $creds | jq -r '.Credentials.SessionToken')