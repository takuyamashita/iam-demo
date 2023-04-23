##################
# instance profile
##################
resource "aws_iam_instance_profile" "app" {
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}

##################
# i am role
##################
resource "aws_iam_role" "app_iam_role" {
  name               = "${local.project_name}-app-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

##################
# iam assume policy
##################
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

##################
# iam user
##################
resource "aws_iam_user" "yamada" {
  name = "yamada"
}

resource "aws_iam_user_policy" "yamada_policy" {
  user = aws_iam_user.yamada.name
  policy = data.aws_iam_policy_document.yamada_policy.json
}

data "aws_iam_policy_document" "yamada_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeImages",
      "sts:AssumeRole"
    ]
    resources = [ "*" ]
  }
}
