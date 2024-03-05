resource "aws_elasticache_replication_group" "good_example" {
         replication_group_id = "foo"
         replication_group_description = "my foo cluster"
         transit_encryption_enabled = true
         at_rest_encryption_enabled = true
         # transit_encryption_enabled = false
         # at_rest_encryption_enabled = false
} 

output "jenkins_terraform" {
  value = "running Terraform from Jenkins"
}
