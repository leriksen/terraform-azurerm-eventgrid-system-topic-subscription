provider "azurerm" {
  features {}
}

provider "azapi" {}

variables {
  resource_group_name = "rg-example"
  location            = "australiaeast"
}

run "storage_resources" {
  module {
    source = "./setup_storage"
  }
  command = apply

  variables {
    name                      = "sttftestegstsdev"
    deadletter_container_name = "deadletter"
    queue_name                = "events"
  }
}

run "system_topic" {
  module {
    source = "./setup_topic"
  }
  command = apply

  variables {
    name                   = "evgt-tftest-egsts"
    source_resource_id = run.storage_resources.storage_account_id
  }
}

run "subscription_with_managed_identity" {
  module {
    source = "./.."
  }
  command = apply

  variables {
    name                                  = "evgs-test-d950w309"
    system_topic_name                     = run.system_topic.system_topic_name
    system_topic_id                       = run.system_topic.system_topic_id
    system_topic_managed_identity_enabled = true
    storage_queue_endpoint = {
      storage_account_id = run.storage_resources.storage_account_id
      queue_name         = run.storage_resources.queue_name
    }
  }

  assert {
    condition     = output.name == var.name
    error_message = "Subscription name does not match the requested name."
  }

  assert {
    condition     = output.system_topic_principal_id != null
    error_message = "System topic managed identity principal ID is not populated."
  }
}
