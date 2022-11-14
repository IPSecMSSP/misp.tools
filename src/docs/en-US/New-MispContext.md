---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# New-MispContext

## SYNOPSIS

Create a PSObject containing Credentials and Base URI for interaction with MISP

## SYNTAX

```powershell
New-MispContext [-Credential] <pscredential> [-BaseUri] <string> [-NoValidateSsl] [<CommonParameters>]
```

## DESCRIPTION

Create a PSObject containing Credentials and Base URI for interaction with MISP

Credentials supplied in the form of a PSCredential Object and Base URI as either a string or Uri::Builder object

## EXAMPLES

### Example 1

```powershell
PS> $MispContext = New-MispContext -Credential (Get-Credential -Username 'MISP Api Key') -BaseUri 'https://misp.domain.com'
```

Create a new MISP Context, prompting for the password via Get-Credential.

## PARAMETERS

### Credential

[PSCredential] - PSCredential Object with ApiKey as Password

### BaseUri

[uri::builder] or [string] - Base API URL for the API Calls to MISP as [string] or [Uri::Builder]

### NoValidateSsl

[switch] - Don't validate the SSL Certificate, default is to validate

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSCredential - Credential

PSCredential Object consisting of Username and Password. The Password is protected from casual in-memory examination. The Password property contains the API Key for MISP.

### System.String or System.UriBuilder - BaseUri

String or UriBuilder object containing the base Uri for your MISP instance.

### Switch - NoValidateSsl

Indicates that SSL/TLS Certificate Validation should not be performed.

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[MISP.Tools on GitHub](https://github.com/IPSecMSSP/misp.tools)
