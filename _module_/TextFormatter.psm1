function Format-TextContent {
	param(
		[string]$filePath
	)

	# Read the content from the specified file
	$content = Get-Content -Path $filePath
	$content = $content | Where-Object { $_.Trim() -ne "" }
	#$lineCount = $content.Count

	if ($content.Count -eq 1) {
		#Write-Host "文本内容只有一行,我要直接返回了: $lineCount"
		return $content -join "`n"
	}
	# Skip the first line for backtick replacement, process the rest
	$firstLine = $content[0]
	$restOfContent = $content[1..($content.Length - 1)] -replace '`(.*?)`','[$1]'

	# Combine the first line with the processed content
	$content = @($firstLine) + $restOfContent

	# Trim and filter out empty lines
	$content = $content | ForEach-Object { $_.TrimStart() }


	# Remove specific symbols
	$content = $content -replace "\*\*","" # Remove "**"
	$content = $content -replace "###","" # Remove "###"
	$content = $content -replace "•","" # Remove "•"

	# Add "+ " in front of all lines except the first one
	$content = $content | ForEach-Object {
		if ($_.Equals($content[0])) {
			$_ # Keep the first line unchanged
		}
		else {
			if ($_ -like "*Co-authored-by*") {
				$_ # 如果行包含 "Co-authored-by"，则不添加前缀
			}
			else {
				"* " + $_ # 否则在前面添加 "* "
			}
		}
	}

	# Check if the first line starts with whitespace and trim it
	if ($content[0].Length -gt 0 -and [char]::IsWhiteSpace($content[0][0])) {
		$content[0] = $content[0].Substring(1)
	}

	# Return the formatted text
	return $content -join "`n"
}
