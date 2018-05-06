# Sandbox


Remember to make sure that the `aws_config.tf` and `variables.tf` is updated with the right bucketname for the account

terraform init  -var 'access_key=keyvalue' -var 'secret_key=secretkeyvalue' -backend-config="access_key=keyvalue" -backend-config="secret_key=secretkeyvalue"
terraform plan  -var 'access_key=keyvalue' -var 'secret_key=secretkeyvalue' 
terraform apply  -var 'access_key=keyvalue' -var 'secret_key=secretkeyvalue' 
terraform destroy -var 'access_key=keyvalue' -var 'secret_key=secretkeyvalue'