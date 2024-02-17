Function Format-NeatXML {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage="Raw XML")] [xml]$rawXML
    )

    $Indent = 2
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $rawXml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()

    return $StringWriter.ToString()
}
    
Export-ModuleMember -Function Format-NeatXML