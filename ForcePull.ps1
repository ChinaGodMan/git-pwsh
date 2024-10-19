#NOTE - 重回本地头,防止与远端冲突,拉取远端内容
Write-Host "警告: 这个操作将丢失所有本地未提交的更改并强制拉取远程仓库的内容."
$confirmation = Read-Host "是否继续? (Y/N)"
if ($confirmation -ne 'Y') {
    Write-Host "操作已取消."
    exit
}
Write-Host "正在重置本地分支..."
git reset --hard HEAD
Write-Host "正在拉取远程仓库..."
git fetch origin
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
Write-Host "操作完成."
