output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_arn" {
    description = "User ARN"
    value = aws_iam_user.prod-ci-user.arn
}

output "group_arn" {
    description = "Group ARN"
    value = aws_iam_group.prod-ci-group.arn
}

output "role_arn" {
    description = "Role ARN"
    value = aws_iam_role.prod-ci-role.arn
}