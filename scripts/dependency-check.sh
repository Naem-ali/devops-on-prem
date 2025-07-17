#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

DEPENDENCY_CHECK_VERSION="${security_dependency_check_version}"
FAIL_ON_CVSS="${security_dependency_check_fail_on_cvss}"

# Download and run OWASP Dependency-Check
docker run --rm \
    -v "$(pwd):/src" \
    -v "$(pwd)/security/data:/usr/share/dependency-check/data" \
    owasp/dependency-check:${DEPENDENCY_CHECK_VERSION} \
    --scan /src \
    --format "HTML" "JSON" \
    --failOnCVSS ${FAIL_ON_CVSS} \
    --suppression /src/${security_dependency_check_suppressions_file} \
    --exclude "$(echo ${security_dependency_check_exclude_paths} | tr ' ' ',')" \
    --project "DevOps Infrastructure" \
    --out /src/reports/dependency-check

# Check scan results
if [ $? -eq 0 ]; then
    echo "✅ Dependency check passed"
else
    echo "❌ Dependency check failed - vulnerabilities found with CVSS >= ${FAIL_ON_CVSS}"
    exit 1
fi
