output "VPCID" {
  value = aws_vpc.LCM_VPC.id
}
output "EC2AMI" {
  value = var.EC2.Ami
}
output "EC2Instancetype" {
  value = var.EC2.Instancetype
}
output "AuroraMaxValue" {
  value = var.Aurora.max_capacity
}
output "AuroraMinValue" {
  value = var.Aurora.min_capacity
}
