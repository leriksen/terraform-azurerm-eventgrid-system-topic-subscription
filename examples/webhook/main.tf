provider "azurerm" {
  features {}
}

module "subscription" {
  source = "../.."

  name                = "my-webhook-subscription"
  system_topic_name   = "my-system-topic"
  resource_group_name = "my-resource-group"

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted",
  ]

  subject_filter = {
    subject_begins_with = "/blobServices/default/containers/my-container"
  }

  webhook_endpoint = {
    url = "https://my-app.example.com/eventgrid"
  }

  retry_policy = {
    max_delivery_attempts = 10
    event_time_to_live    = 1440
  }
}
