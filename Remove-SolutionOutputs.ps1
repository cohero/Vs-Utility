﻿


function Remove-SolutionOutputs
{
    [CmdletBinding()]
    Param(
        [string] $SolutionFilePath
    )
    Write-Verbose "Getting projects"

    $projects = Get-ProjectFiles $SolutionFilePath
    
    Write-Verbose "found $($projects.Count) projects"
    foreach($project in $projects)
    {
        Write-Verbose "Working on project $project"
        Remove-AllProjectOutput $project
    }
    Write-Host "Removal of solution outputs is complete"
}

