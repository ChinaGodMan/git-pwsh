param (
    [string]$name, # 仓库名称
    [string]$description, # 仓库描述
    [bool]$private         # 是否私有
)
if (-not $name) {
    Write-Host "仓库名称不能为空，脚本退出。"
    exit
}
if (-not $description) {
    $description = "自动创建仓库 人民的勤务员 china.qinwuyuan@gmail.com"
}
if ($null -eq $private) {
    $private = $false
}
# GitHub Token
$token = "99999999999999999"
$url = "https://api.github.com/user/repos"
$repoData = @{
    name        = $name
    description = $description
    private     = $private
}
$body = $repoData | ConvertTo-Json
$headers = @{
    Authorization = "token $token"
    Accept        = "application/vnd.github+json"
}
try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ContentType "application/json"
    if ($response.id) {
        $scriptPath = $PSScriptRoot
        $rootDrive = [System.IO.Path]::GetPathRoot($scriptPath).TrimEnd('\')
        $targetPath = "$rootDrive\你的存放地址\$name"
        if (-not (Test-Path $targetPath)) {
            New-Item -Path $targetPath -ItemType Directory
        }
        Set-Content -Path "$targetPath\README.md" -Value " # 自动创建仓库 人民的勤务员 <china.qinwuyuan@gmail.com> :octocat:"
        Set-Location $targetPath
        $convertedPath = $targetPath -replace '\\', '/'
        git init --initial-branch=main
        git config --system --add safe.directory "$convertedPath"
        git remote add origin $response.ssh_url
        git add .
        git commit -m ":octocat: "
        git push -u origin "main"
        Write-Host "仓库初始化并推送成功。"
    }
    else {
        Write-Host "仓库创建失败：" $response.message
    }
}
catch {
    Write-Host "请求出错：" $_.Exception.Message
}
