param (
    [string]$TargetPath = $(Get-Location)  # Default: Current directory
)

# Ensure the provided path exists
if (!(Test-Path -Path $TargetPath -PathType Container)) {
    Write-Host "Error: The specified directory does not exist!" -ForegroundColor Red
    exit 1
}

Write-Host "Running cleanup in: $TargetPath" -ForegroundColor Yellow

### 🔹 Step 1: Remove ".terragrunt-cache" directories ###
$CacheDirs = Get-ChildItem -Path $TargetPath -Recurse -Directory -Force | Where-Object { $_.Name -eq ".terragrunt-cache" }

if ($CacheDirs.Count -gt 0) {
    foreach ($Dir in $CacheDirs) {
        Write-Host "Deleting directory: $($Dir.FullName)" -ForegroundColor Red
        Remove-Item -Path $Dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Host "✅ Cleanup complete: All .terragrunt-cache directories removed." -ForegroundColor Green
} else {
    Write-Host "No .terragrunt-cache directories found." -ForegroundColor Cyan
}

### 🔹 Step 2: Remove ".terraform.lock.hcl" files ###
$LockFiles = Get-ChildItem -Path $TargetPath -Recurse -File -Force | Where-Object { $_.Name -eq ".terraform.lock.hcl" }

if ($LockFiles.Count -gt 0) {
    foreach ($File in $LockFiles) {
        Write-Host "Deleting file: $($File.FullName)" -ForegroundColor Red
        Remove-Item -Path $File.FullName -Force -ErrorAction SilentlyContinue
    }
    Write-Host "✅ Cleanup complete: All .terraform.lock.hcl files removed." -ForegroundColor Green
} else {
    Write-Host "No .terraform.lock.hcl files found." -ForegroundColor Cyan
}

Write-Host "🎉 Full cleanup finished!" -ForegroundColor Green
