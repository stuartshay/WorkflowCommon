module "security_group_jumpbox" {
  source = "../security-group"

  name   = var.name
  vpc_id = var.vpc_id

  cidr_ingresses = {
    "ssh" = {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    "vnc" = {
      from_port   = 5901
      to_port     = 5901
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.name

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [module.security_group_jumpbox.id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.jumpbox.name

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.root_volume_size
    },
  ]
}

resource "aws_eip" "this" {
  instance = module.ec2.id
  vpc      = true
}

resource "aws_iam_instance_profile" "jumpbox" {
  name = var.name
  role = aws_iam_role.jumpbox.name
}

resource "aws_iam_role" "jumpbox" {
  name = "${var.name}-instance"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "efs" {
  role       = aws_iam_role.jumpbox.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

resource "null_resource" "my_instance" {
  triggers = {
    instance_ids = module.ec2.id
    public_ip    = aws_eip.this.public_ip
  }

  provisioner "remote-exec" {
    connection {
      host        = aws_eip.this.public_ip
      user        = var.ansible_ssh_user
      private_key = file(var.ansible_ssh_private_key_path)
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/../../../ansible/jumpbox/tasks.yml -e 'app_env=${var.app_env}' -e 'vnc_default_password=${var.vnc_default_password}' -u ${var.ansible_ssh_user} --private-key ${var.ansible_ssh_private_key_path} -i '${aws_eip.this.public_ip},' -vv"
  }
}
