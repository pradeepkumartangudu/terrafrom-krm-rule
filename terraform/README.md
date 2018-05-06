# Terraform

Terraform configurations

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* [Terraform](https://www.terraform.io)


### Installing

Use the following steps to get started on your local development machine.

```
Clone the repository
Copy credentials.example.json to credentials.json and add your credentials into it
```

### Deployment

Example Commands
```
"python terraform.py" to run a terraform plan on all accounts
"python terraform.py --env bidwsandbox" to run a plan on sandbox
"python terraform.py --env bidwsandbox --action apply" to run a terraform apply only on sandbox
```

## Built With

* [Terraform](https://www.terraform.io) - Infrastructure as Code

## Contributing

Follow the git workflow of the parent README.md


## Authors

* **James Russell Perkins** - jp803p - *Initial work*
