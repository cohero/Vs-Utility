﻿function Get-ProjectItems
{
    [CmdletBinding()]
    Param(
        [string] $ProjFilePath,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Compile','Content','None','Analyzer','Reference','EmbeddedResource')]
        [string] $ItemType
    )

    if (-Not (Test-Path $ProjFilePath)) {throw "Project file does not exist at '$ProjFilePath'"}

    Write-Verbose "Checking project file '$ProjFilePath' for '$ItemType'"
    $projFileContent = [xml](Get-Content $ProjFilePath)
    $projFolder = Split-Path -Path $ProjFilePath -Parent

    $projItems = @()
    foreach($projItemGroup in $projFileContent.Project.ItemGroup)
    {
        $items = $projItemGroup.GetElementsByTagName($ItemType)

        foreach ($item in $items)
        {
            if ($item | Get-Member -Name "Include")
            {
                $absPath = Join-Path -Path $projFolder -ChildPath $item.Include -Resolve
                $isLinked = (-Not ([string]::IsNullOrWhiteSpace($item.Link)))
                $subtype = if ($null -ne $item.SubType) {$item.SubType} else {"None"}
                $copyToOutputDirectory = if ($null -ne $item.CopyToOutputDirectory) {  $item.CopyToOutputDirectory } else {"Never"}
                $itemProps = @{'FullPath'=$absPath;'Path'=$item.Include;'IsLinked'=$isLinked;'Subtype'=$subtype;'CopyToOutputDirectory'=$copyToOutputDirectory}
                $projItems += (New-Object -TypeName PSObject -Property $itemProps)
            }
        }
    }
    
    Write-Verbose "Project has $($projItems.Count) items"

    return $projItems
}

$pitems = Get-ProjectItems -ProjFilePath "E:\Projects\StingyBot\src\StingyBot.SalesForce\StingyBot.SalesForce.csproj" -ItemType None
$pitems | FL
