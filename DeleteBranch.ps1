#NOTE - 同时删除本地与远端分支.
git branch 
$branchName = Read-Host "请输入要删除的分支名称"
if ([string]::IsNullOrWhiteSpace($branchName)) {
    Write-Host "分支名称不能为空，操作取消."
    exit
}
Write-Host "正在删除本地分支 '$branchName'..."
git branch -D $branchName 2>$null #强制删除
Write-Host "正在删除远程分支 '$branchName'..."
git push origin --delete $branchName 2>$null
# 检查是否成功删除远程分支
if ($LASTEXITCODE -ne 0) {
    Write-Host "远程分支 '$branchName' 删除失败，可能是因为该分支不存在."
} else {
    Write-Host "远程分支 '$branchName' 删除成功."
}
