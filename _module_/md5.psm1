function Set-FileMd5Record {
	param(
		[string]$filePath
	)
	$jsonFilePath = Join-Path -Path $PSScriptRoot -ChildPath ".MeseagesFilesMd5.json"
	if (-not (Test-Path $filePath)) {
		Write-Error "文件不存在: $filePath"
		return
	}
	#!SECTION 获取md5
	$fileMd5 = (Get-FileHash -Path $filePath -Algorithm MD5).Hash
	# 检查 JSON 文件是否存在，如果不存在则创建空的内容
	if (Test-Path $jsonFilePath) {
		# NOTE -  JSON内容并转换为哈希表
		$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
		$hashTable = @{}
		foreach ($key in $jsonContent.PSObject.Properties.Name) {
			$hashTable[$key] = $jsonContent.$key
		}
	} else {
		$hashTable = @{}
		Write-Host "JSON 文件不存在，创建新的文件。"
	}
	$parentDirName = $filePath.Replace(":","").Replace("\","/")
	# 检查哈希表中是否已经有该目录的记录
	if ($hashTable.ContainsKey($parentDirName)) {
		if ($hashTable[$parentDirName] -eq $fileMd5) {
			return $false #md5未改变
		} else { #md5改变
			$hashTable[$parentDirName] = $fileMd5
		}
	} else {
		$hashTable[$parentDirName] = $fileMd5
	}
	$hashTable | ConvertTo-Json -Depth 100 | Set-Content -Path $jsonFilePath -Force
	return $true
}
function Set-FileRecord {
	param(
		[string]$filePath
	)
	$jsonFilePath = Join-Path -Path $PSScriptRoot -ChildPath ".MeseagesFilesMd5.json"
	$parentDirName = $filePath.Replace(":","").Replace("\","/")
	$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
	$hashTable = @{}
	foreach ($key in $jsonContent.PSObject.Properties.Name) {
		$hashTable[$key] = $jsonContent.$key
	}
	$hashTable[$parentDirName] = "11111"
	$hashTable | ConvertTo-Json -Depth 100 | Set-Content -Path $jsonFilePath -Force

}

