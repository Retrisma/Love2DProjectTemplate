Write-Output "Starting..."
$name = Read-Host "Enter the name of the tileset image"
$folderpath = -join("./Tiled/Tilesets/", $name)
New-Item -Path $folderpath -ItemType Directory
Copy-Item -Path "./Tiled/Tilesets/Template/*" -Destination $folderpath -Force -Recurse

$folderpathall = -join($folderpath, "/*")

Get-ChildItem $folderpathall | Rename-Item -NewName {$_.name -replace "Template", $name}

$pathToFile = -join($folderpath, "/", $name, ".tsx")
(Get-Content $pathToFile).replace('Template', $name) | Set-Content $pathToFile

$pathToFile = -join($folderpath, "/", $name, "-rules.tmx")
(Get-Content $pathToFile).replace('Template', $name) | Set-Content $pathToFile

$line = -join("`n../Tilesets/", $name, "/", $name, "-rules.tmx")
$rulesappend = -join($line, $line)
Add-Content "./Tiled/Maps/rules.txt" $rulesappend