######################
# MAIN CONFIGURATION #
######################
variable "name" {
    description = "Name of the provision"
    type = string
}

variable "region" {
    description = "Name of the region"
    type = string
    default = "us-east-1" 
}

variable "loadtest_dir_source" {
    description = "Path to the source loadtest directory"
    type = string
}

variable "loadtest_dir_destination" {
    description = "Path to the destination loadtest directory"
    type = string
    default = "/loadtest"
}

variable "loadtest_entrypoint" {
    description = "Path to the entrypoint command"
    type = string
    default = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
    #default = "jmeter -n -t -R \"{NODES_IPS}\" *.jmx  "
}

variable "executor" {
    description = "Executor of the loadtest"
    type = string
    default = "jmeter"
}

variable "vpc_id" {
    description = "Id of the VPC"
    type        = string
}

variable "subnet_id" {
    description = "Id of the subnet"
    type        = string
}

variable "leader_ami_id" {
    description = "Id of the AMI"
    type        = string
}

variable "leader_instance_type" {
    description = "Instance type of the cluster leader"
    type        = string
    default     = "t2.medium"
}

variable "leader_tags" {
    description = "Tags of the cluster leader"
    type        = map
}

variable "nodes_total" {
    description = "Total number of nodes in the cluster"
    type        = number
    default     = 2
}

variable "nodes_ami_id" {
    description = "Id of the AMI"
    type        = string
}

variable "nodes_intance_type" {
    description = "Instance type of the cluster nodes"
    type        = string
    default     = "t2.medium"
}

variable "nodes_tags" {
    description = "Tags of the cluster nodes"
    type        = map
}

variable "tags" {
    description = "Common tags"
    type        = map
}


##########################
# OPTIONAL CONFIGURATION #
##########################

variable "leader_associate_public_ip_address" {
    description = "Associate public IP address to the leader"
    type        = bool
    default = true
}

variable "nodes_associate_public_ip_address" {
    description = "Associate public IP address to the nodes"
    type        = bool
    default = true
}

variable "leader_monitoring" {
    description = "Enable monitoring for the leader"
    type        = bool
    default = true
}

variable "nodes_monitoring" {
    description = "Enable monitoring for the leader"
    type        = bool
    default = true
}

variable "ssh_user" {
    description = "SSH user for the leader"
    type        = string
    default = "ec2-user"
}


variable "ssh_cird_ingress_blocks" {
    description = "SSH user for the leader"
    type        = list
    default = ["0.0.0.0/0"]
}

variable "setup_instance" {
    description = "Install and configure instances Amazon Linux2 with JMeter and Taurus"
    type = bool
    default = true
}

variable "setup_instance_jmeter_version" {
    description = "JMeter version"
    type = string
    default = "5.4.1"
}

variable "setup_instance_leader_jmeter_opts" {
    description = "JMeter Leader OPTS"
    type = string
    default = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
}

variable "setup_instance_nodes_jmeter_opts" {
    description = "JMeter Nodes OPTS"
    type = string
    default = " -Xms12g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
}

variable "setup_instance_taurus_version" {
    description = "Taurus version"
    type = string
    default = "1.16.0"
}