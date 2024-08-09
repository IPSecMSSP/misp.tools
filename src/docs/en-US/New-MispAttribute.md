---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# Save-MispContext

## SYNOPSIS

Create a new MISP Attribute Object for association with a New Event.

## SYNTAX

```powershell
New-MispAttribute [[-Category] <string>] [-Type] <string> [[-Distribution] <string>] [-Comment] <string> [-Value] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Create a New MISP Attribute that can be associated with a MISP Event. Provides default values when parameters are not specified.

## EXAMPLES

### Example 1

```powershell
PS > $MispAttribute = New-MispAttribute -Category 'Network Traffic' -Type 'ip-src' -Value '192.168.100.100' -Comment 'Some comment'
```

Create a new MISP Attribute that can be used in an array of attributes associated to an Event.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object - MISP Context

### System.String - DestinationPath

### System.String - Filename

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[MISP.Tools on GitHub](https://github.com/IPSecMSSP/misp.tools)
