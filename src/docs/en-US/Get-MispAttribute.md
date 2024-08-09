---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# Save-MispContext

## SYNOPSIS

Get details of a MISP Attribute by Id, or get all.

## SYNTAX

```powershell
Get-MispAttribute [-Context] <psobject> [[-Id] <int>] [<CommonParameters>]
```

## DESCRIPTION

Get details of a MISP Attribute by Id, or return details of all MISP Attributes.

## EXAMPLES

### Example 1

```powershell
PS > $MispAttribute = Get-MispAttribute -Context $MispContext -Id 12345
```

Get details of the MISP Attribute with id 12345 and store them in the variable $MispAttribute.

### Example 2

```powershell
PS > $MispAttribute = Get-MispAttribute -Context $MispContext
```

Return all MISP Attributes and store them in the variable $MispAttribute

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
