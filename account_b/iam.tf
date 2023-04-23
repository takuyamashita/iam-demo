##################
# i am role
##################
resource "aws_iam_role" "developer" {
  name               = "developer"
  assume_role_policy = data.aws_iam_policy_document.developer_trust_policy.json
}

##################
# iam trust policy
##################
data "aws_iam_policy_document" "developer_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::717305115395:user/yamada"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

##################
# iam role policy
##################
resource "aws_iam_role_policy_attachment" "create_lambda" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.create_lambda.arn
}

resource "aws_iam_policy" "create_lambda" {
  name   = "create-lambda"
  policy = data.aws_iam_policy_document.create_lambda.json
}

data "aws_iam_policy_document" "create_lambda" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "lambda:CreateFunction"
    ]
    resources = ["*"]
  }
}