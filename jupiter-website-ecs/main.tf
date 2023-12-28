#configure aws provider
provider "aws" {
  region  = var.region
  profile = "terraform-user"
}

#create vpc
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

#create nat gateway
module "nat_gateway" {
  source                     = "../modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

#craete security group
module "security_group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

#create ecs task execution iam role 
module "ecs_task_execution_role" {
  source       = "../modules/ecs-task-exec-role"
  project_name = module.vpc.project_name
}

#create ssl certificate 
module "acm" {
  source            = "../modules/acm"
  domain_name       = var.domain_name
  alternative_names = var.alternative_names
}

#create application load balancer 
module "application_load_balancer" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn
}

#create ecs 
module "ecs" {
  source                    = "../modules/ecs"
  project_name              = module.vpc.project_name
  ecs_task_exec_role_arn    = module.ecs_task_execution_role.ecs_task_exec_role_arn
  container_image           = var.container_image
  region                    = module.vpc.region
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  ecs_security_group_id     = module.security_group.ecs_security_group_id
  alb_target_group_arn      = module.application_load_balancer.alb_target_group_arn
}

#create auto scaling group
module "auto_sg" {
  source           = "../modules/asg"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
}

#create route 53 
module "route-53" {
  source       = "../modules/route-53"
  domain_name  = module.acm.domain_name
  record_name  = var.record_name
  alb_dns_name = module.application_load_balancer.alb_dns_name
  alb_zone_id  = module.application_load_balancer.alb_zone_id
}

#create the output website url 
output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}