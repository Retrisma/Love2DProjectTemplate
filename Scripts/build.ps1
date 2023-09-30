Write-Output "Starting..."
Remove-Item ".\Release\*" -Recurse -Force
New-Item -Path ".\Release\source" -ItemType Directory
$exclude = @("FMOD","Release",".git","Scripts",".gitattributes",".gitignore")
$files = Get-ChildItem -Path . -Exclude $exclude
Compress-Archive -Path $files -DestinationPath .\Release\source\game.zip -Force
$foldername = Get-ItemPropertyValue -Path . -Name Name
$ext = -join($foldername, '.love')
Rename-Item -Path ".\Release\source\game.zip" -NewName $ext -Force
Copy-Item -Path ".\FMOD" -Destination ".\Release\source\FMOD" -Force -Recurse
$ext2 = -join('.\Release\source\', $ext)
$ext3 = -join('.\Release\source\', $foldername, '.exe')
cmd /c copy /b "C:\Program Files\LOVE\love.exe"+$ext2 $ext3
Remove-Item $ext2
Copy-Item -Path "C:\Program Files\LOVE\*.dll" ".\Release\source"
Copy-Item -Path "C:\Program Files\LOVE\license.txt" ".\Release\source"
Copy-Item -Path ".\*.dll" ".\Release\source"
$ext4 = -join(".\Release\", $foldername, ".zip")
Compress-Archive -Path ".\Release\source\*" -DestinationPath $ext4 -Force
Write-Output "Finished"