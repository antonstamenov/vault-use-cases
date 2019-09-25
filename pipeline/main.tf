provider "tfe" {
  hostname = "atlas.hashicorp.com"
}

data tfe_workspace "vault-use-cases" {
  organization = "helecloud"
  name = "vault-use-cases"
}

resource "tfe_variable" "aws-region" {
  category     = "env"
  key          = "AWS_DEFAULT_REGION"
  value        = var.AWS_DEFAULT_REGION
  workspace_id = data.tfe_workspace.vault-use-cases.id
}

resource "tfe_variable" "aws-access-key" {
  category     = "env"
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.AWS_ACCESS_KEY_ID
  workspace_id = data.tfe_workspace.vault-use-cases.id
  sensitive = true
}

resource "tfe_variable" "aws-secret-key" {
  category     = "env"
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.AWS_SECRET_ACCESS_KEY
  workspace_id = data.tfe_workspace.vault-use-cases.id
  sensitive = true
}

resource "tfe_variable" "aws-key" {
  category     = "env"
  key          = "CONFIRM_DESTROY"
  value        = "1"
  workspace_id = data.tfe_workspace.vault-use-cases.id
}