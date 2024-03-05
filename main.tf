resource "aws_elasticache_replication_group" "pass_example" {
  replication_group_id           = "foo"
  transit_encryption_enabled     = true
  at_rest_encryption_enabled     = true
}

output "jenkins_terraform" {
  value = "running Terraform from Jenkins"
}
