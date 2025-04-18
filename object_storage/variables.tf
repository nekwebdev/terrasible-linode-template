# ------------------------------------------------------------------------------
# author:      nekwebdev
# company:     monkeylab  
# license:     GPLv3
# description: variables for terraform k3s cluster
# ------------------------------------------------------------------------------

# project information
variable "project_name" {
  description = "Name prefix used for all resources [OPTIONAL]"
  type        = string
  default     = "server"
}

variable "linode_s3_region" {
  description = "Linode region for object storage, see https://api.linode.com/v4/regions [OPTIONAL]"
  type        = string
  default     = "us-lax"
}

# api credentials - all required
variable "linode_token" {
  description = "Linode API token with read/write access [REQUIRED]"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.linode_token) > 0
    error_message = "Linode API token must be provided."
  }
}
