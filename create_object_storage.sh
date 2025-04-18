#!/bin/bash
# ------------------------------------------------------------------------------
# author:      nekwebdev
# company:     monkeylab  
# license:     GPLv3
# description: creates a linode object storage bucket for terraform remote state.
#              manages the infrastructure deployment using terraform in docker
#              containers for clean dependency management.
# ------------------------------------------------------------------------------

# color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # no color

# helper function for colored output
echo_color() {
  echo -e "${1}${2}${NC}"
}

# fancy header function
print_header() {
  local text="$1"
  local width=70
  local delimiter="━"
  local line=$(printf "%${width}s" | tr ' ' "$delimiter")
  
  echo ""
  echo_color "$CYAN" "$line"
  echo_color "$CYAN$BOLD" "  $text"
  echo_color "$CYAN" "$line"
}

# error handling function
handle_error() {
  echo_color "$RED" "❌ ERROR: $1"
  exit 1
}

print_header "TERRAFORM INIT"
echo_color "$YELLOW" "starting terraform container..."

# run the terraform docker container
docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v "$(pwd)/object_storage":/tmp/workspace \
  -w /tmp/workspace \
  -e HOME=/tmp \
  hashicorp/terraform:latest init \
  -input=false || handle_error "terraform init failed"

echo_color "$GREEN" "✓ terraform init complete"

print_header "TERRAFORM PLAN"
echo_color "$YELLOW" "planning linode object storage bucket creation..."

docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v "$(pwd)/object_storage":/tmp/workspace \
  -w /tmp/workspace \
  -e HOME=/tmp \
  hashicorp/terraform:latest plan \
  -input=false \
  -out=plan.tfplan || handle_error "terraform plan failed"

echo_color "$GREEN" "✓ terraform plan complete"

# Ask for confirmation before applying
echo_color "$YELLOW" "Do you want to apply this plan? Only 'yes' will be accepted to approve."
read -p "Enter a value: " CONFIRM
# Convert to lowercase for case-insensitive comparison
CONFIRM_LOWER=$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')
if [ "$CONFIRM_LOWER" != "yes" ]; then
  echo_color "$RED" "Apply cancelled. Exiting..."
  exit 0
fi

print_header "TERRAFORM APPLY"
echo_color "$YELLOW" "creating linode object storage bucket..."

docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v "$(pwd)/object_storage":/tmp/workspace \
  -w /tmp/workspace \
  -e HOME=/tmp \
  hashicorp/terraform:latest apply plan.tfplan || handle_error "terraform apply failed"

echo ""
echo_color "$GREEN" "✓ terraform apply complete"

print_header "SETUP COMPLETE"
echo_color "$GREEN" "object storage bucket successfully created"
echo_color "$YELLOW" "you can now use this resource for terraform remote state"
