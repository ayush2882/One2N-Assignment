resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "s3-access-policy"
  role   = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:*"]
      Resource = ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
    }]
  })
}

resource "aws_instance" "flask_ec2_instance" {
  ami           = "ami-078264b8ba71bc45e"
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
  user_data = "${file("user-data.sh")}"
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  tags = {
    Name = "Flask-server"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-access-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow HTTP access to Flask app"
  
  ingress {
    description = "Flask"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.flask_ec2_instance.public_ip
}
