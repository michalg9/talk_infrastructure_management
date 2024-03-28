# Demo 2 - IaC 

## Initialization and download of the providers

```bash
tofu init
```

## Log in to Google Cloud

Use `gcloud auth application-default login`

## Shift-left

### Plan

```bash
# get the plan
tofu plan -input=false -out=tofu_plan.out
  
# export plan to json
tofu show -json tofu_plan.out > tofu_plan_out.json
```


### Existing tools

Shift-left security (more in this [blog post](https://spacelift.io/blog/integrating-security-tools-with-spacelift)):

- [tfsec](https://github.com/aquasecurity/tfsec):

```bash
tfsec
```

- [kics](https://docs.kics.io/):

```bash
docker run -v .:/tf checkmarx/kics:latest scan -p "/tf" -o "/tf/"
```

## Apply

```bash
tofu apply
```
