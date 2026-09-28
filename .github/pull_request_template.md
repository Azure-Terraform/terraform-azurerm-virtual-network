# Pull Request Template

## Description

**Brief summary of changes:**
<!-- Provide a clear and concise description of what this PR accomplishes -->

## Type of Change

Please select the relevant option(s):

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🧹 Code cleanup/refactoring
- [ ] 🔧 Infrastructure/tooling changes

## Changes Made

### Core Functionality
<!-- Describe the main functional changes -->
- [ ] Added/modified Terraform resources
- [ ] Updated module interfaces (variables, outputs)
- [ ] Enhanced validation logic
- [ ] Improved error handling

### Examples & Documentation
<!-- Describe changes to examples and documentation -->
- [ ] Updated/added example configurations
- [ ] Modified README or other documentation
- [ ] Added inline code comments
- [ ] Updated variable descriptions

### Testing & Validation
<!-- Describe testing and validation performed -->
- [ ] Validated with `terraform validate`
- [ ] Tested with `terraform plan`
- [ ] Verified backward compatibility
- [ ] Tested new functionality scenarios
- [ ] Updated/added test cases

## IPAM Support Enhancement (if applicable)

### Functionality Validated
- [ ] **Traditional VNet**: Existing `address_space` + `cidrs` configurations work unchanged
- [ ] **IPAM-Only VNet**: Pure IPAM pool allocation functionality works correctly
- [ ] **Mixed VNet**: Hybrid traditional + IPAM scenarios supported
- [ ] **Input Validation**: Lifecycle preconditions properly enforce requirements

### Usage Patterns Supported
- [ ] Traditional mode: `cidrs` only, no `ip_address_pool`
- [ ] IPAM mode: `ip_address_pool` only, no `cidrs`
- [ ] Hybrid mode: Both `cidrs` and `ip_address_pool` for complex scenarios

### Configuration Requirements
- [ ] Confirmed `names` variable includes all required fields
- [ ] Verified placeholder `address_space` handling for IPAM scenarios
- [ ] Validated lifecycle precondition logic in subnet module

## Breaking Changes

<!-- If this introduces breaking changes, describe them here -->
- [ ] No breaking changes
- [ ] Breaking changes (describe below):

**Details:**
<!-- Describe any breaking changes and migration path -->

## Backward Compatibility

- [ ] ✅ **Confirmed**: All existing configurations continue to work without modification
- [ ] ⚠️ **Requires attention**: Some configurations may need updates (details below)
- [ ] ❌ **Breaking**: Existing configurations will need to be updated

**Compatibility Details:**
<!-- Describe backward compatibility status and any required actions -->

## Testing Performed

### Validation Tests
- [ ] `terraform init` - successful on all configurations
- [ ] `terraform validate` - passed on all examples
- [ ] `terraform fmt` - applied consistently across all files
- [ ] Lifecycle preconditions - validated during planning phase

### Example Configurations Tested
- [ ] `examples/basic/` - Traditional VNet functionality
- [ ] `examples/ipam_pool/` - Mixed traditional + IPAM functionality  
- [ ] `examples/ipam_only/` - Pure IPAM functionality
- [ ] Custom test scenarios - Invalid configurations properly rejected

### Provider Compatibility
- [ ] Tested with Azure provider version: `~> 4.0`
- [ ] Confirmed compatibility with Terraform version: `>= 1.0`

## Checklist

### Code Quality
- [ ] Code follows project style guidelines
- [ ] Self-review of code completed
- [ ] Code is properly commented, particularly complex areas
- [ ] No debugging code or temporary files left in the codebase

### Documentation
- [ ] Documentation has been updated to reflect changes
- [ ] Examples demonstrate the new functionality
- [ ] README updated if necessary
- [ ] Inline comments explain complex logic

### Dependencies
- [ ] New dependencies are justified and documented
- [ ] Provider version constraints are appropriate
- [ ] No unnecessary dependencies added

## Additional Context

<!-- Add any additional context, screenshots, or information that would be helpful for reviewers -->

## Related Issues

<!-- Link to any related issues -->
Closes #
Relates to #

## Reviewer Notes

<!-- Any specific areas you'd like reviewers to focus on -->

---

**Validation Summary:**
<!-- Include a link to validation results if available -->
📋 See [VALIDATION_SUMMARY.md](./VALIDATION_SUMMARY.md) for comprehensive testing results and supported usage patterns.