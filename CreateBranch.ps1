#NOTE - 方便创建新分支
$newBranchName = Read-Host "新分支名称"
if ([string]::IsNullOrWhiteSpace($newBranchName)) {
    Write-Host "分支名称不能为空，操作取消."
    exit
}
Write-Host "正在创建并切换到分支 '$newBranchName'..."
git checkout -b $newBranchName
Write-Host "正在推送分支 '$newBranchName' 到远程仓库..."
git push -u origin $newBranchName
Write-Host "分支 '$newBranchName' 创建并推送成功."
