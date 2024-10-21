function Format-TextContent {
	param(
		[string]$filePath
	)
	$content = Get-Content -Path $filePath
	$content = $content | Where-Object { $_.Trim() -ne "" }
	if ($content.Count -eq 1) {
		return $content -join "`n"
	}
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
				"`n" + $_ # 如果行包含 "Co-authored-by"，则不添加前缀
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
