#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

TRIVY_VERSION="${security_trivy_version}"
SEVERITY="${security_trivy_severity_threshold}"
EXIT_ON="${security_trivy_exit_on_severity}"
REPORT_DIR="${security_trivy_report_dir}"

# Ensure report directory exists
mkdir -p "${REPORT_DIR}"

# Function to run Trivy scan
run_trivy_scan() {
    local scan_type=$1
    local target=$2
    local output_file="${REPORT_DIR}/${scan_type}-$(date +%Y%m%d-%H%M%S)"

    echo "🔍 Running Trivy ${scan_type} scan on ${target}"
    
    docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd):/src" \
        -v "${security_trivy_cache_dir}:/root/.cache/" \
        aquasec/trivy:${TRIVY_VERSION} \
        ${scan_type} \
        --severity "${SEVERITY},${EXIT_ON}" \
        --format "table,json,html" \
        --output "${output_file}.table,${output_file}.json,${output_file}.html" \
        ${target}
}

# Scan container images
if [ "${security_trivy_scan_targets_container_enabled}" = "true" ]; then
    echo "📦 Scanning container images..."
    for image in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
        if [[ ! "${image}" =~ ${security_trivy_scan_targets_container_exclude_images} ]]; then
            run_trivy_scan "image" "${image}"
        fi
    done
fi

# Scan filesystem
if [ "${security_trivy_scan_targets_filesystem_enabled}" = "true" ]; then
    echo "📂 Scanning filesystem..."
    for path in ${security_trivy_scan_targets_filesystem_paths}; do
        run_trivy_scan "fs" "/src/${path}"
    done
fi

# Scan Kubernetes resources
if [ "${security_trivy_scan_targets_kubernetes_enabled}" = "true" ]; then
    echo "☸️ Scanning Kubernetes resources..."
    for ns in ${security_trivy_scan_targets_kubernetes_namespaces}; do
        run_trivy_scan "k8s" "cluster --namespace ${ns}"
    done
fi

# Scan configuration files
if [ "${security_trivy_scan_targets_config_enabled}" = "true" ]; then
    echo "⚙️ Scanning configuration files..."
    for path in ${security_trivy_scan_targets_config_paths}; do
        run_trivy_scan "config" "/src/${path}"
    done
fi

echo "✅ Trivy scans completed. Reports available in ${REPORT_DIR}"
