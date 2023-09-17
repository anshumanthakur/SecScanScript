# SecScanScript

## Overview

This project deploys infrastructure using Terraform and includes security scans for vulnerabilities using GitLab CI/CD. The security scans include Secret Detection and SAST (Static Application Security Testing). If any vulnerabilities are detected during these scans, the pipeline will fail.

## GitLab CI/CD Configuration

The GitLab CI/CD pipeline is defined in the `.gitlab-ci.yml` file and consists of the following stages:

1. **Test Stage (`test`):** This stage is responsible for running SAST (Static Application Security Testing). It generates a report in `gl-sast-report.json`.

2. **Analyze Scans Stage (`analyze_scans`):** This stage analyzes the security scans, including Secret Detection and SAST reports. If vulnerabilities are detected, the pipeline will fail.

3. **Provisioning Infrastructure Stage (`provisioning_infra`):** This stage deploys infrastructure using Terraform. It is dependent on the successful completion of the `analyze_scans` stage.

## GitLab CI/CD Configuration Details

### SAST (Static Application Security Testing)

- **Stage:** `test`
- **Tags:** `fusion-docker`
- **Artifacts:** `gl-sast-report.json`
- **When:** Manual

### Secret Detection

- **Tags:** `fusion-docker`
- **When:** Manual
- **Artifacts:** `gl-secret-detection-report.json`
- **Variables:** `SECRET_DETECTION_HISTORIC_SCAN: "true"`

### Analyze Scans

- **Stage:** `analyze_scans`
- **Image:** `nexus.pitneycloud.com:8443/fusion-platform/awscli-docker:latest`
- **Tags:** `fusion-docker`
- **When:** Manual
- **Allow Failure:** False
- **Script:** Analyzes both Secret Detection and SAST reports.

### Provisioning Infrastructure

- **Image:** `python:3.10`
- **Stage:** `provisioning_infra`
- **Tags:** `fusion-docker`
- **Before Script:** Sets AWS credentials and other environment variables.
- **Script:** Deploys infrastructure using Terraform. Depends on the successful completion of the `analyze_scans` stage.
- **Environment:** Uses the GitLab CI/CD branch or tag name as the environment name.
- **When:** Manual

## Script (`script.sh`) for Vulnerability Analysis

The `script.sh` script is used in the `analyze_scans` stage to analyze the security scan reports. It checks for the presence of vulnerabilities and fails the pipeline if any are detected.

## Usage

1. Commit your Terraform configuration files to the repository.

2. Configure your AWS credentials as environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`) in the GitLab CI/CD settings.

3. Run the GitLab CI/CD pipeline, starting with the `test` stage, to perform security scans and deploy infrastructure.

4. If vulnerabilities are detected during the scans, the pipeline will fail.

5. If the pipeline successfully passes all stages, the infrastructure will be deployed using Terraform.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

