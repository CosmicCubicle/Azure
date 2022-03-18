output "vmEndpoint" {
  value = module.vm.ip
}
output "username" {
  value = local.vm.user_name
}
