package env0

# Deny ALB listeners that use HTTP instead of HTTPS
deny[msg] {
    # Skip policy validation for destroy operations
    input.deploymentRequest.type != "destroy"
    
    rc := input.plan.resource_changes[_]
    rc.type == "aws_lb_listener"
    
    # Only check listeners that will exist after the change (not being deleted)
    not is_delete_action(rc.change.actions)
    rc.change.after
    
    # Check if the listener uses HTTP protocol (insecure)
    rc.change.after.protocol == "HTTP"
    
    msg := sprintf("%s: ALB listener must use HTTPS protocol, not HTTP", [rc.address])
}

# Deny ALBs that only have HTTP listeners and no HTTPS listeners
deny[msg] {
    # Skip policy validation for destroy operations
    input.deploymentRequest.type != "destroy"
    
    # Find ALB resource
    alb := input.plan.resource_changes[_]
    alb.type == "aws_lb"
    not is_delete_action(alb.change.actions)
    alb.change.after
    alb.change.after.load_balancer_type == "application"
    
    # Check if this ALB has any listeners
    listeners := [listener | 
        listener := input.plan.resource_changes[_]
        listener.type == "aws_lb_listener"
        not is_delete_action(listener.change.actions)
        listener.change.after
        listener.change.after.load_balancer_arn == alb.change.after.arn
    ]
    
    count(listeners) > 0
    
    # Check if all listeners are HTTP (no HTTPS listeners)
    all_http := [listener | 
        listener := listeners[_]
        listener.change.after.protocol == "HTTP"
    ]
    
    count(all_http) == count(listeners)
    
    msg := sprintf("%s: ALB must have at least one HTTPS listener for secure TLS communication", [alb.address])
}

# Deny security groups that only allow HTTP traffic and not HTTPS
deny[msg] {
    # Skip policy validation for destroy operations
    input.deploymentRequest.type != "destroy"
    
    sg := input.plan.resource_changes[_]
    sg.type == "aws_security_group"
    not is_delete_action(sg.change.actions)
    sg.change.after
    
    # Check if this security group is used by an ALB
    alb_uses_sg := [alb | 
        alb := input.plan.resource_changes[_]
        alb.type == "aws_lb"
        not is_delete_action(alb.change.actions)
        alb.change.after
        alb.change.after.load_balancer_type == "application"
        alb.change.after.security_groups[_] == sg.change.after.id
    ]
    
    count(alb_uses_sg) > 0
    
    # Check ingress rules
    ingress_rules := sg.change.after.ingress
    
    # Check if there are HTTP rules (port 80) but no HTTPS rules (port 443)
    has_http := [rule | 
        rule := ingress_rules[_]
        rule.from_port == 80
        rule.to_port == 80
        rule.protocol == "tcp"
    ]
    
    has_https := [rule | 
        rule := ingress_rules[_]
        rule.from_port == 443
        rule.to_port == 443
        rule.protocol == "tcp"
    ]
    
    count(has_http) > 0
    count(has_https) == 0
    
    msg := sprintf("%s: Security group for ALB must allow HTTPS traffic (port 443), not just HTTP (port 80)", [sg.address])
}

# Deny ALB listeners that use outdated TLS security policies
deny[msg] {
    # Skip policy validation for destroy operations
    input.deploymentRequest.type != "destroy"
    
    rc := input.plan.resource_changes[_]
    rc.type == "aws_lb_listener"
    
    # Only check listeners that will exist after the change (not being deleted)
    not is_delete_action(rc.change.actions)
    rc.change.after
    
    # Check if the listener has HTTPS protocol (TLS/SSL)
    rc.change.after.protocol == "HTTPS"
    
    # Get the minimum required TLS policy from configuration
    min_tls_policy := input.policyData.min_tls_policy
    
    # Check if ssl_policy is not set or doesn't match the minimum requirement
    not rc.change.after.ssl_policy
    
    msg := sprintf("%s: ALB listener must specify a TLS security policy", [rc.address])
}

# Deny ALB listeners with TLS policy that doesn't meet minimum requirements
deny[msg] {
    # Skip policy validation for destroy operations
    input.deploymentRequest.type != "destroy"
    
    rc := input.plan.resource_changes[_]
    rc.type == "aws_lb_listener"
    
    # Only check listeners that will exist after the change (not being deleted)
    not is_delete_action(rc.change.actions)
    rc.change.after
    
    # Check if the listener has HTTPS protocol (TLS/SSL)
    rc.change.after.protocol == "HTTPS"
    
    # Get the minimum required TLS policy from configuration
    min_tls_policy := input.policyData.min_tls_policy
    
    # Check if ssl_policy is set but doesn't match the minimum requirement
    rc.change.after.ssl_policy
    rc.change.after.ssl_policy != min_tls_policy
    not is_acceptable_tls_policy(rc.change.after.ssl_policy, min_tls_policy)
    
    msg := sprintf("%s: ALB listener is using TLS security policy '%s', but minimum required is '%s'", [rc.address, rc.change.after.ssl_policy, min_tls_policy])
}

# Helper function to check if actions include delete
is_delete_action(actions) {
    actions[_] == "delete"
}

# Helper function to determine if a TLS policy meets minimum requirements
# This is a simplified version - in practice, you might want more sophisticated policy comparison
is_acceptable_tls_policy(current_policy, min_policy) {
    # List of acceptable TLS policies in order of security (most secure first)
    acceptable_policies := [
        "ELBSecurityPolicy-TLS13-1-2-2021-06",
        "ELBSecurityPolicy-TLS-1-2-2017-01",
        "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
        "ELBSecurityPolicy-FS-2018-06"
    ]
    
    # Find the index of current and minimum policies
    current_index := policy_index(current_policy, acceptable_policies)
    min_index := policy_index(min_policy, acceptable_policies)
    
    # Current policy is acceptable if its index is less than or equal to minimum (more secure)
    current_index <= min_index
}

# Helper function to find policy index in acceptable policies list
policy_index(policy, policies) = index {
    policies[index] == policy
} else = 999 {
    # Return high index for unknown policies (treated as less secure)
    true
}