output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.id, "")
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [for s in aws_subnet.public : s.id]
}
