# Shai-Hulud Migration Response

This repository contains guidance and scripts for responding to the
[Shai-Hulud Supply Chain Attack on npm Packages](https://safedep.io/npm-supply-chain-attack-targeting-maintainers/).

If you are looking for guardrails against similar attacks, please see the:

1. [vet](https://github.com/safedep/vet) for scanning your projects for malicious packages
2. [vet-action](https://github.com/safedep/vet-action) for integrating `vet` into your GitHub workflows
3. [pmg](https://github.com/safedep/pmg) for preventing malicious package installation in developer machines

## TL;DR

TODO: Script usage instructions

## Overview

The Shai-Hulud attack involves the compromise of npm packages to distribute
malware to developers. The malware was designed to steal credentials, source
code and other sensitive information from infected systems. Technical details
of the attack and the payload can be found in the [SafeDep Incident Report](https://safedep.io/npm-supply-chain-attack-targeting-maintainers/).

## Response Steps

If you believe you are affected by this attack, please follow these steps:

1. Scan your systems for indicators of compromise (IoCs) listed below
2. Rotate credentials available in compromised systems
3. Follow the guidance to harden against similar attacks in the future
4. Setup guardrails to protect against malicious open source packages
5. Harden your developer workflows to prevent npm based supply chain attacks

## Scanning for IoCs

### Indicators of Compromise (IoCs)

1. Malicious package versions [data/ioc/malicious-package-versions.jsonl](iocs/malicious-package-versions.jsonl)
2. Malicious payload hashes [data/ioc/malicious-payload-hashes.jsonl](iocs/malicious-payload-hashes.jsonl)

### Scanning


