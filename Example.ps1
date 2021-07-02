# ---------------------------------------------
# Includes
# ---------------------------------------------
. "$PSScriptRoot\Encryption.ps1"

# =============================================
# Script body
# =============================================
# Variables declaration
$key = "SVFNe71RfHqme9qBKKtH"

# Password encryption
$passwordSecureString = Read-Host -Prompt "Enter password" -AsSecureString
$encryptedString = Get-EncryptedSecureString -secureString $passwordSecureString -encryptionKey $key
Write-Host "`nEncrypted password:" -ForegroundColor Yellow
Write-Host $encryptedString

# Password decryption
$decryptedSecureString = Get-DecryptedSecureString -encryptedString $encryptedString -encryptionKey $key
$decryptedPassword = ConvertTo-UnsecureString -secureString $decryptedSecureString
Write-Host "`nDecrypted password:" -ForegroundColor Yellow
Write-Host "$decryptedPassword`n"
