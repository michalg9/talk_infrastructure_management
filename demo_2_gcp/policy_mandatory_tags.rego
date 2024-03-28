
# Smart Sanitization should be enabled on the stack so the policy can correctly read
# the instance type.

# Define the deny list of instance types
deny_list := ["e2-micro"]

# Deny if the instance type is in the deny list
deny {
	resource := input.resource_changes[_]
	resource.type == "google_compute_instance"
	instance := resource.change.after.machine_type
	is_in_deny_list(instance)
}

# Helper function to check if instance type is in the deny list
is_in_deny_list(instance) {
	some denied_instance
	denied_instance = deny_list[_]
	denied_instance == instance
}
