terraform {
  required_version = "~> 1.14.0"
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }

  backend "http" {}
}

resource "random_pet" "name" {
  length = 4
}

variable "length" {
  type = number
  default = 32
}

# Additional resource that depends on random_pet
resource "random_password" "derived" {
  length  = var.length
  special = true

  # This forces dependency so your state viewer sees a relationship
  keepers = {
    pet_name = random_pet.name.id
  }
}

output "pet_name" {
  value = random_pet.name.id
}

# Normal output referencing dependent resource
output "derived_password_preview" {
  value = substr(random_password.derived.result, 0, 4)
  sensitive = true
}
