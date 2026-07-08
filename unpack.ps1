# ==============================================================================
# PS Vita Game, DLC & Avatar Automated Unpacker - V4 (Smart Tracking)
# Place this script in the same folder as your .zip files and pkg2zip.exe
# ==============================================================================

# --- Configuration ---
$7zPath = "C:\Program Files\7-Zip\7z.exe" 
$workingDir = Get-Location
$pkg2zipPath = Join-Path $workingDir "pkg2zip.exe"
$outputDir = Join-Path $workingDir "ReadyForVita"
$processedDir = Join-Path $workingDir "Processed_Zips" # NEW: Folder for finished zips

# --- Pre-flight Checks ---
if (-not (Test-Path $7zPath)) {
    Write-Host "[ERROR] 7-Zip not found at $7zPath." -ForegroundColor Red
    Pause
    exit
}
if (-not (Test-Path $pkg2zipPath)) {
    Write-Host "[ERROR] pkg2zip.exe not found." -ForegroundColor Red
    Pause
    exit
}

# Create directories if they don't exist
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Force -Path $outputDir | Out-Null }
if (-not (Test-Path $processedDir)) { New-Item -ItemType Directory -Force -Path $processedDir | Out-Null }

# --- Main Automation Loop ---
$zipFiles = Get-ChildItem -Path $workingDir -Filter *.zip

if ($zipFiles.Count -eq 0) {
    Write-Host "No new .zip files found in this directory." -ForegroundColor Yellow
}

foreach ($zip in $zipFiles) {
    $itemName = $zip.BaseName
    $isDlc = $itemName -match "\(DLC\)"
    $isAvatar = $itemName -match "\(Avatar\)"
    
    $typeString = if ($isDlc) { "DLC" } elseif ($isAvatar) { "AVATAR" } else { "GAME" }
    $success = $false # Track if the process worked
    
    Write-Host "`n======================================================="
    Write-Host "Processing [$typeString]: $itemName" -ForegroundColor Cyan
    Write-Host "======================================================="
    
    $tempDir = Join-Path $workingDir "temp_$($zip.Name)"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    Write-Host "-> Extracting $itemName..."
    & $7zPath x $zip.FullName -o"$tempDir" -y | Out-Null
    
    $pkgFile = Get-ChildItem -Path $tempDir -Filter *.pkg -Recurse | Select-Object -First 1
    
    if ($pkgFile) {
        $pkgDir = $pkgFile.DirectoryName
        
        $binFile = Get-ChildItem -Path $tempDir -Filter *.bin -Recurse | Where-Object { $_.Name -ne "eboot.bin" } | Select-Object -First 1
        
        if ($binFile) {
            $targetBinPath = Join-Path $pkgDir "work.bin"
            if ($binFile.FullName -ne $targetBinPath) {
                Write-Host "-> Found license .bin. Moving next to .pkg and renaming to work.bin..."
                Move-Item -Path $binFile.FullName -Destination $targetBinPath -Force
            }
        } else {
            Write-Host "-> WARNING: No .bin license file found. Decryption may fail." -ForegroundColor Yellow
        }
        
        Write-Host "-> Decrypting and unpacking .pkg with pkg2zip..."
        Push-Location $pkgDir
        & $pkg2zipPath -x $pkgFile.Name
        Pop-Location
        
        Write-Host "-> Organizing decrypted files..."
        $extractedVitaFolders = Get-ChildItem -Path $pkgDir -Directory | Where-Object { $_.Name -in @("app", "addcont", "patch", "license", "bgdl", "user", "psm") }
        
        foreach ($folder in $extractedVitaFolders) {
            $destPath = Join-Path $outputDir $folder.Name
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Force -Path $destPath | Out-Null
            }
            Copy-Item -Path "$($folder.FullName)\*" -Destination $destPath -Recurse -Force
        }
        
        Write-Host "-> SUCCESS: Finished processing $itemName!" -ForegroundColor Green
        $success = $true
    } else {
        Write-Host "-> ERROR: No .pkg file found inside $itemName." -ForegroundColor Red
    }
    
    Write-Host "-> Cleaning up temporary files..."
    Remove-Item -Path $tempDir -Recurse -Force
    
    # NEW: If successful, move the .zip to the Processed folder
    if ($success) {
        Write-Host "-> Archiving .zip to Processed_Zips folder..."
        Move-Item -Path $zip.FullName -Destination $processedDir -Force
    }
}

Write-Host "`nAll operations completed!" -ForegroundColor Green
Pause
