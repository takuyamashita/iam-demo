##################
# vpc
##################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${local.project_name}-vpc"
  }

}

##################
# subnet
##################
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${local.project_name}-subnet-public-1a"
  }
}

##################
# route table
##################
resource "aws_route_table" "public_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${local.project_name}-public-1a-route-table"
  }
}

##################
# route table association
##################
resource "aws_route_table_association" "public_1a" {
  route_table_id = aws_route_table.public_1a.id
  subnet_id      = aws_subnet.public_1a.id
}

##################
# route
##################
resource "aws_route" "public_rt_igw" {
  route_table_id         = aws_route_table.public_1a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}

##################
# internet gateway
##################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${local.project_name}-igw"
  }
}

##################
# security group
##################
resource "aws_security_group" "app" {
  name   = "${local.project_name}-app-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${local.project_name}-app-security-group"
  }
}

##################
# security group rule
##################
resource "aws_security_group_rule" "out_tcp_443" {
  security_group_id = aws_security_group.app.id

  type        = "egress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "out_tcp_443_s3" {
  security_group_id = aws_security_group.app.id

  type            = "egress"
  protocol        = "tcp"
  from_port       = 443
  to_port         = 443
  prefix_list_ids = [data.aws_prefix_list.s3.id]
}
