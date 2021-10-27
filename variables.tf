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

variable "split_data_mass_between_nodes" {
    type = object({
        enable = bool
        data_mass_filename = string
    })
    default = {
        enable = true
        data_mass_filename = "../plan/data/data.csv"
    }
    description = "Split data mass between nodes"
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

variable "nodes_size" {
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

variable "ssh_cidr_ingress_block" {
    description = "SSH user for the leader"
    type        = list
    default = ["0.0.0.0/0"]
}

variable "ssh_export_pem" {
    type = bool
    default = true
}

variable "auto_setup" {
    description = "Install and configure instances Amazon Linux2 with JMeter and Taurus"
    type = bool
    default = true
}

variable "jmeter_version" {
    description = "JMeter version"
    type = string
    default = "5.4.1"
}

variable "leader_jvm_args" {
    description = "JVM Leader JVM_ARGS"
    type = string
    default = " -Xms2g -Xmx4g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 "
}

variable "nodes_jvm_args" {
    description = "JVM Nodes JVM_ARGS"
    type = string
    default = "-Xms4g -Xmx8g -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 -Dnashorn.args=--no-deprecation-warning -XX:+HeapDumpOnOutOfMemoryError "
}

variable "taurus_version" {
    description = "Taurus version"
    type = string
    default = "1.16.0"
}