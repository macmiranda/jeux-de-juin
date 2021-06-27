provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}

resource "aws_iam_role" "prod-ci-role" {
  name               = "prod-ci-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "assume_prod-ci-role_policy" {
  name        = "prod-ci-policy"
  description = "Assume Role policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.prod-ci-role.arn
      },
    ]
  })
}

resource "aws_iam_user" "prod-ci-user" {
  name = "prod-ci-user"
}

resource "aws_iam_group" "prod-ci-group" {
  name = "prod-ci-group"
}
resource "aws_iam_group_membership" "prod-ci" {
  name = "prod-ci-membership"

  users = [
    aws_iam_user.prod-ci-user.name,
  ]

  group = aws_iam_group.prod-ci-group.name
}

resource "aws_iam_group_policy_attachment" "prod-ci" {
  group      = aws_iam_group.prod-ci-group.name
  policy_arn = aws_iam_policy.assume_prod-ci-role_policy.arn
}