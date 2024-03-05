# resource "aws_elasticache_replication_group" "pass_example" {
#   replication_group_id           = "foo"
#   transit_encryption_enabled     = true
#   at_rest_encryption_enabled     = true
# }

# output "jenkins_terraform" {
#   value = "running Terraform from Jenkins"
# }

# 잘못된 VPC CIDR 블록
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/8" # 잘못된 CIDR 블록 형식
}

# 잘못된 인터넷 게이트웨이 구성
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id # VPC가 생성되지 않았거나, 존재하지 않는 VPC에 대한 참조
}

# 부적절한 서브넷 구성
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24" # VPC CIDR 범위 밖의 CIDR 블록
}

# 잘못된 보안 그룹 구성
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서의 접근을 허용하는 것은 보안 상 위험할 수 있음
  }
}
