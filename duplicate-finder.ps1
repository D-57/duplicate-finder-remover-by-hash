# ============================================================
# FIND DUPLICATE FILES
# ------------------------------------------------------------
# Scans all files recursively from the current directory.
# First groups files by size (faster).
# Then calculates SHA256 hashes for files with matching sizes.
# Displays groups of files that have identical content.
# ============================================================

Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
Group-Object Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Get-FileHash -Algorithm SHA256
} |
Group-Object Hash |
Where-Object { $_.Count -gt 1 }





# ============================================================
# LIST ALL DUPLICATE FILE PATHS
# ------------------------------------------------------------
# Finds duplicate files based on SHA256 hash and prints the
# full paths of every duplicate file found.
# Useful for reviewing duplicates before taking any action.
# ============================================================

Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
Group-Object Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Get-FileHash -Algorithm SHA256
} |
Group-Object Hash |
Where-Object { $_.Count -gt 1 } |
ForEach-Object { $_.Group.Path }



# ============================================================
# PREVIEW DUPLICATE FILE DELETION (SAFE MODE)
# ------------------------------------------------------------
# Finds duplicate files and simulates deletion.
# Keeps the first copy of each file and marks the remaining
# duplicates for removal.
# The -WhatIf parameter prevents actual deletion and shows
# what would happen.
# ============================================================

Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
Group-Object Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Get-FileHash -Algorithm SHA256
} |
Group-Object Hash |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Select-Object -Skip 1 | Remove-Item -WhatIf
}



# ============================================================
# DELETE DUPLICATE FILES
# ------------------------------------------------------------
# Finds duplicate files using SHA256 hashes.
# Keeps the first occurrence of each file.
# Permanently deletes all remaining duplicate copies.
#
# WARNING:
# This operation cannot be undone.
# Run the preview script above first.
# ============================================================

Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
Group-Object Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Get-FileHash -Algorithm SHA256
} |
Group-Object Hash |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Select-Object -Skip 1 | Remove-Item -Force
}



# ============================================================
# MOVE DUPLICATE FILES TO A SEPARATE FOLDER
# ------------------------------------------------------------
# Creates a destination folder for duplicates.
# Finds duplicate files using SHA256 hashes.
# Keeps the first occurrence of each file.
# Moves all additional duplicate copies into the specified
# folder instead of deleting them.
#
# Replace "YOUR_PATH" with the desired destination folder.
# ============================================================

$dupFolder = "YOUR_PATH"
New-Item -ItemType Directory -Path $dupFolder -Force

Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
Group-Object Length |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Get-FileHash -Algorithm SHA256
} |
Group-Object Hash |
Where-Object { $_.Count -gt 1 } |
ForEach-Object {
    $_.Group | Select-Object -Skip 1 | Move-Item -Destination $dupFolder
}