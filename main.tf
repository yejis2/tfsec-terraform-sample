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


