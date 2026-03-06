module "bastion" {
  source = "./modules/bastion"

  name_prefix       = var.project_name
  instance_type     = var.bastion_instance_type
  allowed_ssh_cidrs = var.bastion_allowed_ssh_cidrs
  ssh_public_keys   = var.bastion_ssh_public_keys

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
  db_sg_id         = module.vpc.db_sg_id

  iam_instance_profile_name = data.aws_iam_instance_profile.ssm_secret_manager.name
}