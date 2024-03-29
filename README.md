# MISP.Tools

PowerShell module for interaction with MISP (Malware Information Sharing Platform) - Threat Intelligence Sharing Platform REST APIs

## Overview

MISP.Tools provides various functions for interacting with the MISP REST APIs to assist with the automation of Event Submission, Indicator of Compromise Lookups and other activities.

This module was created because there were no suitable PowerShell alternatives that provided the required functionality for my needs.

Some inspiration was derived from [PSMISP](https://github.com/mgajda83/PSMISP)

## Getting Started

### PowerShell Gallery

Install MISP.Tools from the [PowerShell Gallery](https://www.powershellgallery.com/) using `Install-Module`.

```powershell
Install-Module -Name MISP.Tools -Scope CurrentUser
```

### Local Build

Use `Invoke-Build` to run a local build of MISP.Tools...

```powershell
Invoke-Build -Task Build
```

Then you can import the built module into your PowerShell session.

```powershell
Import-Module "<ProjectRoot>\build\MISP.Tools\MISP.Tools.psd1" -Force
```

## Usage

TODO

## Uninstalling

Remove MISP.Tools from your system using `Uninstall-Module`.

```powershell
Uninstall-Module -Name MISP.Tools
```

## Importing From Source

If you are working on the module locally and want to import it into your PowerShell session without running through a compile/build, you can just import the module manifest directly from within the ```src``` directory.

```powershell
Import-Module "<ProjectRoot>\src\MISP.Tools.psd1" -Force
```

## Contributions

Contributions are very welcome and there are many ways to contribute:

- Open a new bug report, feature request or just ask a question by creating a new issue.
- Participate in issue and pull requests discussion threads, and test fixes or new features.
- Submit your own fixes or features as a pull request.
  - If your change is substantial, please open an issue for discussion beforehand.
