# ── Required ────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "Name of the event subscription."
}

variable "system_topic_name" {
  type        = string
  description = "Name of the parent EventGrid system topic."
}

variable "system_topic_id" {
  type        = string
  default     = null
  description = "Resource ID of the parent EventGrid system topic. Required when system_topic_managed_identity_enabled is true."
}

variable "system_topic_managed_identity_enabled" {
  type        = bool
  default     = false
  description = "When true, patches the system topic via azapi to enable a SystemAssigned managed identity."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the system topic."
}

# ── Routing ──────────────────────────────────────────────────────────────────

variable "event_delivery_schema" {
  type        = string
  default     = "EventGridSchema"
  description = "EventGridSchema | CloudEventSchemaV1_0 | CustomInputSchema"

  validation {
    condition     = contains(["EventGridSchema", "CloudEventSchemaV1_0", "CustomInputSchema"], var.event_delivery_schema)
    error_message = "Must be one of: EventGridSchema, CloudEventSchemaV1_0, CustomInputSchema."
  }
}

variable "included_event_types" {
  type        = list(string)
  default     = null
  description = "List of event types to include. null means all types."
}

variable "expiration_time_utc" {
  type        = string
  default     = null
  description = "RFC3339 expiry timestamp, e.g. \"2026-12-31T00:00:00Z\"."
}

variable "labels" {
  type        = list(string)
  default     = null
  description = "Labels to attach to the subscription."
}

# ── Filtering ────────────────────────────────────────────────────────────────

variable "subject_filter" {
  type = object({
    subject_begins_with = optional(string)
    subject_ends_with   = optional(string)
    case_sensitive      = optional(bool, false)
  })
  default     = null
  description = "Simple subject prefix/suffix filter."
}

variable "advanced_filters" {
  type = object({
    string_contains = optional(list(object({
      key    = string
      values = list(string)
    })))
    string_begins_with = optional(list(object({
      key    = string
      values = list(string)
    })))
    string_ends_with = optional(list(object({
      key    = string
      values = list(string)
    })))
    string_in = optional(list(object({
      key    = string
      values = list(string)
    })))
    string_not_in = optional(list(object({
      key    = string
      values = list(string)
    })))
    number_greater_than = optional(list(object({
      key   = string
      value = number
    })))
    number_less_than = optional(list(object({
      key   = string
      value = number
    })))
    bool_equals = optional(list(object({
      key   = string
      value = bool
    })))
  })
  default     = {}
  description = "Advanced filter conditions. All fields are optional."
}

# ── Delivery endpoints ────────────────────────────────────────────────────────
# Exactly one endpoint must be configured across all endpoint variables.

variable "azure_function_endpoint" {
  type = object({
    function_id                       = string
    max_events_per_batch              = optional(number)
    preferred_batch_size_in_kilobytes = optional(number)
  })
  default     = null
  description = "Deliver to an Azure Function."
}

variable "storage_queue_endpoint" {
  type = object({
    storage_account_id                    = string
    queue_name                            = string
    queue_message_time_to_live_in_seconds = optional(number)
  })
  default     = null
  description = "Deliver to a Storage Queue."
}

variable "webhook_endpoint" {
  type = object({
    url                               = string
    base_url                          = optional(string)
    max_events_per_batch              = optional(number)
    preferred_batch_size_in_kilobytes = optional(number)
    active_directory_tenant_id        = optional(string)
    active_directory_app_id_or_uri    = optional(string)
  })
  default     = null
  description = "Deliver via webhook."
}

variable "eventhub_endpoint_id" {
  type        = string
  default     = null
  description = "Resource ID of an Event Hub to deliver to."
}

variable "service_bus_queue_endpoint_id" {
  type        = string
  default     = null
  description = "Resource ID of a Service Bus Queue to deliver to."
}

variable "service_bus_topic_endpoint_id" {
  type        = string
  default     = null
  description = "Resource ID of a Service Bus Topic to deliver to."
}

variable "hybrid_connection_endpoint_id" {
  type        = string
  default     = null
  description = "Resource ID of a Hybrid Connection to deliver to."
}

# ── Retry & dead-letter ───────────────────────────────────────────────────────

variable "retry_policy" {
  type = object({
    max_delivery_attempts = number
    event_time_to_live    = number
  })
  default     = null
  description = "max_delivery_attempts (1–30) and event_time_to_live in minutes (1–1440)."
}

variable "dead_letter_identity" {
  type = object({
    type                   = string
    user_assigned_identity = optional(string)
  })
  default     = null
  description = "Managed identity used to authenticate dead-letter delivery. type = SystemAssigned | UserAssigned."
}

variable "storage_blob_dead_letter_destination" {
  type = object({
    storage_account_id          = string
    storage_blob_container_name = string
  })
  default     = null
  description = "Storage blob container for undeliverable events."
}

# ── Delivery identity & properties ───────────────────────────────────────────

variable "delivery_identity" {
  type = object({
    type                   = string
    user_assigned_identity = optional(string)
  })
  default     = null
  description = "Managed identity used to authenticate delivery. type = SystemAssigned | UserAssigned."
}

variable "delivery_properties" {
  type = list(object({
    header_name  = string
    type         = string
    value        = optional(string)
    source_field = optional(string)
    secret       = optional(bool)
  }))
  default     = []
  description = "Custom HTTP headers to include in delivered events."
}
