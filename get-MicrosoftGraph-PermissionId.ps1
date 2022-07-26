$url = "https://raw.githubusercontent.com/microsoftgraph/microsoft-graph-docs/main/concepts/includes/permissions-ids.md"
$header = "|---------------------------------------------------------|-------------|--------------------------------------|" # find starting point of permissions list

# get raw result from github page (base of Microsoft doc article)
$result = Invoke-RestMethod -Uri $url

# split multiline text to array
$aResult = $result.Split([Environment]::NewLine)

# get index of starting point in permission list (by specific header)
# https://devblogs.microsoft.com/scripting/find-the-index-number-of-a-value-in-a-powershell-array/
$indexHeader = ([array]::indexof($aResult,$header))

$hPermissions = @()

# add each permission to list
ForEach ($line in $aResult | Select -Skip ($indexHeader+1) | Select -SkipLast 1) {
    $aPermission = $line.Split("|") # split in different columns
    $a = New-Object -TypeName PSObject
    $a | Add-Member -NotePropertyName Permission -NotePropertyValue $aPermission[1].Trim()
    $a | Add-Member -NotePropertyName Scope -NotePropertyValue $aPermission[2].Trim()
    $a | Add-Member -NotePropertyName Id -NotePropertyValue $aPermission[3].Trim()
    $hPermissions += $a
}

# show permissions
$hPermissions| Out-GridView

#example to find specfic id
$search = "AccessReview.Read.All"
$id = ($hPermissions| Where {$_.Scope -eq "Application" -and $_.Permission -eq $search}).Id

