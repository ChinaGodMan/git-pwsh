$commitHash = Read-Host "请输入提交哈希"
$choice = Read-Host "请输入操作选项：0 (保留更改并回退到指定提交)、1 (丢弃更改并回退到指定提交)、2 (回退到上一个提交)"
switch ($choice) {
	0 {
		git reset --soft $commitHash
		Write-Host "已执行: git reset --soft $commitHash"
	}
	1 {
		git reset --hard $commitHash
		Write-Host "已执行: git reset --hard $commitHash"
	}
	2 {
		git reset --hard HEAD
		Write-Host "已执行: git reset --hard HEAD"
	}
	default {
		Write-Host "无效的选项，请输入 0、1 或 2。"
	}
}
