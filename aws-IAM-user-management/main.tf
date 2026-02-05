data "aws_caller_identity" "current" {}

output "account_id" {
    value = data.aws_caller_identity.current.account_id
  
}

locals {
  users = csvdecode(file("users.csv"))
}

output "user_names" {
    value = [for user in local.users : "${user.first_name} ${user.last_name}"]
  
}

# Create IAM users
resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
  path = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
  }
}

# Create login profiles for IAM users

resource "aws_iam_user_login_profile" "users" {
     for_each = aws_iam_user.users
        user = each.value.name
        password_reset_required = true

        lifecycle {
            ignore_changes = [password_reset_required, password_length]
        }
  
}

# Attach policies to IAM users

resource "aws_iam_user_policy_attachment" "users" {
  for_each = aws_iam_user.users

  user       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

output "user_passwords" {
  value = {
    for user, profile in aws_iam_user_login_profile.users :
    user => "Password created - user must reset on first login"
  }
  sensitive = true
}



resource "aws_iam_group_policy_attachment" "s3_for_manager_groups" {

    for_each = aws_iam_group.managers
    
    group      = each.key
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  
}

resource "aws_iam_policy" "require_mfa" {
  name        = "RequireMFA"
  description = "Deny access unless MFA is enabled"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowUsersToManageMFA"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "iam:DeactivateMFADevice"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyAllExceptListedIfNoMFA"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "iam:DeactivateMFADevice",
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}


