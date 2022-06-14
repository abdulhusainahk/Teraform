module "main_vpc" {
  source               = "./Terraform-aws-vpc"
  cdr                  = var.cdr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tagtype              = var.tagtype
}

module "security_grp" {
  source        = "./Terraform-security-grp"
  tagtype       = var.tagtype
  vpc_id        = module.main_vpc.vpc_id
  ingress_rules = var.ingress_rules
  egresscdr     = var.egresscdr
}
module "main_public_subnet" {
  source="./Terraform-subnet"
  vpc_id= module.main_vpc.vpc_id
  cdr ="10.121.1.0/24"
  map_public_ip_on_launch= true
  az= "us-west-1a"
  tags={
    Name = "dev-public"
  }
}

resource "aws_key_pair" "main_auth" {
  key_name   = "mainkey"
  public_key = file("~/.ssh/main_key.pub")
}
module "route" {
  source="./Terraform-aws-route"
  vpc_id= module.main_vpc.vpc_id
  tag                    = var.tagtype  
  subnet_id       = module.main_public_subnet.id
}
module "main_node" {
  source                  = "./Terraform-aws-ec2"
  ami                     = data.aws_ami.main_ami.id                                     //
  instance_type           = var.instance_type                                            //
  az                      = var.startaz                                                  //
  cpu_core_count          = var.instance_type != "t2.micro" ? var.cpu_core_count : null  //
  cpu_threads_per_core    = var.cpu_core_count != null ? var.cpu_threads_per_core : null //
  key_name                = aws_key_pair.main_auth.id                                    //
  monitoring              = var.monitoring                                               //
  subnet_id               = module.main_public_subnet.id                             //
  vpc_security_group_ids  = [module.security_grp.sg_id]                                  //
  path                    = "./userdata.tpl"                                             //
  name                    = var.tagtype                                                  //
  instance_count          = var.instance_count                                           // 
  host_os                 = var.host_os                                                  //  
  enclave_options_enabled = var.enclave_options_enabled // Not applicable and should be disable for instance lower then t2.medium
  timeouts                = var.timeouts
  create_spot_instance = false
  tags = { //
    Terraform   = "true"
    Environment = "dev"
  }
}