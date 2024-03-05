resource "aws_elasticache_replication_group" "bad_example" {
         replication_group_id = "foo"
         replication_group_description = "my foo cluster"
         transit_encryption_enabled = false
         at_rest_encryption_enabled = false
         # transit_encryption_enabled = false
         # at_rest_encryption_enabled = false
} 

output "jenkins_terraform" {
  value = "running Terraform from Jenkins"
}
