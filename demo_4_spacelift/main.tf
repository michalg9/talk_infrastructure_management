# Terraform stack using github.com as VCS
resource "spacelift_stack" "cloudfestbydgoszcz" {
  description = "Provisions a Compute Node in GCP"
  name        = "CloudFest Bydgoszcz Demo"
  space_id    = "cloudfestbydgoszcz-01HSYTNN8Z3R12RWWVBAZGM5QG"
  labels      = ["gcp"]

  repository   = "talk_infrastructure_management"
  branch       = "main"
  project_root = "demo_2_gcp"

  terraform_workflow_tool = "OPEN_TOFU"
  terraform_version       = "1.6.2"
}

resource "spacelift_policy" "sample_only" {
  name = "Sample only policy"
  body = file("${path.module}/policies/sample_only.rego")
  type = "PLAN"
  space_id    = "cloudfestbydgoszcz-01HSYTNN8Z3R12RWWVBAZGM5QG"

  labels = ["autoattach:gcp"]
}

resource "spacelift_policy" "disallow_instances" {
  name = "Disallow big instances for GCP"
  body = file("${path.module}/policies/allow_only_small_instances.rego")
  type = "PLAN"
  space_id    = "cloudfestbydgoszcz-01HSYTNN8Z3R12RWWVBAZGM5QG"

  labels = ["autoattach:instances"]
}

resource "spacelift_blueprint" "cloudfestbydgoszcz" {
  name        = "CloudFest Bydgoszcz Self Service"
  description = "Provisions a Compute Node in GCP"
  space       = "cloudfestbydgoszcz-01HSYTNN8Z3R12RWWVBAZGM5QG"
  state       = "PUBLISHED"
  template    = <<EOF
inputs:
  - id: instance_name
    name: Name of the instance to create
  - id: machine_type
    name: Instance type for the machine. Defaults to e2-micro.
    type: select
    default: e2-micro
    options:
      - e2-micro
      - e2-small
      - e2-medium
      - e2-highcpu-32
  - id: secret_message
    name: Secret message to hide in the instance
    default: "Hello from CloudFest Bydgoszcz 2024"
  - id: trigger_run
    name: Trigger a run upon stack creation
    type: boolean
    default: false
stack:
  name: cfi-$${{ inputs.instance_name }}
  space: cloudfestbydgoszcz-01HSYTNN8Z3R12RWWVBAZGM5QG
  auto_deploy: true
  description: Stack created from a blueprint by $${{ context.user.name }} logged in as $${{ context.user.login }}
  labels:
    - "blueprints/$${{ context.blueprint.name }}"
    - "gcp"
    - "instances"
  vcs:
    branch: main
    repository: "talk_infrastructure_management"
    provider: GITHUB
    project_root: "demo_5_gcp_with_inputs"
  vendor:
    terraform:
      manage_state: true
      workflow_tool: "OPEN_TOFU"
      version: "1.6.2"
      use_smart_sanitization: true

  environment:
    variables:
      - name: TF_VAR_instance_name
        value: $${{ inputs.instance_name }}
      - name: TF_VAR_machine_type
        value: $${{ inputs.machine_type }}
      - name: TF_VAR_secret_message
        value: $${{ inputs.secret_message }}
options:
  trigger_run: $${{ inputs.trigger_run }}
EOF

}

