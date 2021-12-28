######################
# MAIN CONFIGURATION #
######################
variable "name" {
  description = "Name of the provision"
  type        = string
}

variable "region" {
  description = "Name of the region"
  type        = string
  default     = "us-east-1"
}

variable "loadtest_dir_source" {
  description = "Path to the source loadtest directory"
  type        = string
}

variable "loadtest_dir_destination" {
  description = "Path to the destination loadtest directory"
  type        = string
  default     = "/loadtest"
}

variable "split_data_mass_between_nodes" {
  type = object({
    enable              = bool
    data_mass_filenames = list(string)
  })
  default = {
    enable              = false
    data_mass_filenames = []
  }
  description = "Split data mass between nodes"
}

variable "loadtest_entrypoint" {
  description = "Path to the entrypoint command"
  type        = string
  default     = "bzt -q -o execution.0.distributed=\"{NODES_IPS}\" *.yml"
  #default = "jmeter -n -t -R \"{NODES_IPS}\" *.jmx  "
}



variable "executor" {
  description = "Executor of the loadtest"
  type        = string
  default     = "jmeter"
}

variable "subnet_id" {
  description = "Id of the subnet"
  type        = string
}

variable "leader_ami_id" {
  description = "Id of the AMI"
  type        = string
  default     = ""
}

variable "leader_instance_type" {
  description = "Instance type of the cluster leader"
  type        = string
  default     = "c5n.large"
}

variable "leader_tags" {
  description = "Tags of the cluster leader"
  type        = map(any)
  default     = {}
}

variable "nodes_size" {
  description = "Total number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "nodes_ami_id" {
  description = "Id of the AMI"
  type        = string
  default     = ""
}

variable "nodes_instance_type" {
  description = "Instance type of the cluster nodes"
  type        = string
  default     = "c5n.xlarge"
}

variable "nodes_tags" {
  description = "Tags of the cluster nodes"
  type        = map(any)
  default     = {}
}
variable "tags" {
  description = "Common tags"
  type        = map(any)
  default     = {}
}

##########################
# OPTIONAL CONFIGURATION #
##########################

variable "leader_associate_public_ip_address" {
  description = "Associate public IP address to the leader"
  type        = bool
  default     = true
}

variable "nodes_associate_public_ip_address" {
  description = "Associate public IP address to the nodes"
  type        = bool
  default     = true
}

variable "leader_monitoring" {
  description = "Enable monitoring for the leader"
  type        = bool
  default     = true
}

variable "nodes_monitoring" {
  description = "Enable monitoring for the leader"
  type        = bool
  default     = true
}

variable "ssh_user" {
  description = "SSH user for the leader"
  type        = string
  default     = "ec2-user"
}

variable "ssh_cidr_ingress_blocks" {
  description = "SSH user for the leader"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "web_cidr_ingress_blocks" {
  description = "web for the leader"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "ssh_export_pem" {
  type    = bool
  default = false
}

variable "auto_setup" {
  description = "Install and configure instances Amazon Linux2 with JMeter and Taurus"
  type        = bool
  default     = true
}

variable "auto_execute" {
  description = "Execute Loadtest after leader and nodes available"
  type        = bool
  default     = true
}

variable "jmeter_version" {
  description = "JMeter version"
  type        = string
  default     = "5.4.1"
}

variable "leader_jvm_args" {
  description = "JVM Leader JVM_ARGS"
  type        = string
  default     = " -Xms2g -Xmx3g -Dnashorn.args=--no-deprecation-warning  "
}

variable "nodes_jvm_args" {
  description = "JVM Nodes JVM_ARGS"
  type        = string
  default     = "-Xms2g -Xmx4g -Dnashorn.args=--no-deprecation-warning"
}

variable "taurus_version" {
  description = "Taurus version"
  type        = string
  default     = "1.16.0"
}

variable "leader_custom_setup_base64" {
  description = "Custom bash script encoded in base64 to setup the leader"
  type        = string
  default     = ""
}

variable "nodes_custom_setup_base64" {
  description = "Custom bash script encoded in base64 to setup the nodes"
  type        = string
  default     = ""
}

variable "locust_plan_filename" {
  description = "Filename locust plan"
  type        = string
  default     = ""
}

variable "node_custom_entrypoint" {
  description = "Path to the entrypoint command"
  type        = string
  default     = ""
}

variable "plan_git_clone" {
  description = "Clone url from loadtest plan"
  type        = string
  default     = ""
}

variable "locust_replicas_per_node" {
  description = "Number of locust replicas per node. You should typically run one worker instance per processor core on the worker machines in order to utilize all their computing power."
  type        = number
  default     = 1
}

variable "locust_exporter" {
  type = object({
    enable              = bool
    data_mass_filenames = list(string)
  })
  default = {
    enable              = false
    data_mass_filenames = ["../plan/data/data.csv"]
  }
  description = "Export locust result to prometheus"
}
