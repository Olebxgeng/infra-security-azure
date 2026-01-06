package terraform

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_storage_account"
    not resource.change.after.enable_https_traffic_only
    msg := sprintf("Storage Account %s must enable HTTPS-only traffic (encryption)", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_linux_virtual_machine"
    not resource.change.after.encryption_at_host_enabled
    msg := sprintf("VM %s must have host encryption enabled", [resource.address])
}