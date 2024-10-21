# ANSI 转义码
$colorReset = "`e[0m" # 重置颜色
$infoColor = "`e[32m" # 绿色
$pathColor = "`e[34m" # 蓝色

# 读取 JSON 文件内容
$jsonFilePath = "$PSScriptRoot/types.json"
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
function Get-PathByIndex {
	param(
		[int]$Index
	)
	# 检查输入的序号
	if ($Index -gt 0 -and $Index -le $jsonContent.operatelist.Count) {
		$selectedOperate = $jsonContent.operatelist[$Index - 1].operate
		$path = $selectedOperate.Path

		return $path # 返回路径
	}
	else {
		return $null
	}
}
function Show-PathsTable {
	$tableData = @()
	for ($i = 0; $i -lt $jsonContent.operatelist.Count; $i++) {
		$operate = $jsonContent.operatelist[$i].operate
		$info = $operate.info
		$path = $operate.Path
		$infoColor = $operate.infoColor
		$tableData += [pscustomobject]@{
			Index = $i + 1
			info = "${infoColor}$info${colorReset}"
			Path = "${pathColor}$path${colorReset}"
		}
	}
	$tableData | Format-Table -AutoSize
}
