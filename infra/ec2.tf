##################
# ec2
##################
resource "aws_instance" "app" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app.id]
  iam_instance_profile        = aws_iam_instance_profile.app.name

  tags = {
    Name    = "${var.project}-app"
    Project = "${var.project}"
  }
}