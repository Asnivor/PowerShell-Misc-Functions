Function Get-NSLookup
{
<#
.SYNOPSIS
			Performs NS lookup of domain to find available records
.DESCRIPTION
			<Description of function>
.PARAMETER
			<Input params and descriptions>
.RETURNS
			<What the function returns>
.EXAMPLE
			Get-NSLookup -domain "somedomain"
#>
  	Param
	(
	    $domain
	)  
  	Begin
	{
    	$getFunctionName = '{0}' -f $MyInvocation.MyCommand
		Write-Terminal "INFO: Function $getFunctionName started." 
 	}  
  	Process
	{
    	Try
		{
            # instantiate records strings
            $recordA = ""
            $recordMX = ""
            $recordTXT = ""
            $recordNS = ""
            $recordSOA = ""
           
            # get root A records
      		$args = "$domain";
            $Records = nslookup.exe $domain 2`>`&1
            
            #split into array based on new lines
            $RecordsArr = $Records -split "`n"
            $count = $RecordsArr.Count
            
            # start on 4th line
            for ($i = 3; $i -le $count; $i++)
            {
                $recordA = $recordA + $RecordsArr[$i] + "`n"
            }
            #$recordA
            

            # get MX records
      		$args = "-querytype=mx $domain";
            #$Records = nslookup.exe $args 2`>`&1
            $Records = nslookup.exe -querytype=mx $domain 2`>`&1
            
            #split into array based on new lines
            $RecordsArr = $Records -split "`n"
            $count = $RecordsArr.Count
            
            # start on 4th line
            for ($i = 3; $i -le $count; $i++)
            {
                $recordMX = $recordMX + $RecordsArr[$i] + "`n"
            }
            #$recordMX

            # get TXT records
      		$args = "-querytype=txt $domain";
            #$Records = nslookup.exe $args 2`>`&1
            $Records = nslookup.exe -querytype=txt $domain 2`>`&1
            
            #split into array based on new lines
            $RecordsArr = $Records -split "`n"
            $count = $RecordsArr.Count
            
            # start on 4th line
            for ($i = 3; $i -le $count; $i++)
            {
                $recordTXT = $recordTXT+ $RecordsArr[$i] + "`n"
            }
            #$recordTXT
            <#
            # get NS records
      		$args = "-querytype=ns $domain";
            #$Records = nslookup.exe $args 2`>`&1
            $Records = nslookup.exe -querytype=txt $domain 2`>`&1
            
            #split into array based on new lines
            $RecordsArr = $Records -split "`n"
            $count = $RecordsArr.Count
            
            # start on 4th line
            for ($i = 3; $i -le $count; $i++)
            {
                $recordNS= $recordNS+ $RecordsArr[$i] + "`n"
            }
            #$recordSPF
            #>

            # get SOA records
      		$args = "-querytype=srp $domain";
            #$Records = nslookup.exe $args 2`>`&1
            $Records = nslookup.exe -querytype=soa $domain 2`>`&1
            
            #split into array based on new lines
            $RecordsArr = $Records -split "`n"
            $count = $RecordsArr.Count
            
            # start on 4th line
            for ($i = 3; $i -le $count; $i++)
            {
                $recordSOA= $recordSOA+ $RecordsArr[$i] + "`n"
            }
            #$recordSRP

            # build output string
            $oString = "NSLOOKUP Result for $domain `n***Please consult nameserver for ALL records***`n----------------------`n`n"
            $oString = $oString + "SOA Records`n----------------------`n`n" + $recordSOA + "`n"
            $oString = $oString + "A Records`n----------------------`n`n" + $recordA + "`n"
            $oString = $oString + "MX Records`n----------------------`n`n" + $recordMX + "`n"
            $oString = $oString + "TXT Records`n----------------------`n`n" + $recordTXT + "`n"
            #$oString = $oString + "NS Records`n----------------------`n`n" + $recordNS + "`n"
            

            return $oString
    	}    
    	Catch
		{
      		LogError -ErrorDesc $_.Exception -ExitGracefully $True
       		Break
    	}
  	}  
 	End
	{
    	If($?)
		{			
		 	Write-Terminal "INFO: Execution of function $getFunctionName completed successfully."   
    	}
  	}
