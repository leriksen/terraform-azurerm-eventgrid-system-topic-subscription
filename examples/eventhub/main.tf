provider "azurerm" {
  features {}
}

module "subscription" {
  source = "../.."

  name                = "my-eventhub-subscription"
  system_topic_name   = "my-system-topic"
  resource_group_name = "my-resource-group"

  eventhub_endpoint_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.EventHub/namespaces/my-ns/eventhubs/my-hub"

  advanced_filters = {
    string_contains = [
      { key = "data.api", values = ["PutBlob", "PutBlockList"] }
    ]
  }

  storage_blob_dead_letter_destination = {
    storage_account_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mydlq"
    storage_blob_container_name = "dead-letters"
  }
}
