# ==============================================================================
# PS Vita Game & DLC Automated Unpacker
# Place this script in the same folder as your .zip files and pkg2zip.exe
# ==============================================================================

# --- Configuration ---
# Update this path if 7-Zip is installed somewhere else on your PC
$7zPath = "C:\Program Files\7-Zip\7z.exe" 
$workingDir = Get-Location
$pkg2zipPath = Join-Path $workingDir "pkg2zip.exe"
$outputDir = Join-Path $workingDir "ReadyForVita"

# --- Pre-flight Checks ---
if (-not (Test-Path $7zPath)) {
    Write-Host "[ERROR] 7-Zip not found at $7zPath. Please update the script with your correct 7-Zip path." -ForegroundColor Red
    Pause
    exit
}

if (-not (Test-Path $pkg2zipPath)) {
    Write-Host "[ERROR] pkg2zip.exe not found. Ensure it is in the same folder as this script." -ForegroundColor Red
    Pause
    exit
}

# Create final output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

# --- Main Automation Loop ---
$zipFiles = Get-ChildItem -Path $workingDir -Filter *.zip

if ($zipFiles.Count -eq 0) {
    Write-Host "No .zip files found in this directory." -ForegroundColor Yellow
}

foreach ($zip in $zipFiles) {
    $itemName = $zip.BaseName
    $isDlc = $itemName -match "\(DLC\)"
    $typeString = if ($isDlc) { "DLC" } else { "GAME" }
    
    Write-Host "`n======================================================="
    Write-Host "Processing [$typeString]: $itemName" -ForegroundColor Cyan
    Write-Host "======================================================="
    
    # 1. Create a temporary extraction folder
    $tempDir = Join-Path $workingDir "temp_$($zip.Name)"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    # 2. Extract zip contents using 7z
    Write-Host "-> Extracting $itemName..."
    & $7zPath x $zip.FullName -o"$tempDir" -y | Out-Null
    
    # 3. Find and rename the .bin file to work.bin (ignoring if it's already named correctly)
    $binFile = Get-ChildItem -Path $tempDir -Filter *.bin -Recurse | Where-Object { $_.Name -ne "work.bin" } | Select-Object -First 1
    if ($binFile) {
        Write-Host "-> Found .bin file. Renaming to work.bin..."
        Rename-Item -Path $binFile.FullName -NewName "work.bin"
    }
    
    # 4. Find the .pkg file
    $pkgFile = Get-ChildItem -Path $tempDir -Filter *.pkg -Recurse | Select-Object -First 1
    
    if ($pkgFile) {
        Write-Host "-> Decrypting and unpacking .pkg with pkg2zip..."
        
        # Navigate into the folder containing the .pkg so pkg2zip generates output there
        Push-Location $pkgFile.DirectoryName
        
        # The -x flag explicitly extracts into the app/ or addcont/ folder structure natively
        & $pkg2zipPath -x $pkgFile.Name
        
        Pop-Location
        
        # 5. Move the extracted Vita folders (app or addcont) to the final output directory
        Write-Host "-> Organizing decrypted files..."
        $extractedVitaFolders = Get-ChildItem -Path $tempDir -Directory | Where-Object { $_.Name -in @("app", "addcont") }
        
        foreach ($folder in $extractedVitaFolders) {
            $destPath = Join-Path $outputDir $folder.Name
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Force -Path $destPath | Out-Null
            }
            # Copy contents recursively to merge files if transferring multiple games/DLCs
            Copy-Item -Path "$($folder.FullName)\*" -Destination $destPath -Recurse -Force
        }
        Write-Host "-> SUCCESS: Finished processing $itemName!" -ForegroundColor Green
    } else {
        Write-Host "-> ERROR: No .pkg file found inside $itemName." -ForegroundColor Red
    }
    
    # 6. Clean up temporary folder
    Write-Host "-> Cleaning up temporary files..."
    Remove-Item -Path $tempDir -Recurse -Force
}

Write-Host "`nAll operations completed! Check the 'ReadyForVita' folder for your files." -ForegroundColor Green
Pause
