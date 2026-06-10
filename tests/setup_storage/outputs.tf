output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "deadletter_container_name" {
  value = azurerm_storage_container.deadletter.name
}

output "queue_name" {
  value = azurerm_storage_queue.this.name
}
