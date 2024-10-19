function Format-TextContent {
    param (
        [string]$filePath
    )
    $content = Get-Content -Path $filePath
    $content = $content | Where-Object { $_.Trim() -ne "" }
    if ($content.Count -eq 1) {
        return $content -join "`n"
    }
    $firstLine = $content[0]
    $restOfContent = $content[1..($content.Length - 1)] -replace '`(.*?)`', '[$1]'
    $content = @($firstLine) + $restOfContent
    $content = $content | ForEach-Object { $_.TrimStart() }
    $content = $content -replace "\*\*", ""  
    $content = $content -replace "###", ""  
    $content = $content -replace "•", ""     
    $content = $content | ForEach-Object {
        if ($_.Equals($content[0])) {
            $_  
        }
        else {
            if ($_ -like "*Co-authored-by*") {
                $_  
            }
            else {
                "* " + $_  
            }
        }
    }
    if ($content[0].Length -gt 0 -and [char]::IsWhiteSpace($content[0][0])) {
        $content[0] = $content[0].Substring(1)
    }
    # Return the formatted text
    return $content -join "`n"
}