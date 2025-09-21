# Shai-Hulud Migration Response

<!--toc:start-->

- [Shai-Hulud Migration Response](#shai-hulud-migration-response)
  - [Overview](#overview)
  - [Response Steps](#response-steps)
  - [Scanning for IoCs](#scanning-for-iocs)
    - [Indicators of Compromise (IoCs)](#indicators-of-compromise-iocs)
    - [Scanning for Malicious Package Versions](#scanning-for-malicious-package-versions)
    - [Scanning for Malicious Payloads](#scanning-for-malicious-payloads)
  - [Credential Rotation](#credential-rotation)
  - [Setup Guardrails](#setup-guardrails)
  - [References](#references)
  <!--toc:end-->

This repository contains guidance and scripts for responding to the
[Shai-Hulud Supply Chain Attack on npm Packages](https://safedep.io/npm-supply-chain-attack-targeting-maintainers/).

If you are looking for guardrails against similar attacks, see:

1. [vet](https://github.com/safedep/vet) for scanning your projects for
   malicious packages
2. [vet-action](https://github.com/safedep/vet-action) for integrating
   `vet` into your GitHub workflows
3. [pmg](https://github.com/safedep/pmg) for preventing malicious package installation
   in developer machines

## Overview

The Shai-Hulud supply chain attack started with compromise of multiple npm packages to distribute
malware to developers. The malware was designed to steal credentials, source
code and other sensitive information from infected systems. Technical details
of the attack and the payload can be found in the [SafeDep Incident Report](https://safedep.io/npm-supply-chain-attack-targeting-maintainers/).

## Response Steps

If you believe you are affected by this attack, follow the steps below:

1. Scan your systems for indicators of compromise (IoCs) listed below
2. Rotate credentials available in compromised systems
3. Follow the guidance to harden against similar attacks in the future
4. Setup guardrails to protect against malicious open source packages
5. Harden your developer workflows to prevent npm based supply chain attacks

## Scanning for IoCs

### Indicators of Compromise (IoCs)

1. Malicious package versions [data/ioc/malicious-package-versions.jsonl](data/ioc/malicious-package-versions.jsonl)
2. Malicious payload hashes [data/ioc/malicious-payload-hashes.jsonl](data/ioc/malicious-payload-hashes.jsonl)

### Scanning for Malicious Package Versions

[vet](https://github.com/safedep/vet) is required to run this scan. Install `vet` using:

```bash
brew install safedep/tap/vet
```

Look at [vet/README.md](https://github.com/safedep/vet) for other installation options.

Run a full file system scan using `vet` and create an `sqlite3` database of all discovered package versions:

```bash
./scripts/pv-scan.sh
```

> [!NOTE]
> Enrichment is explicitly disabled for this scan because malicious package versions
> are already known from the IOC list.

Run the query script to query the generated database for known malicious package versions:

```bash
./scripts/pv-query.sh
```

### Scanning for Malicious Payloads

> [!WARNING]
> Scanning for payload hashes is compute intensive and may take a long time to complete.

Run the script to scan the file system for files matching known malicious payload hashes:

```bash
./scripts/pv-payload-hash-scan.sh
```

## Credential Rotation

The malicious payload delivered through the attack compromised credentials
available in the infected systems. Rotate all known credentials, particularly
the following:

- Npm credentials available in `$HOME/.npmrc` or `$NPM_TOKEN` environment variable
- GitHub credentials of developers using affected systems
- AWS credentials available in `$HOME/.aws/credentials` or
  `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` environment variables
- AWS credentials available in AWS Secrets Manager that were accessible from
  affected systems
- Google Cloud credentials and credentials stored in Google Cloud Secret Manager
  that were accessible from affected systems
- SSH private keys, especially if they were passwordless

The malicious payload also used [TruffleHog](https://github.com/trufflesecurity/trufflehog) to extract
secrets from source code repositories available in the infected system. Consider running TruffleHog and rotating
any secrets found in infected systems.

## Setup Guardrails

- Install [SafeDep vet](https://github.com/safedep/vet) or similar tools to scan open source packages
  for malicious code before merging pull requests or deploying code.
- Install [SafeDep pmg](https://github.com/safedep/pmg) or similar tools to prevent installation of
  malicious packages in developer machines.

## References

- <https://unit42.paloaltonetworks.com/npm-supply-chain-attack/>
- <https://safedep.io/npm-supply-chain-attack-targeting-maintainers/>
