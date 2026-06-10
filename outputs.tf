output "id" {
  value       = azurerm_eventgrid_system_topic_event_subscription.this.id
  description = "Resource ID of the event subscription."
}

output "name" {
  value       = azurerm_eventgrid_system_topic_event_subscription.this.name
  description = "Name of the event subscription."
}
