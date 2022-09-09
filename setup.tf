locals {

  auto_setup                 = var.auto_setup
  leader_custom_setup_base64 = var.leader_custom_setup_base64
  nodes_custom_setup_base64  = var.nodes_custom_setup_base64

  full_leader_user_data_base64 = base64encode(
    templatefile(
      "${path.module}/scripts/entrypoint.leader.full.sh.tpl",
      {
        JVM_ARGS = var.leader_jvm_args
        LOCUST_VERSION = var.locust_version
      }
    )
  )

  full_nodes_user_data_base64 = base64encode(
    templatefile(
      "${path.module}/scripts/entrypoint.node.full.sh.tpl",
      {
        JVM_ARGS = var.nodes_jvm_args
        LOCUST_VERSION = var.locust_version
      }
    )
  )

  light_nodes_user_data_base64 = base64encode(
    templatefile(
      "${path.module}/scripts/entrypoint.node.full.sh.tpl",
      {
        JVM_ARGS = var.nodes_jvm_args
        LOCUST_VERSION = var.locust_version
      }
    )
  )

  leader_user_data_base64 = (
    local.auto_setup ?
    local.full_leader_user_data_base64 :
    local.leader_custom_setup_base64 != "" ?
    local.leader_custom_setup_base64 :
    ""
  )

  nodes_user_data_base64 = (
    local.auto_setup ?
    local.full_nodes_user_data_base64 :
    local.nodes_custom_setup_base64 != "" ?
    local.nodes_custom_setup_base64 :
    ""
  )




}
