---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# Save-MispContext

## SYNOPSIS

Search MISP for Attributes matching the specified Search Criteria.

## SYNTAX

```powershell
Search-MispAttribute [-Context] <psobject> [-Search] <hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Search MISP for Attributes matching the specified Search Criteria as per criteria defined in the [documentation](https://www.misp-project.org/openapi/#tag/Attributes/operation/restSearchAttributes)

## EXAMPLES

### Example 1

```powershell
PS > $Search = @{eventId = 12345}
PS > $MispAttributes = Search-MispAttributes -Context $MispContext -Search $Search
```

Search for MISP Attributes related to Event Id 12345

### Example 2

```powershell
PS > $Search = @{
    eventId = 12345
    type = 'ip-src'
    org = 1
  }
PS > $MispAttributes = Search-MispAttributes -Context $MispContext -Search $Search
```

Search for MISP attributes related to Event Id 12345 of type 'ip-src' and matching Organisation 1.

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
