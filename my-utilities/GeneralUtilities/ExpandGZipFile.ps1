# Totally researched and implented based on 
# https://scatteredcode.net/download-and-extract-gzip-tar-with-powershell/
Function Expand-GZipFile{
    Param(
        [Parameter(Mandatory=$true, HelpMessage="Full file path of the gzip file")] [String]$infile,
        [Parameter(Mandatory=$true, HelpMessage="Directory where the file will be expanded ")] [String]$destinationPath
    )

    $outfile = (Join-path $destinationPath (Get-Item $infile).Name) -Replace '\.gz$',''
    $input = New-Object System.IO.FileStream $inFile, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
    $output = New-Object System.IO.FileStream $outFile, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
    $gzipStream = New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress)

    $buffer = New-Object byte[](1024)
    while($true){
        $read = $gzipstream.Read($buffer, 0, 1024)
        if ($read -le 0){break}
        $output.Write($buffer, 0, $read)
    }

    $gzipStream.Close()
    $output.Close()
    $input.Close()
}
Export-ModuleMember -Function Expand-GZipFile