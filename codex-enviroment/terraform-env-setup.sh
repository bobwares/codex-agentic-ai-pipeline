TERRAFORM_VERSION = 1.12.1
if ! command -v terraform >/dev/null 2>&1; then
    echo "Installing Terraform ${TERRAFORM_VERSION}"
    curl -sL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip
    unzip terraform.zip
    mv terraform /usr/local/bin/
    rm terraform.zip
fi

pwd
cd iac
terraform init

