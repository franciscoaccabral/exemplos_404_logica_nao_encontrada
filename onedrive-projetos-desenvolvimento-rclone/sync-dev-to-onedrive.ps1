[CmdletBinding()]
param(
    [switch]$Run,
    [string]$Source = 'C:\Dev',
    [string]$Destination = 'onedrive:Dev',
    [string]$DeletedBase = 'onedrive:DevDeleted'
)

$ErrorActionPreference = 'Stop'

$SyncDir = Join-Path $Source '.sync'
$FilterFile = Join-Path $SyncDir 'rclone-dev.filter'
$LogDir = Join-Path $SyncDir 'logs'
$Timestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$DateStamp = Get-Date -Format 'yyyy-MM-dd'
$LogFile = Join-Path $LogDir "sync-$Timestamp.log"
$BackupDir = "$DeletedBase/$DateStamp"
$LockFile = Join-Path $SyncDir 'sync-dev-to-onedrive.lock'

function Resolve-RcloneExe {
    if ($env:RCLONE_EXE -and (Test-Path -LiteralPath $env:RCLONE_EXE -PathType Leaf)) {
        return $env:RCLONE_EXE
    }

    $cmd = Get-Command rclone -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    throw 'rclone.exe not found. Install rclone or set RCLONE_EXE to the full rclone.exe path.'
}

if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
    throw "Source folder not found: $Source"
}

if (-not (Test-Path -LiteralPath $FilterFile -PathType Leaf)) {
    throw "Filter file not found: $FilterFile"
}

New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

$lockStream = $null
try {
    $lockStream = [System.IO.File]::Open($LockFile, 'OpenOrCreate', 'ReadWrite', 'None')
    $lockStream.SetLength(0)
    $lockBytes = [System.Text.Encoding]::UTF8.GetBytes("PID=$PID Started=$(Get-Date -Format o)")
    $lockStream.Write($lockBytes, 0, $lockBytes.Length)

    $RcloneExe = Resolve-RcloneExe
    $args = @(
        'sync',
        $Source,
        $Destination,
        '--filter-from', $FilterFile,
        '--backup-dir', $BackupDir,
        '--delete-excluded',
        '--log-file', $LogFile,
        '--transfers', '8',
        '--checkers', '16',
        '--onedrive-chunk-size', '40Mi',
        '--fast-list',
        '--order-by', 'size,mixed,50',
        '--retries', '5',
        '--retries-sleep', '30s',
        '--progress',
        '--stats', '10s',
        '-v'
    )

    if (-not $Run) {
        $args += '--dry-run'
        Write-Host "DRY-RUN only. Review the log, then run with -Run to apply changes. Log: $LogFile"
    } else {
        Write-Host "REAL sync. Log: $LogFile"
    }

    @(
        "Started=$(Get-Date -Format o)"
        "Mode=$(if ($Run) { 'REAL' } else { 'DRY-RUN' })"
        "Source=$Source"
        "Destination=$Destination"
        "BackupDir=$BackupDir"
        "FilterFile=$FilterFile"
        "RcloneExe=$RcloneExe"
        "Arguments=$($args -join ' ')"
        ''
    ) | Set-Content -Path $LogFile -Encoding UTF8

    & $RcloneExe @args
    $exitCode = $global:LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "rclone exited with code $exitCode. See log: $LogFile"
    }

    Write-Host "Completed successfully. Log: $LogFile"
}
finally {
    if ($lockStream) {
        $lockStream.Dispose()
    }
    Remove-Item -LiteralPath $LockFile -Force -ErrorAction SilentlyContinue
}
