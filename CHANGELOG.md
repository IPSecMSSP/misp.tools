# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.1] - 2024-08-20

### Added

- Add-MispGalaxyClusterToObject

### Changed

- New-MispAttribute support for "Correlate" parameter, defaulting to true

## [1.2.0] - 2024-08-19

### Added

- Get-MispGalaxy
- Get-MispGalaxyCluster

## [1.1.4] - 2024-08-16

### Added

- Publish-MispEvent
- Unpublis-MispEvent
- Update-MispEvent
- Get-MispAttributeType
- Add-MispAttributeToEvent
- New-MispOrganisation
- Update-MispOrgaisation
- Get-MispOrganisation

### Changed

- Updated Signing to use Azure Key Vault to sign code
- Added Organisation support to New-MispEvent
- Set Comment parameter on New-MispAttribute as not mandatory

## [1.0.2] - 2023-04-19

### Fixed

- [#2] Search-MispAttribute returns all attributes regardless of search body

## [1.0.1] - 2022-11-15

### Fixed

- Use correct code signing certificate

## [1.0.0] - 2022-11-14

### Changed

- Moved development from GitHub to internal GitLab instance
  - Code Signing Security
- Implemented Code Signing
- Implement pipeline to publish to PowerShell Gallery on merge to `main`
- Update/Set repository references

## [0.0.2] - 2022-08-22

### Added

- Search-MispEvent
- Get-MispAttribute
- Search-MispAttribute

## [0.0.1] - 2022-08-15

### Added

- Initial release of MISP.Tools
- New-MispContext
- Save-MispContext
- Read-MispContext
- Invoke-MispRestMethod
- Get-MispEvent
- Search-MispEvent
- Get-MispAttribute
- Search-Misp-Attribute
- New-MispAttribute
- New-MispEvent
- Get-MispWarningList
- Get-MispTag
- Add-MispEventTag
- Add-MispAttributeTag

### Changed

- Nothing

### Deprecated

- Nothing

### Removed

- Nothing

### Fixed

- Nothing

### Security

- Nothing

### Known Issues

- [#1](https://github.com/IPSecMSSP/misp.tools/issues/1) Documentation is somewhat lacking
- [#2](https://github.com/IPSecMSSP/misp.tools/issues/2) Search-MispAttribute returns all attributes regardless of search body

[Unreleased]: https://github.com/IPSecMSSP/misp.tools
[1.0.2]: https://github.com/IPSecMSSP/misp.tools/releases/v1.0.2
[1.0.1]: https://github.com/IPSecMSSP/misp.tools/releases/v1.0.1
[0.0.1]: https://github.com/IPSecMSSP/misp.tools/releases/v0.0.1
