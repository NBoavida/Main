Function Get-FolderSize
{
	BEGIN
	{
		$fso = New-Object -comobject Scripting.FileSystemObject
	}
	PROCESS
	{
		$path = $input.fullname
		$folder = $fso.GetFolder($path)
		$size = $folder.size /1GB
		[PSCustomObject]@{'Name' = $path;'SizeGB' = "{0:N3}" -f $size; 'SizeNum' = $size }
	}
}

# Get-ChildItem -Directory -Recurse -EA 0 | Get-FolderSize | sort SizeNum -descending | select Name, SizeGB -first 10 | ft -autosize

Get-ChildItem -recurse | Where{$_.Mode -like "d*"} | Get-FolderSize | sort SizeNum -descending | select Name, SizeGB -first 10 | ft -autosize

