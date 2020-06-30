==================
Secrets Management
==================

Secrets Management
==================

- intro lead in to sensitive data
- application depends on sensitive data, but needs to be kept secret

Sensitive Data
--------------

- data that cannot be made available to the public
- dev: keep out of source code (VCS)
    - .gitignore
- dev&ops: external configuration
    - public configs
    - secret configs
- ops: least privileged access
- ops: infra only has what it needs


- secrets management implementation
- local: user-secrets
- remote: key-vault