# --------------------------------------------------------
# Function: ConvertTo-UnsecureString
# --------------------------------------------------------
function ConvertTo-UnsecureString
{
    Param
    (
        [Parameter(Mandatory=$True)]
        [SecureString] $secureString
    )

    $credential = New-Object System.Management.Automation.PSCredential("UserName", $secureString)
    return($credential.GetNetworkCredential().Password)
}

# --------------------------------------------------------
# Function: Get-EncryptionKeyByteArray
# --------------------------------------------------------
function Get-EncryptionKeyByteArray
{
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $encryptionKey
    )

    # Byte array (24 bytes)
    $secureKey24Bytes = [byte[]]::new(24)

    # Convert string to byte array
    $secureKeyByteArray = [System.Text.Encoding]::Unicode.GetBytes($encryptionKey)

    # Copy first 24 bytes to new array
    $minLength = [Math]::Min($secureKey24Bytes.Length, $secureKeyByteArray.Length)
    for ($i = 0; $i -lt $minLength; $i++)
    {
        $secureKey24Bytes[$i] = $secureKeyByteArray[$i]
    }

    return($secureKey24Bytes)
}

# --------------------------------------------------------
# Function: Get-EncryptedSecureString
# --------------------------------------------------------
function Get-EncryptedSecureString
{
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [SecureString] $secureString,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $encryptionKey
    )

    # Byte array
    $secureKeyByteArray = Get-EncryptionKeyByteArray -encryptionKey $encryptionKey
    # Encrypt secure strint to standard encoded string
    $encryptedString = ConvertFrom-SecureString -secureString $secureString -key $secureKeyByteArray

    return($encryptedString)
}

# --------------------------------------------------------
# Function: Get-DecryptedSecureString
# --------------------------------------------------------
function Get-DecryptedSecureString
{
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $encryptedString,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $encryptionKey
    )

    # Byte array
    $secureKeyByteArray = Get-EncryptionKeyByteArray -encryptionKey $encryptionKey
    # Decrypt encoded string to secure string
    $secureString = ConvertTo-SecureString -string $encryptedString -key $secureKeyByteArray

    return($secureString)
}
