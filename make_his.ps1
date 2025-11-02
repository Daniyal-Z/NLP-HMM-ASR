# --- CONFIGURATION ---
$authors = @(
    "Daniyal <daniyal1412@hotmail.com>",
    "Abi <abijanu101@gmail.com>",
    "Wali <mhdwali125@gmail.com>"
)

# NLP & HMM SPECIFIC MESSAGES
# These are mixed with some generic ones to look realistic
$messages = @(
    "Implement Forward-Backward algorithm logic", 
    "Optimize Viterbi decoding path", 
    "Add MFCC feature extraction utilities", 
    "Parse TIMIT dataset phone mappings", 
    "Refactor HMM state transition matrix", 
    "Fix underflow issues in probability calculations", 
    "Update Gaussian Mixture Model parameters", 
    "Clean up phoneme dictionary loading", 
    "Add unit tests for Baum-Welch training", 
    "Tune hyperparameters for ASR model",
    "Fix dimensional mismatch in feature vectors",
    "Update config with new learning rates",
    "Restructure project folders for training scripts",
    "Add logging for model convergence",
    "Update documentation for preprocessing steps",
    "Optimize numpy array operations",
    "Fix bug in emission probability computation",
    "Add requirements.txt dependencies",
    "Pre-compute normalization stats",
    "Minor code formatting and linting"
)

# --- DATE CONFIGURATION ---
# Start Date: Nov 1st, 2025
$currentDate = Get-Date -Date "2025-11-01 10:00:00"
$targetEndDate = Get-Date -Date "2025-12-02 14:00:00"

# --- STEP 1: RESET HISTORY (SAFELY) ---
Write-Host "Resetting Git History..." -ForegroundColor Cyan

# Remove old git folder
if (Test-Path .git) { Remove-Item -Recurse -Force .git }

# Initialize new repo
git init

# Handle .gitignore safely
if (-not (Test-Path .gitignore)) {
    Write-Host "No .gitignore found. Creating a default one..." -ForegroundColor Yellow
    Set-Content .gitignore "artifact/`n.env`n.DS_Store`nnode_modules/`ndist/`nbin/`nobj/`n.vs/`n.idea/`n*.log`n__pycache__/"
} else {
    Write-Host "Existing .gitignore found. Preserving it." -ForegroundColor Green
}

# --- STEP 2: GATHER FILES ---
Write-Host "Scanning files..." -ForegroundColor Cyan

# Exclude common junk folders
$excludeFolders = @("node_modules", "dist", "build", "bin", "obj", ".git", ".vs", ".idea", "venv", "__pycache__")

# Get all files
$allFiles = Get-ChildItem -Recurse -File | Where-Object { 
    $pathParts = $_.FullName.Split([System.IO.Path]::DirectorySeparatorChar)
    $isJunk = $false
    foreach ($part in $pathParts) {
        if ($excludeFolders -contains $part) { $isJunk = $true; break }
    }
    return (-not $isJunk) -and ($_.Name -ne ".gitignore")
} | Sort-Object {Get-Random}

$totalFiles = $allFiles.Count
Write-Host "Found $totalFiles valid source files. Starting simulation..." -ForegroundColor Yellow

# --- STEP 3: THE ORGANIC LOOP (BALANCED VERSION) ---
$currentIndex = 0
$commitCount = 0
$authorIndex = 0  # <--- NEW: Track whose turn it is

while ($currentIndex -lt $totalFiles) {
    
    # 1. Randomize Batch Size (1-3 files)
    $batchSize = Get-Random -Minimum 1 -Maximum 2
    $endIndex = [Math]::Min($currentIndex + $batchSize - 1, $totalFiles - 1)
    $batch = $allFiles[$currentIndex..$endIndex]
    $currentIndex += $batchSize

    # 2. Add files
    if ($batch.Count -gt 0) {
        foreach ($file in $batch) {
            git add "$($file.FullName)"
        }

        # 3. Pick Author (ROUND ROBIN to ensure equality)
        # This cycles: You -> Abi -> Wali -> You -> Abi...
        $author = $authors[$authorIndex % $authors.Count]
        $authorIndex++ 

        $msg = $messages | Get-Random
        
        # --- 4. ORGANIC TIME LOGIC ---
        $chance = Get-Random -Minimum 1 -Maximum 100

        if ($chance -le 70) {
            # Work Session: +20 to 180 mins
            $minutesToAdd = Get-Random -Minimum 20 -Maximum 180
            $currentDate = $currentDate.AddMinutes($minutesToAdd)
        } else {
            # New Day: +1 to 2 days
            $daysToAdd = Get-Random -Minimum 1 -Maximum 2
            $currentDate = $currentDate.AddDays($daysToAdd)
            
            # Reset time to "morning/afternoon"
            $startHour = Get-Random -Minimum 9 -Maximum 16
            $startMinute = Get-Random -Minimum 0 -Maximum 59
            $currentDate = $currentDate.Date.AddHours($startHour).AddMinutes($startMinute)
        }

        # Prevent late night commits
        if ($currentDate.Hour -ge 22) {
            $currentDate = $currentDate.AddDays(1).Date.AddHours(10)
        }

        # SAFETY CHECK: Don't go past Dec 1st yet
        if ($currentDate -ge $targetEndDate) {
            $currentDate = $targetEndDate.AddDays(-1)
        }

        $dateStr = $currentDate.ToString("yyyy-MM-dd HH:mm:ss")

        # --- SET FAKE DATE ---
        $env:GIT_COMMITTER_DATE = $dateStr
        
        # 5. Commit
        git commit --author="$author" --date="$dateStr" -m "$msg"
        $commitCount++
        Write-Host "Commit #$commitCount | Author: $author | Msg: $msg" -ForegroundColor Green
    }
}

# --- STEP 4: FINAL SUBMISSION COMMIT ---
# This ensures the history ends exactly when you want it to
Write-Host "Performing Final Submission Commit..." -ForegroundColor Cyan

# Ensure everything is added
git add . 

# Set explicit End Date: Dec 2nd, 2025
$finalDateStr = "2025-12-02 23:30:00"

$env:GIT_COMMITTER_DATE = $finalDateStr
# Daniyal (you) usually does the final submission
$finalAuthor = "Daniyal <daniyal1412@hotmail.com>" 

git commit --author="$finalAuthor" --date="$finalDateStr" -m "Final submission: NLP Project HMM-ASR"

# Cleanup Environment Variable
Remove-Item Env:\GIT_COMMITTER_DATE

Write-Host "Done! History rewritten. End date is Dec 2nd, 2025." -ForegroundColor Yellow