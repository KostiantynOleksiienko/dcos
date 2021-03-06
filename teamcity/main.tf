provider "aws" {
  region = "${var.AWS_REGION}"
}

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.2.10"

  cluster_name        = "tf-ci-${var.teamcity.build.id}-"
  cluster_name_random_string = true
  
  ssh_public_key_file = "id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  custom_dcos_download_path = "${var.ONPREM_INSTALLER_URL}"

  dcos_instance_os    = "centos_7.5"
  bootstrap_instance_type = "${var.ONPREM_AWS_INSTANCE_SIZE}"
  masters_instance_type  = "${var.ONPREM_AWS_INSTANCE_SIZE}"
  private_agents_instance_type = "${var.ONPREM_AWS_INSTANCE_SIZE}"
  public_agents_instance_type = "${var.ONPREM_AWS_INSTANCE_SIZE}"
  #AVAILABILITYZONES

  dcos_calico_network_cidr = "172.17.0.0/16"
  dcos_variant = "open"

  providers = {
    aws = "aws"
  }

  tags = {
    build_id = "${var.teamcity.build.id}"
    build_type_id = "${var.system.teamcity.buildType.id}"
  }
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
