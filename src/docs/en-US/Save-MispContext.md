---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# Save-MispContext

## SYNOPSIS

Write MISP Context containing Api Key/URL out to a file for future reference

## SYNTAX

```powershell
Save-MispContext [-InputObject] <psobject> [[-DestinationPath] <string>] [[-Filename] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Write MISP Context containing Api Key/Url out to a file for future reference

Default location is user's profile path, but can be overridden with -DestinationPath
Default Filename is MISPContext.xml, but can be overridden with -Filename

## EXAMPLES

### Example 1

```powershell
PS > $MispContext | Save-MispContext
```

Save MISP Context to default location and filename

### Example 2

```powershell
PS > $MispContext | Save-MispContext -Filename 'MyMISP.xml'
```

Save MISP Context to default location with alternate filename

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
