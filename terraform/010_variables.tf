variable "tenant_id" {
    description = "ID do tenant"
}

variable "plan_id" {
    description = "ID do plano de teste"
}

variable "plan_name" {
    description = "Nome do plano de teste"
}

variable "plan_execution_id" {
    description = "ID da execucao do plano de teste"
}

variable "plan_execution_author" {
    description = "Author da execucao do plano"
}

variable "search_host" {
    description = "search_host"
}

variable "search_user" {
    description = "search_user"
}

variable "search_pass" {
    description = "search_pass"
}


variable "region" {
  description = "Region"
  default= "us-east-1"
}

variable "ami_name" {
    description = "Nome da ami"
    default = "gold-jmeter-loadtester"
}

variable "instance_type_master" {
    description = "Tipo da instancia master"
    default = "c5n.xlarge"
}

variable "instance_type_node" {
    description = "Tipo das instancias nodes"
    default = "c5n.9xlarge"
}

variable "count_nodes" {
    description = "Numero nodes do cluster de carga"
    default = "6"
}

variable "vpc_id" {
    description = "Vpc id"
    default = "vpc-09c9ae138aebc3057"
}

variable "assume_role_enable" {
    default = false
}

variable "assume_role_arn" {
    description = "ARN do role"
    default = "arn:aws:iam::123456789012:role/jmeter-role"
}

variable "assume_role_external_id" {
    description = "External id do role"
    default = "123456789012"
}