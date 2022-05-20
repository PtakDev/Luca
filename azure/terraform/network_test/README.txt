1. Install azure-cli in Ubuntu 20.04 LTS (16.04/18.04/21.10/22.04):
    https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt

2. Install Terraform in Ubuntu 20.04 LTS:
    https://www.terraform.io/cli/install/apt

3. Create terraform configuration file called main.tf using provider azurerm:
    https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0

4. Login to azure in azure-cli:
    az login -u <username> -p <password>
    https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli

5. Initialize terraform:
    terraform init 

6. Apply changes: 
    terraform apply

7. In Azure portal after some time we can see that new network has been created. 

8. To delete this network:
    terraform destroy

9. In Azure portal after some time we can see that new network has been deleted. 