resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "wsi-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-public-rt"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.0.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-public-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-public-c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "private_a" {
  
}

resource "aws_eip" "private_b" {
  
}

resource "aws_eip" "private_c" {
   
}

resource "aws_nat_gateway" "private_a" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_a.id
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "wsi-nat-a"
  }
}

resource "aws_nat_gateway" "private_b" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_b.id
  subnet_id = aws_subnet.public_b.id

  tags = {
    Name = "wsi-nat-b"
  }
}

resource "aws_nat_gateway" "private_c" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.private_c.id
  subnet_id = aws_subnet.public_c.id

  tags = {
    Name = "wsi-nat-c"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-private-a-rt"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-private-b-rt"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-private-c-rt"
  }
}

resource "aws_route" "private_a" {
  route_table_id = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_a.id
}

resource "aws_route" "private_b" {
  route_table_id = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_b.id
}

resource "aws_route" "private_c" {
  route_table_id = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_c.id
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "wsi-private-a"
    "karpenter.sh/discovery" = "wsi-cluster"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "wsi-private-b"
    "karpenter.sh/discovery" = "wsi-cluster"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "wsi-private-c"
    "karpenter.sh/discovery" = "wsi-cluster"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}


resource "aws_route_table" "protected" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wsi-protected-rt"
  }
}

resource "aws_subnet" "protected_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "wsi-protected-a"
  }
}

resource "aws_subnet" "protected_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.7.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "wsi-protected-b"
  }
}

resource "aws_subnet" "protected_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.8.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "wsi-protected-c"
  }
}

resource "aws_route_table_association" "protected_a" {
  subnet_id = aws_subnet.protected_a.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected_b" {
  subnet_id = aws_subnet.protected_b.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected_c" {
  subnet_id = aws_subnet.protected_c.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_eip" "bastion" {
  
  instance = aws_instance.bastion.id
  associate_with_private_ip = aws_instance.bastion.private_ip
}

resource "aws_security_group" "alb" {
  name = "wsi-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }
}

resource "aws_security_group" "bastion" {
  name = "wsi-bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "2220"
    to_port = "2220"
  }

  egress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  instance_type = "c5.large"
  subnet_id = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion.id]
  
  ami = "ami-094efa69961183fa4"

  tags = {
    Name = "wsi-bastion"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum install -y jq docker git
    usermod -aG docker ec2-user
    systemctl enable --now docker
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    echo "Port 2220" >> /etc/ssh/sshd_config
    echo "ec2-user:Skills2024**" | chpasswd
    systemctl restart sshd
    ARCH=amd64
    PLATFORM=$(uname -s)_$ARCH
    curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
    tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
    mv /tmp/eksctl /usr/local/bin
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    useradd -m read01
    useradd -m admin01
    echo "read01:Skills2024**" | chpasswd
    echo "admin01:Skills2024**" | chpasswd
  EOF
}