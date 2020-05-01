param (
	[string]$path = "*",
	[string]$output = "output.csv",
	[switch]$includeloc = $false
)

# Define class to hold csv rows with two columns: Name and Version
class CsvRow {
	[string] ${Name}
	[string] ${Version}
}
class CsvRowLoc {
	[string] ${Name}
	[string] ${Version}
	[string] ${Location}
}

# Recursively get all .dll and .exe files in the supplied path.
Write-Output "Recursively searching $path for all .dll and .exe files..."
$files = Get-ChildItem $path -recurse -include *.dll,*.exe

if ($files.Count -eq 0) {
	Write-Output "No .dll or .exe files were found."
	return
}

# Loop through each file.
[array] $array = $files | Foreach-Object {
	$version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_)
	
	# Could use $_.FileVersion, but that isn't always updated.
	$fullVersion = $version | Foreach-Object { 
		[Version](($_.FileMajorPart, $_.FileMinorPart, $_.FileBuildPart, $_.FilePrivatePart)-join'.') 
	}
	
	# Build CSV row from name and version of file.
	if ($includeloc) {
		$rowObj = [CsvRowLoc]::new()
		$rowObj.'Name' = $_.Name
		$rowObj.'Version' = $fullVersion
		$rowObj.'Location' = $_.FullName
	} else {
		$rowObj = [CsvRow]::new()
		$rowObj.'Name' = $_.Name
		$rowObj.'Version' = $fullVersion
	}
	
	# Return the row so it is added to the $array.
	$rowObj
}

Write-Output "Writing file versions to $output..."

if ($includeloc) {
	# Sort the array and remove duplicate values (rows containing the same name and version).
	$array = $array | Sort-Object -Property Name, Version, Location
} else {
	$array = $array | Sort-Object -Property Name, Version -Unique
}


# Write the $array into the supplied output file.
$array | Export-Csv $output -NoTypeInformation

Write-Output "Finished."
