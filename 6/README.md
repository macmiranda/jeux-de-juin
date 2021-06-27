## Terraform lovers unite

Write a Terraform module that creates the following resources in IAM;
- A role, with no permissions, which can be assumed by users within the same account,
- A policy, allowing users / entities to assume the above role,
- A group, with the above policy attached,
- A user, belonging to the above group.

All four entities should have the same name, or be similarly named in some meaningful way given the context e.g. `prod-ci-role`, `prod-ci-policy`, `prod-ci-group`, `prod-ci-user`; or just `prod-ci`. Make the suffixes toggleable, if you like.

## My Comments

- Using `us-east-1` as default region. 
- Haven't extensively checked the Business Logic yet but `terraform plan` and `terraform apply` are passing. Will work on it once I have some time.
- You can copy the `module` folder and source it in your Terraform code.
- Still need to work on the variables and getting input from `tfvars`. Most of the names are hardcoded.
- Need to document the outputs