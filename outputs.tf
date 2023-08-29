output "vpc_id" {
    value = aws_vpc.my_vpc.id
}
output "subnet1_id" {
    value = aws_subnet.my_subnet1.id
}
output "subnet2_id" {
    value = aws_subnet.my_subnet2.id
}
