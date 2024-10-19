param (
    [string]$messageFilePath,
    [string]$customMessage
)
$modulePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "TextFormatter.psm1"
Import-Module $modulePath -Force
$nousefile = $false 
$scriptPath = $PSScriptRoot
$rootDrive = [System.IO.Path]::GetPathRoot($scriptPath).TrimEnd('\')
$green = "`e[32m"
$reset = "`e[0m"
$hasChanges = git status --porcelain | Where-Object { $_ -ne "" }
if (-not $hasChanges) {
    Write-Host "$green 没有检测到更改 $reset"
    exit
}
if (-not $messageFilePath) {
    $messageFilePath = "$rootDrive\1.txt"
}
$keyID = "30F74B7781A8D595" 
$privateKeyPath = "$rootDrive\GitHub\ChinaGodMan-私钥.asc"
$secretKey = gpg2 --list-secret-keys $keyID 2>&1
if ($secretKey -like "*@gmail.com*") {
    #Write-Host "私钥 $keyID 已存在。"
}
else {
    Write-Host "私钥 $keyID 不存在，正在导入..."
    gpg2 --import $privateKeyPath
}
$oldCommitFilePath = "$scriptPath\oldcommitMessage.txt"
if (-not (Test-Path $messageFilePath)) {
    Write-Error "提交信息文件不存在: $messageFilePath"
    exit 1
}
$newCommitMessage = Get-Content $messageFilePath -Raw
$oldCommitMessage = if (Test-Path $oldCommitFilePath) {
    Get-Content $oldCommitFilePath -Raw
}
else {
    "更新"
}
$currentDateTime = Get-Date -Format "yyyy/M/d HH:mm:ss"
if ($newCommitMessage -eq $oldCommitMessage) {
    $commitMessage = "更新"
    $nousefile = $true
}
else {
    $commitMessage = $newCommitMessage -replace '\$currentDateTime', $currentDateTime
}
if ($customMessage -ne "") {
    $nousefile = $true
    $commitMessage = $customMessage -replace '\{Time\}', $currentDateTime
}
Write-Host "当前分支: $currentBranch" -ForegroundColor Cyan
Write-Host "使用的提交信息: $commitMessage" -ForegroundColor Cyan
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($LASTEXITCODE -ne 0) {
    Write-Error "无法获取当前分支名称"
    exit 1
}
if (-not $nousefile) {
    $commitMessage = Format-TextContent -filePath $messageFilePath
}
git add .
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Error "提交失败"
    exit 1
}
# 推送到当前
Write-Host "推送到远程仓库的分支 $currentBranch..."
git push origin $currentBranch --force
if ($LASTEXITCODE -ne 0) {
    Write-Error "推送失败"
    exit 1
}
Write-Host "推送GitHub已完成!"
Copy-Item -Path $messageFilePath -Destination $oldCommitFilePath -Force
