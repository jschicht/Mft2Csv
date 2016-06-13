#############
# Powershell script to split very large csv files
# Example command that split input csv into smaller csv's of 500000 lines in each, and preserving csv header:
# SplitCsv.ps1 C:\temp\Mft_2015-10-04_00-41-41.csv -d C:\temp\Output -l 500000
#############
[CmdletBinding(DefaultParameterSetName='Path')]
param(

	[Parameter(ParameterSetName='Path', Position=1, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
	[String[]]$Path,

	[Alias('d')]
	[Parameter(Position=2)]
	[String]$Destination='.',
	
	[Alias('l')]
	[Parameter(Position=3,Mandatory=$true)]
	[Int32]$TargetLines

)

$InputFile = $Path
If(!(Test-Path $Destination)){Throw "Error: Destination path does not exist";}
If(!(Test-Path $InputFile)){Throw "Error: Input file does not exist";}

$sw = new-object System.Diagnostics.Stopwatch
$sw.Start()
Write-Host "Reading source file..."
$lines = [System.IO.File]::ReadAllLines($InputFile)
$totalLines = $lines.Length

Write-Host "Total Lines :" $totalLines

$skip = 0
$count = $TargetLines; # Number of lines per file

# File counter, with sort friendly name
$fileNumber = 1
$fileNumberString = $filenumber.ToString("000")

while ($skip -le $totalLines) {
    $upper = $skip + $count - 1
    if ($upper -gt ($lines.Length - 1)) {
        $upper = $lines.Length - 1
    }

	$FileChunk = Join-Path $Destination "result$fileNumberString.csv"
	
    # Write the lines
	if($skip){
		Set-Content $FileChunk –value $lines[0]
		Add-Content $FileChunk –value $lines[$skip..$upper]
	}
    Else{
		[System.IO.File]::WriteAllLines($FileChunk, $lines[($skip..$upper)])
	}

    # Increment counters
    $skip += $count
    $fileNumber++
    $fileNumberString = $filenumber.ToString("000")
}

$sw.Stop()

Write-Host "Split complete in " $sw.Elapsed.TotalSeconds "seconds"