#!/bin/bash

USER_POOL_ID="YOUR_COGNITO_USER_POOL_ID"

declare -A USERS
USERS["team_member_1"]="user1@example.com"
USERS["team_member_2"]="user2@example.com"
USERS["team_member_3"]="user3@example.com"
USERS["team_member_4"]="user4@example.com"

for username in "${!USERS[@]}"; do
  email=${USERS[$username]}
  echo "Creating Cognito user: $username ($email)..."
  
  aws cognito-idp admin-create-user \
    --user-pool-id "$USER_POOL_ID" \
    --username "$username" \
    --temporary-password "TempPassword123!" \
    --user-attributes Name=email,Value="$email"

  aws cognito-idp admin-add-user-to-group \
    --user-pool-id "$USER_POOL_ID" \
    --username "$username" \
    --group-name Admins

  echo "User $username added to Cognito and assigned to Admins group."
done

echo "All users created successfully!"
