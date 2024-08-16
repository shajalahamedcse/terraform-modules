resource "aws_instance" "mongodb" {
  for_each               = var.mongodb_instance_setting
  ami                    = var.ami_id #Amazon Linux 2 AMI (HVM)
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = var.monitoring
  ebs_optimized          = true
  vpc_security_group_ids = ["${module.security_group_mongodb.security_group_id}"]
  subnet_id              = each.value
  user_data              = file("${path.module}/user_data_mongodb_${each.key}.conf")
  iam_instance_profile   = var.iam_role
  tags                   = merge({ "Name" : "mongodb-${var.tags["Environment"]}-${each.key}" }, var.tags)
}

module "security_group_mongodb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  name                     = "mongodb-${var.tags["Environment"]}-sg"
  description              = "Terraformed security group."
  vpc_id                   = var.vpc_id
  ingress_ipv6_cidr_blocks = []
  egress_ipv6_cidr_blocks  = []
  tags = var.tags
  ingress_with_self        = var.ingress_with_self
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id
  egress_with_cidr_blocks = var.egress_with_cidr_blocks
}

resource "aws_ebs_volume" "mongodb_data" {
  for_each          = toset(["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"])
  availability_zone = each.value
  size              = var.data_ebs_volume_size
  type              = var.type
  encrypted         = true
  tags = var.tags
}

# Comment out below code on first run since terraform cannnot predict the outputs of 
# instances and ebs, after they create instances and ebs, uncomment and run again to 
# attach ebs to instances
resource "aws_volume_attachment" "mongodb_data" {
  for_each = zipmap(
    [for i in aws_instance.mongodb : i.id], 
    [for i in aws_ebs_volume.mongodb_data : i.id]
  )
  device_name = "/dev/sdf"
  volume_id   = each.value
  instance_id = each.key
  depends_on = [
    aws_instance.mongodb,
    aws_ebs_volume.mongodb_data
  ]
}