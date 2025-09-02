output "vpc_id" {
  value = aws_vpc.sunil_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.sunil_va_public.id
}

output "private_subnet_b_id" {
  value = aws_subnet.sunil_va_private_b.id
}

output "private_subnet_c_id" {
  value = aws_subnet.sunil_va_private_c.id
}
