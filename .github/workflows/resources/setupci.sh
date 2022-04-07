#!/bin/bash

# Mock an aws pubkey
ssh-keygen -q -t rsa -N '' -f ~/.ssh/aws <<<y

# Remove the requirement for AWS creds
cat > /tmp/AWS.mock << EOF
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
EOF

sed -i '4 e sed -n 1,6p /tmp/AWS.mock' src/infra/provider.tf
