variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "source_resource_id" {
  type = string
}

variable "topic_type" {
  type    = string
  default = "Microsoft.Storage.StorageAccounts"
}