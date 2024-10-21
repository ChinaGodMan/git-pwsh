param(
	[string]$messageFilePath,
	[string]$customMessage
)
#导入模块
$modulePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "_module_"
$moduleFiles = Get-ChildItem -Path $modulePath -Filter *.psm1
foreach ($module in $moduleFiles) {
	Import-Module -Name $module.FullName -Force -ErrorAction Stop
}
#是否在此次流程中使用文件内容
$nousefile = $false
$default = ":octocat: 更新文件"
$scriptPath = $PSScriptRoot
$rootDrive = [System.IO.Path]::GetPathRoot($scriptPath).TrimEnd('\')
#检查md5是否有变动
$hasChanges = git status --porcelain | Where-Object { $_ -ne "" }
if (-not $hasChanges) {
	Write-Host "`e[32m 没有检测到更改 `e[0m"
	exit
}
$keyID = "88888888888888888"
$privateKeyPath = "$rootDrive\GitHub\C111111111111111n-私钥.asc"
$secretKey = gpg2 --list-secret-keys $keyID 2>&1
if ($secretKey -like "*china.12223324@gmail.com*") {
	#Write-Host "私钥 $keyID 已存在。"
}
else {
	gpg2 --import $privateKeyPath
}
# 设置文件路径
if (-not $messageFilePath) {
	$messageFilePath = (Get-Location).Path + "\.messages"
}
if (-not (Test-Path $messageFilePath)) {
	$default | Out-File -FilePath $messageFilePath -Encoding UTF8
}
$currentDateTime = Get-Date -Format "yyyy/M/d HH:mm:ss"
$result = Set-FileMd5Record -FilePath $messageFilePath
if ($result -eq $true) {
	<#     #NOTE - 保留 [内容变化 ]
	$newCommitMessage = Get-Content $messageFilePath -Raw
	$commitMessage = $newCommitMessage -replace '\$currentDateTime',$currentDateTime #>
} elseif ($result -eq $false) {
	#内容无变化
	$commitMessage = $default
	$nousefile = $true
}
if ($customMessage -ne "") { #使用这个自定义信息.
	$nousefile = $true
	$commitMessage = $customMessage -replace '\{Time\}',$currentDateTime
}
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($LASTEXITCODE -ne 0) {
	Write-Error "无法获取当前分支名称"
	exit 1
}
if (-not $nousefile) {
	# 使用文件内容构建提交消息
	$commitMessage = Format-TextContent -FilePath $messageFilePath
}
# 兜底检查
if ($commitMessage -eq "") {
	$commitMessage = $default
}
Write-Host "当前分支: $currentBranch" -ForegroundColor Cyan
Write-Host "使用的提交信息: $commitMessage" -ForegroundColor Cyan
#ANCHOR - 推送
git add .
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
	Write-Error "提交失败"
	Set-FileRecord -FilePath $messageFilePath
	exit 1
}
Write-Host "推送到远程仓库的分支 $currentBranch..."
git push origin $currentBranch --force
if ($LASTEXITCODE -ne 0) {
	Write-Error "推送失败"
	Set-FileRecord -FilePath $messageFilePath
	exit 1
}
Write-Host "推送GitHub已完成!"
