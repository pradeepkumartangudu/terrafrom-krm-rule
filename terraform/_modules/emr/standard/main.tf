#############################
# EMR
# This assumes that this cluster runs in a private subnet
#


##
variable "cluster_short_name" {}
##
variable "release_label" {
default="emr-5.10.0"
}
##
variable "applications" {
type="list"
default=["Hive","Pig"]
}
##
variable "termination_protection" {
default=false
}
##
variable "keep_job_flow_alive_when_no_steps" {
default=true
}
##
variable "ec2_subnetid" {}
##
variable "emr_mng_mstr_secgrps" {}
##
variable "emr_mng_slv_secgrps" {}
##
variable "emr_inst_profile" {}
##
variable "emr_srv_access_secgrps" {}
##
variable "sec_cfg_name" {}
##
variable "mstr_instance_type" {
default="m3.xlarge"
}
##
variable "core_instance_count" {
default=6
}
##
variable "core_instance_type" {
default="m3.xlarge"
}
##
variable "environment" {}
##
variable "costcenter" {}
##
variable "platform" {}
##
variable "appid" {}
##
variable "owner" {}
##
variable "aws_region" {}


##
variable "emr_service_role" {}
##
variable "emr_autoscaling_role" {}
##
variable "emr_log_uri" {}

###################################################################
resource "aws_emr_cluster" "emr-test-cluster" {
  name          = "${var.environment}-${var.platform}-${var.appid}-${var.cluster_short_name}-${var.aws_region}"
  release_label = "${var.release_label}"
  applications  = "${var.applications}"

  termination_protection = "${var.termination_protection}"
  keep_job_flow_alive_when_no_steps = "${var.keep_job_flow_alive_when_no_steps}"

  ec2_attributes {
    subnet_id                         = "${var.ec2_subnetid}"
    emr_managed_master_security_group = "${var.emr_mng_mstr_secgrps}"
    emr_managed_slave_security_group  = "${var.emr_mng_slv_secgrps}"
    instance_profile                  = "${var.emr_inst_profile}"
    service_access_security_group     = "${var.emr_srv_access_secgrps}"
  }

  

  security_configuration   = "${var.sec_cfg_name}"

  master_instance_type = "${var.mstr_instance_type}"
  core_instance_type   = "${var.core_instance_type}"
  core_instance_count  = "${var.core_instance_count}"

  tags {
    appfamily     = "${var.platform}"
    environment   = "${var.environment}"
    appid         = "${var.appid}"
    costcenter    = "${var.costcenter}"
    owner         = "${var.owner}"
    
  }

  #bootstrap_action {
  #  path = "s3://elasticmapreduce/bootstrap-actions/run-if"
  #  name = "runif"
   # args = ["instance.isMaster=true", "echo running on master node"]
  #}

  log_uri="${var.emr_log_uri}"
  
  service_role = "${var.emr_service_role}"
  autoscaling_role = "${var.emr_autoscaling_role}"
}