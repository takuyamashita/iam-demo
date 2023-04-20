##################
# i am role
##################
resource "aws_iam_role" "developer" {
  name               = "${local.project_name}-iam-role-developer"
  assume_role_policy = data.aws_iam_policy_document.developer_assume_role.json

  tags = {
    Name    = "${local.project_name}-iam-role-developer"
  }
}

##################
# iam assume policy
##################
data "aws_iam_policy_document" "developer_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:user/my-user"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.developer.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
