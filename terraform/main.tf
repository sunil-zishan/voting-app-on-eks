# VPC
resource "aws_vpc" "sunil_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "sunil-vote-app-vpc"
  }
}

# Subnets
resource "aws_subnet" "sunil_va_public" {
  vpc_id                  = aws_vpc.sunil_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "sunil-va-public"
  }
}

resource "aws_subnet" "sunil_va_private_b" {
  vpc_id            = aws_vpc.sunil_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "sunil-va-private-b"
  }
}

resource "aws_subnet" "sunil_va_private_c" {
  vpc_id            = aws_vpc.sunil_vpc.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "sunil-va-private-c"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "sunil_igw" {
  vpc_id = aws_vpc.sunil_vpc.id
  tags = {
    Name = "sunil-va-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sunil_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sunil_igw.id
  }
  tags = {
    Name = "sunil-va-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.sunil_va_public.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway Setup
resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "sunil_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.sunil_va_public.id
  tags = {
    Name = "sunil-va-nat"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.sunil_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sunil_nat.id
  }
  tags = {
    Name = "sunil-va-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.sunil_va_private_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_c" {
  subnet_id      = aws_subnet.sunil_va_private_c.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Groups
resource "aws_security_group" "frontend_sg" {
  name        = "sunil-va-frontend"
  description = "Allow HTTP/HTTPS"
  vpc_id      = aws_vpc.sunil_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.ssh_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sunil-VA-Frontend"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "sunil-va-backend"
  description = "Allow Redis access from frontend"
  vpc_id      = aws_vpc.sunil_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.ssh_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sunil-VA-Backend"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "sunil-va-db"
  description = "Allow Postgres access from backend"
  vpc_id      = aws_vpc.sunil_vpc.id
  
  ingress {
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  security_groups = [
    aws_security_group.backend_sg.id,
    aws_security_group.frontend_sg.id
    ]
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.ssh_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sunil-VA-DB"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "sunil-va-redis"
  description = "Allow Redis access from backend"
  vpc_id      = aws_vpc.sunil_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sunil-VA-Redis"
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "sunil-va-ssh"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.sunil_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sunil-VA-SSH"
  }
}


# EC2 Instances
resource "aws_instance" "vote_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.sunil_va_public.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  tags = {
    Name = "sunil-vote-app"
  }
}

resource "aws_instance" "result_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.sunil_va_public.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  tags = {
    Name = "sunil-result-app"
  }
}

resource "aws_instance" "worker_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.sunil_va_private_b.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags = {
    Name = "sunil-worker-app"
  }
}

resource "aws_instance" "redis_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.sunil_va_private_b.id
  vpc_security_group_ids = [
    aws_security_group.backend_sg.id,
    aws_security_group.redis_sg.id
  ]
  tags = {
    Name = "sunil-va-redis"
  }
}

resource "aws_instance" "postgres_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.sunil_va_private_c.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  tags = {
    Name = "sunil-va-db"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.sunil_va_public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh_sg.id]
  tags = {
    Name = "sunil-va-bastion"
  }
}
