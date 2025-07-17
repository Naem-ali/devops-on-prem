# Security Policy Testing

Test environments and procedures for security policies.

## Directory Structure
```plaintext
.
├── scenarios/           # Test scenarios
│   ├── privileged/     # Privileged container tests
│   ├── resources/      # Resource requirement tests
│   └── network/        # Network policy tests
├── fixtures/           # Test fixtures
└── results/           # Test results (gitignored)
```

## Running Tests
```bash
# Test all policies
./run-tests.sh

# Test specific policy
./run-tests.sh -p require-labels

# Test in audit mode
./run-tests.sh --audit-mode
```

## Test Scenarios

### 1. Admission Control Tests
- Image tag validation
- Resource requirements
- Security context
- Label requirements

### 2. Runtime Security Tests
- Privileged operations
- File system access
- Network connections
- Process execution

### 3. Policy Validation Tests
```bash
# Validate policy syntax
./validate-policies.sh

# Test policy effects
./test-policy-effects.sh
```

## Adding New Tests
1. Create scenario in `scenarios/`
2. Add test fixtures
3. Update test suite
4. Document expected results

## CI/CD Integration
```yaml
test_policies:
  stage: test
  script:
    - ./run-tests.sh
  artifacts:
    reports:
      junit: results/junit.xml
```

## Best Practices
- Test both positive and negative cases
- Include compliance tests
- Document exceptions
- Regular test updates
