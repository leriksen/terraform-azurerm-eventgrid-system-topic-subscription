output "id" {
  value       = azurerm_eventgrid_system_topic_event_subscription.this.id
  description = "Resource ID of the event subscription."
}

output "name" {
  value       = azurerm_eventgrid_system_topic_event_subscription.this.name
  description = "Name of the event subscription."
}

output "system_topic_principal_id" {
  value       = length(azapi_resource_action.system_topic_identity) > 0 ? one(values(azapi_resource_action.system_topic_identity)).output.identity.principalId : null
  description = "Principal ID of the SystemAssigned managed identity on the system topic, when system_topic_managed_identity_enabled is true."
  sensitive   = true
}
