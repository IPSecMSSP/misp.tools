# MISP.Tools

## about_MISP.Tools

### SHORT DESCRIPTION

MISP is an Open Source Threat Intelligence Sharing Platform (Formerly Malware Intelligence Sharing Platform).

MISP.Tools provides various PowerShell CmdLets to interact with the MISP REST API to assist with automating the process of submitting events and obtaining intelligence related to one or more IoCs.

### LONG DESCRIPTION

MISP is an Open Source Threat Intelligence Sharing Platform (Formerly Malware Intelligence Sharing Platform).

MISP.Tools provides various PowerShell CmdLets to interact with the MISP REST API to assist with automating the process of submitting events and obtaining intelligence related to one or more IoCs.

The power of MISP is in the sharing of intelligence between multiple sources. MISP's core element is an Event which main contain one or more attributes, and may be tagged in various ways.
Using this, Threat Intelligence feeds from Open Source as well as Commercial providers may be integrated into a single platform, along with events identified by one or more security solutions,
to build up a more complete picture of the relationships between multiple events.

This then allows summarised threat intelligence to be further shared with external parties, such as CERT teams, etc.

## MISP Contexts

Since it is possible, if not probable, that an organisation may have multiple MISP Instances, multiple MISP Contexts may be required to meet your API Interaction Needs.
Create a new MISP Context, and use this as a parameter to your MISP CmdLets to tell them which MISP Instance to communicate with, and the API Key to use.

### Saving Contexts

Contexts may be saved to disk, using either default locations and filenames, or overriding either or both of the default location and filename.  In this way, multiple Contexts may be saved and restored as needed.

### EXAMPLES

{{ Code or descriptive examples of how to leverage the functions described. }}

### NOTE

{{ Note Placeholder - Additional information that a user needs to know. }}

### SEE ALSO

[MISP.Tools Project](https://github.com/IPSecMSSP/misp.tools)
[MIPS.Tools on PowerShell Gallery](https://www.powershellgallery.com/packages/MISP.Tools)
