#NOTE - 推送工作区所有仓库到远端
$scriptPath = $PSScriptRoot
$rootDrive = [System.IO.Path]::GetPathRoot($scriptPath).TrimEnd('\')
$jsonFilePath = "$rootDrive\仓库.code-workspace"
$blacklist = @("UserScripts", "Loc")
$jsonContent = Get-Content -Path "$jsonFilePath" -Raw | ConvertFrom-Json
foreach ($folder in $jsonContent.folders) {
    $name = $folder.name
    $path = $folder.path
    $folderName = Split-Path -Leaf $path
    if ($folderName -in $blacklist) {
        Write-Host "跳过黑名单仓库: $path ($name)"
        continue
    }
    Write-Host "进入仓库: $path ($name)"
    if (Test-Path -Path $path) {
        Set-Location -Path $path
        Write-Host "正在执行:....."
        git pull origin main
        git add  .
        git commit  -m "统一推送......"
        git push origin main
    }
    else {
        Write-Host "目录不存在: $path"
    }
    Write-Host "-----------------------------------"
}
