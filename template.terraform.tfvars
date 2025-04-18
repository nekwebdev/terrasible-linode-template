# required variables
linode_token        = "paste_linode_token"
cloudflare_token    = "paste_cloudflare_token"
cloudflare_zone_id  = "paste_cloudflare_zone_id"
domain_name         = "example.com"
ssh_admin_key       = "paste_admin_ssh_public_key"
ssh_services_key    = "paste_ansible_ssh_public_key"

# optional variables with defaults
project_name        = "server"                  # default: server
server_count        = 1                         # default: 1
linode_region       = "us-lax"                  # default: us-lax
linode_s3_region    = "us-lax"                  # default: us-lax
server_type         = "g6-nanode-1"             # default: g6-nanode-1
server_image        = "linode/debian12"         # default: linode/debian12
system_timezone     = "America/Los_Angeles"     # default: America/Los_Angeles
vpc_subnet          = "10.10.10"                # default: 10.10.10
root_password       = "paste_root_password"     # Required if not using random passwords
admin_user          = "admin"                   # default: admin
ssh_port            = 22                        # default: 22
ansible_python      = "/usr/bin/python3" # default: /usr/bin/python3
