# ------------------------------------------------------------------------------
# author:      nekwebdev
# company:     monkeylab  
# license:     GPLv3
# description: Linode object storage backend for remote state storage and locking
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    key                         = "tf/tfstate"
    shared_credentials_files    = ["object_storage/credentials"]
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_lockfile                = true
  }
  
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}
