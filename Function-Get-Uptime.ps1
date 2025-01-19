function Get-Uptime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")]
        [string[]]$ComputerName=$env:COMPUTERNAME,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Object", "CSV", "HTML")]
        [string]$OutputFormat = "Object",

        [Parameter(Mandatory=$false)]
        [string]$LogPath = "$env:TEMP\Get-Uptime.log"
    )

    begin {
        $Results = @()
        $StartTime = Get-Date
        Write-Log -Message "Starting Get-Uptime function" -Path $LogPath
    }

    process {
        $Results = $ComputerName | ForEach-Object -Parallel {
            $Computer = $_
            try {
                # Validate computer name
                if (-not ($Computer -match '^[a-zA-Z0-9.-]+$')) {
                    throw "Invalid computer name: $Computer"
                }

                $hostdns = [System.Net.DNS]::GetHostEntry($Computer)
                $OS = Get-WmiObject win32_operatingsystem -ComputerName $Computer -ErrorAction Stop -Credential $using:Credential
                $BootTime = $OS.ConvertToDateTime($OS.LastBootUpTime)
                $Uptime = $OS.ConvertToDateTime($OS.LocalDateTime) - $BootTime
                $propHash = [ordered]@{
                    ComputerName = $Computer
                    BootTime     = $BootTime
                    Uptime       = $Uptime
                }
                New-Object PSObject -Property $propHash
            } 
            catch {
                Write-Output "$Computer : $($_.Exception.Message)"
                Write-Log -Message "Error processing $Computer : $($_.Exception.Message)" -Path $using:LogPath
            }
        } -ThrottleLimit 10
    }

    end {
        $EndTime = Get-Date
        $Duration = $EndTime - $StartTime
        Write-Log -Message "Get-Uptime completed. Duration: $($Duration.TotalSeconds) seconds" -Path $LogPath

        switch ($OutputFormat) {
            "CSV" {
                $Results | Export-Csv -Path "UptimeResults.csv" -NoTypeInformation
                Write-Output "Results exported to UptimeResults.csv"
            }
            "HTML" {
                $HTMLReport = $Results | ConvertTo-Html -Property ComputerName, BootTime, Uptime -Title "Uptime Report"
                $HTMLReport | Out-File "UptimeResults.html"
                Write-Output "Results exported to UptimeResults.html"
            }
            default {
                $Results
            }
        }
    }
}

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$Timestamp : $Message" | Out-File -FilePath $Path -Append
}
