# Set MISP API Key/URI Context
function New-MispAttribute {
  <#
    .SYNOPSIS
        Construct a new MISP Attribute(s)
    .DESCRIPTION
        Construct a new MISP Attribute(s)

        The Attribute will be able to be added to an new Event, or added to an existing Event
    .PARAMETER Category
        The category that the Attribute belogs to.

        One of:
        - Internal reference
        - Targeting data
        - Antivirus detection
        - Payload delivery
        - Artifacts dropped
        - Payload installation
        - Persistence mechanism
        - Network activity
        - Payload type
        - Attribution
        - External analysis
        - Financial fraud
        - Support Tool
        - Social network
        - Person
        - Other
    .PARAMETER Type
        The type of Attribute.

        There are many types to choose from.  Common types include:
        - md5
        - sha1
        - sha256
        - email
        - ip-src
        - ip-dst
        - hostname
        - domain
        - url
        - user-agent
        - port
        - comment
        - other
    .INPUTS
        [PsCustomObject]    -> Context
        [string]            -> Category
        [string]            -> Type
    .OUTPUTS
        [Array]             -> Array of Attributes
    .EXAMPLE
        PS> $Attributes = Get-MispAttribute -Context $MispContext
        Return all Attributes
    .EXAMPLE
        PS> $Event = Get-MispAttribute -Context $MispContext -Id 1234
        Return details for attribute 1234
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#attribute-management
    #>

  [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'NoSaneDefaults')]

  param (
    [Parameter(Mandatory = $true,
      ParameterSetName = 'UseSaneDefaults')]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'NoSaneDefaults')]
    [ValidateSet("Internal reference", "Targeting data", "Antivirus detection", "Payload delivery", "Artifacts dropped", "Payload installation", "Persistence mechanism", "Network activity",
      "Payload type", "Attribution", "External analysis", "Financial fraud", "Support Tool", "Social network", "Person", "Other")]
    [string]$Category = "Other",

    [Parameter(Mandatory = $true)]
    [ValidateSet("md5", "sha1", "sha256", "filename", "pdb", "filename|md5", "filename|sha1", "filename|sha256", "ip-src", "ip-dst", "hostname", "domain", "domain|ip", "email", "email-src",
      "eppn", "email-dst", "email-subject", "email-attachment", "email-body", "float", "git-commit-id", "url", "http-method", "user-agent", "ja3-fingerprint-md5", "jarm-fingerprint",
      "favicon-mmh3", "hassh-md5", "hasshserver-md5", "regkey", "regkey|value", "AS", "snort", "bro", "zeek", "community-id", "pattern-in-file", "pattern-in-traffic", "pattern-in-memory",
      "filename-pattern", "pgp-public-key", "pgp-private-key", "ssh-fingerprint", "yara", "stix2-pattern", "sigma", "gene", "kusto-query", "mime-type", "identity-card-number", "cookie",
      "vulnerability", "cpe", "weakness", "attachment", "malware-sample", "link", "comment", "text", "hex", "other", "named pipe", "mutex", "process-state", "target-user", "target-email",
      "target-machine", "target-org", "target-location", "target-external", "btc", "dash", "xmr", "iban", "bic", "bank-account-nr", "aba-rtn", "bin", "cc-number", "prtn", "phone-number",
      "threat-actor", "campaign-name", "campaign-id", "malware-type", "uri", "authentihash", "vhash", "ssdeep", "imphash", "telfhash", "pehash", "impfuzzy", "sha224", "sha384", "sha512",
      "sha512/224", "sha512/256", "sha3-224", "sha3-256", "sha3-384", "sha3-512", "tlsh", "cdhash", "filename|authentihash", "filename|vhash", "filename|ssdeep", "filename|imphash",
      "filename|impfuzzy", "filename|pehash", "filename|sha224", "filename|sha384", "filename|sha512", "filename|sha512/224", "filename|sha512/256", "filename|sha3-224", "filename|sha3-256",
      "filename|sha3-384", "filename|sha3-512", "filename|tlsh", "windows-scheduled-task", "windows-service-name", "windows-service-displayname", "whois-registrant-email",
      "whois-registrant-phone", "whois-registrant-name", "whois-registrant-org", "whois-registrar", "whois-creation-date", "x509-fingerprint-sha1", "x509-fingerprint-md5",
      "x509-fingerprint-sha256", "dns-soa-email", "size-in-bytes", "counter", "integer", "datetime", "port", "ip-dst|port", "ip-src|port", "hostname|port", "mac-address", "mac-eui-64",
      "email-dst-display-name", "email-src-display-name", "email-header", "email-reply-to", "email-x-mailer", "email-mime-boundary", "email-thread-index", "email-message-id",
      "github-username", "github-repository", "github-organisation", "jabber-id", "twitter-id", "dkim", "dkim-signature", "first-name", "middle-name", "last-name", "full-name",
      "date-of-birth", "place-of-birth", "gender", "passport-number", "passport-country", "passport-expiration", "redress-number", "nationality", "visa-number", "issue-date-of-the-visa",
      "primary-residence", "country-of-residence", "special-service-request", "frequent-flyer-number", "travel-details", "payment-details", "place-port-of-original-embarkation",
      "place-port-of-clearance", "place-port-of-onward-foreign-destination", "passenger-name-record-locator-number", "mobile-application-id", "azure-application-id", "chrome-extension-id",
      "cortex", "boolean", "anonymised")]
    [string] $Type,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Organisation", "Community", "Connected", "All", "Group", "Inherit")]
    [string]$Distribution = "Organisation",

    [Parameter(Mandatory = $false)]
    [string] $Comment,

    [Parameter(Mandatory = $true)]
    [string] $Value,

    [Parameter(Mandatory = $false,
      ParameterSetName = 'NoSaneDefaults')]
    [boolean] $toIds = $false,

    [Parameter(Mandatory = $false)]
    [datetime] $FirstSeen,

    [Parameter(Mandatory = $false)]
    [datetime] $LastSeen
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose ('{0}: Build New MISP Attribute(s)' -f $Me)

    $DistributionMap = @{
      Organisation = 0      # Your organisation only
      Community    = 1      # This community only
      Connected    = 2      # Connected Communities
      All          = 3      # All communities
      Group        = 4      # Sharing Group
      Inherit      = 5      # Inherit Event
    }
  }

  Process {

    If ($PSCmdlet.ParameterSetName -eq 'UseSaneDefaults') {
      $TypeMapping = Get-MispAttributeType -Context $Context
      $Category = $TypeMapping.sane_defaults.$Type.default_category
      $toIds = $TypeMapping.sane_defaults.$Type.to_ids
    }

    if ($PSCmdlet.ShouldProcess("Construct New MISP Attribute")) {
      # Build the Attribute Body
      $Attribute = @{
        type         = $Type
        category     = $Category
        distribution = $DistributionMap.($Distribution)
        to_ids       = $toIds
        comment      = $Comment
        value        = $Value
      }

      if ($PSBoundParameters.ContainsKey('FirstSeen')) {
        $Attribute.first_seen = $FirstSeen.ToUniversalTime().ToString("o")
      }

      if ($PSBoundParameters.ContainsKey('LastSeen')) {
        $Attribute.last_seen = $LastSeen.ToUniversalTime().ToString("o")
      }

      # Return all for the events
      Write-Output $Attribute
    }
  }

  End {

  }

}