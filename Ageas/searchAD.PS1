function Get-User ($UserName) 
{
  $searcher = new-object DirectoryServices.DirectorySearcher([ADSI]"")
  $searcher.filter = "(&(objectClass=user)(sAMAccountName= $UserName))"
  $Searcher.CacheResults = $true
  $Searcher.SearchScope = “Subtree”
  $Searcher.PageSize = 1000
  $searcher.findall()
}
