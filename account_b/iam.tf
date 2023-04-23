##################
# i am role
##################
resource "aws_iam_role" "developer" {
  name               = "developer"
  assume_role_policy = data.aws_iam_policy_document.developer_trust_policy.json
}

##################
# iam assume policy
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
