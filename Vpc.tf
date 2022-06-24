

// create the virtual private network
resource "aws_vpc" "test-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "test-vpc"
  }
}
// create the internet gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "test-igw"
  }
}
// create a dedicated subnet
resource "aws_subnet" "test-subnet" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "test-subnet"
  }
}
// create a second dedicated subnet, 
resource "aws_subnet" "test-subnet-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "test-subnet-2"
  }
}
// create routing table which points to the internet gateway
resource "aws_route_table" "test-route" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
    Name = "test-igw"
  }
}
// associate the routing table with the subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test-route.id
}
// create a security group for ssh access 
resource "aws_security_group" "test-sg-ssh" {
  name        = "test-sg-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  // allow access to the internet
  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "test-sg-ssh"
  }
}
