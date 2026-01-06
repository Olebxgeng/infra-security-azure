package terraform

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_storage_account"
    resource.change.after.allow_blob_public_access == true
    msg := sprintf("Storage Account %s must not allow public blob access", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_linux_virtual_machine"
    not resource.change.after.admin_ssh_key  # Enforce key-based auth, no passwords
    msg := sprintf("VM %s must use SSH key auth, no passwords", [resource.address])
}