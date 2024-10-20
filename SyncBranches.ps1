# clean remote branches history
<# 清理远程已经被删除但是本地还存在的分支,同步所有分支 #>
git remote prune origin
$current_local_branch = git branch | ForEach-Object { if ($_ -match '\* (.+)') { $matches[1].Trim() } }
$all_remote_branches = git branch --remotes | ForEach-Object {
	($_ -replace 'origin/','' -replace 'HEAD -> master','').Trim()
}
$current_dir = Get-Location
$repo_dir = git rev-parse --show-toplevel
Set-Location $repo_dir
foreach ($remote_branch in $all_remote_branches) {
	git checkout $remote_branch
	git pull
}
git checkout $current_local_branch
Set-Location $current_dir
