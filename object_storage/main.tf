# ------------------------------------------------------------------------------
# Author:      nekwebdev
# Company:     monkeylab  
# License:     GPLv3
# Description: creates a linode object storage bucket to store terraform state and backups
# ------------------------------------------------------------------------------
terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2"
    }
  }
}

# linode provider
provider "linode" {
  token = var.linode_token
}

# linode object storage
resource "linode_object_storage_bucket" "servers_object_storage" {
  label  = "${var.project_name}-tfstate"
  region = var.linode_s3_region
}

# linode object storage access key
resource "linode_object_storage_key" "bucket_key" {
  label   = "${var.project_name}-tfstate"
  bucket_access {
    bucket_name = "${var.project_name}-tfstate"
    region      = var.linode_s3_region
    permissions = "read_write"
  }
  depends_on = [linode_object_storage_bucket.servers_object_storage]
}

# generate credentials file
resource "local_file" "credentials" {
  content = <<-EOT
[default]
aws_access_key_id = ${linode_object_storage_key.bucket_key.access_key}
aws_secret_access_key = ${linode_object_storage_key.bucket_key.secret_key}
EOT
  filename = "credentials"
}
