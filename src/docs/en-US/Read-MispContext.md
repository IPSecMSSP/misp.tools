---
external help file: MISP.Tools-help.xml
Module Name: MISP.Tools
schema: 2.0.0
---

# Read-MispContext

## SYNOPSIS

Read the MISP Context from a saved preferences file.

## SYNTAX

```powershell
Read-MispContext [[-Path] <string>] [[-Filename] <string>] [<CommonParameters>]
```

## DESCRIPTION

Read the MISP Context from a saved preferences file

Check to see that the contents of the file matches our expectations after loading.

## EXAMPLES

### Example 1

```powershell
PS > $MispContext = Read-MispContext
```

Read saved MISP Context from default file and context directory

### Example 2

```powershell
PS > $MispContext = Read-MispContext -Filename 'MyMISP.xml'
```

Read saved MISP Context with custom filename from the default context directory

## PARAMETERS

### Path

Location on disk to read saved MISP Context from. This defaults to the user's AppDataLocal path, which varies between Operating Systems, and on Windows may be modified through Group Policy.

### Filename

Name of file to use for MISP Context, defaults to MISPContext.xml

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String - Path

### System.String - Filename

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[MISP.Tools on GitHub](https://github.com/IPSecMSSP/misp.tools)
