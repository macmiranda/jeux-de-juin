## All the continuouses

Write a simple build and deployment pipeline for [1](../1) and [2](../2) using groovy / Jenkinsfile, Travis CI or Gitlab CI.

## My Comments

- This `gitlab-ci.yml` was inspired by many of the templates available in the Gitlab's FOSS project [repository](https://gitlab.com/gitlab-org/gitlab-foss/-/tree/master/lib/gitlab/ci/templates).
- In order to have a working a CI/CD pipeline, Gitlab CI would have to be connected to this Github repo via [external repositories](https://docs.gitlab.com/ee/ci/ci_cd_for_external_repos/) which is outside of the scope of this task.
- The CI hasn't been fully tested (only linted) and some assumptions have been made where the connecting points were missing:
    - `${CI_COMMIT_TAG}` and `${CI_PROJECT_NAME}` are available for external repositories 
    - `${REGISTRY_SECRET}` and `${KUBECONFIG_SECRET}` are Protected CI Pipeline Variables configured in the Gitlab's Project Settings.
    - `${REGISTRY_USER}` and `${REGISTRY_HOST}` could also have been configured as CI Pipeline Variables.
    - Gitlab Runners have access to the Kubernetes API.
    - Not using Helm to deploy since release management wasn't one of the requirements.