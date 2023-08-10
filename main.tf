provider "aws" {
  region = "eu-north-1"  
}


resource "aws_instance" "windows_vm" {
  ami           = "ami-05c49a63441937596"  # AMI de Windows apropiada para tu región
  instance_type = "t2.micro"          
  key_name      = "dev"    
  # El subnet_id lo puedes consultar en tu consola de AWS,
  # pero tiene una forma mas o menos así: "subnet-05058f429dght70ga"
  subnet_id="x"
  vpc_security_group_ids = [aws_security_group.allow_rdp.id]
  tags = {
    Name = "windows_vm"
  }
}

resource "aws_security_group" "allow_rdp" {
  name_prefix = "allow_rdp"
  # El vpc id lo puedes consultar en tu consola de AWS,
  # pero tiene una forma mas o menos así: "vpc-01e2655rhdb11603a"
  vpc_id="aaaa"   

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
from_port=0
to_port=0
protocol="-1"
cidr_blocks=["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_rdp"
  }
}

resource "aws_volume_attachment" "windows_disk" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.windows_volume.id
  instance_id = aws_instance.windows_vm.id
}

resource "aws_ebs_volume" "windows_volume" {
  availability_zone = "eun1-az2"  
  size             = 5
  type             = "gp2"
}