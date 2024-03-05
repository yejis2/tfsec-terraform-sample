# resource "aws_elasticache_replication_group" "pass_example" {
#   replication_group_id           = "foo"
#   transit_encryption_enabled     = true
#   at_rest_encryption_enabled     = true
# }

# output "jenkins_terraform" {
#   value = "running Terraform from Jenkins"
# }

# VPC test
resource "aws_vpc" "vpc-test-jenkins" {
  cidr_block  = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-test-jenkins"
  }
}
