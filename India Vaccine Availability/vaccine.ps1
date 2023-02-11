function Speak($msg)
{
    $speak.speak($msg)
}
Clear-Host
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$msg=""
$flag = 1
$districtid=0
Clear-Host
if($null -eq $districtid -or $districtid -eq 0)
{
    $msg="Enter your district name="
    speak $msg.split('=')[0]
    Write-Host $msg -NoNewline
    $district=read-host
    $execution=$true
    $stateid=1
    do
    {
        try
        {
            $uri = "https://cdn-api.co-vin.in/api/v2/admin/location/districts/$stateid" 
            $webData = Invoke-RestMethod -Uri $uri
            if($webdata.districts -match $district)
            {
                $execution=$false
                $districtid=($webdata.districts -match $district).district_id
                if($districtid)
                {
                    $msg="District $district found in the list with below district code:"
                    write-host $msg
                    ""
                    $districtid
                    ""
                    speak $msg
                    speak $districtid
                    break
                }
            }
            $webdata=$uri=$null
            $stateid++
        }
        catch
        {
            write-host "Error received `n $_"
            break
        } 
    }while($execution -and $stateid -lt 40)
 }
if($districtid)
{
    $msg="Please enter desired slot date in format of dd-mm-yyyy="
    speak $msg.split('=')[0]
    write-host $msg -NoNewline
    $date = Read-Host

    do
    {
        $msg="Please enter minimum age limit="
        speak $msg.split('=')[0]
        Write-Host $msg -NoNewline
        [int]$minAgeLimit = Read-Host # 18 or 45
    }
    while($minAgeLimit.GetType().Name -ne 'Int32')

    if($districtid -eq '')
    {
        $districtid = 395 # default value
    }
    try
    {
        do
        {
        $uri = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=$districtid&date=$date"
        $webData = Invoke-RestMethod -Uri $uri
        $dataCount = 0
        $sr=0
        $blocklist=@()
        if($null -ne $webData.sessions -and $webData.sessions.Count -gt 0)
        {
            foreach($session in $webData.sessions)
            {
                if($null -eq $session.min_age_limit -OR $session.min_age_limit -lt $minAgeLimit)
                {
                    $list=[PSCustomObject]@{
                        'Sr No' = $sr++
                        'Name'=$($session.name)
                        'Address'=$($session.Address)
                        'Vaccine'=$($session.Vaccine)
                        'Pincode'=$($session.pincode)
                        'Available Capacity'=$($session.available_capacity)
                    }
                    $blocklist+=$list
                    $dataCount++
                }          
            }
            
        }
        
        if($dataCount -eq 0)
        {
            Write-Host "No slot available." -ForegroundColor White -BackgroundColor Red
            $speak.Speak("No slot available.")
        }
        else
        {
            $msg = "Please find the vaccine availability details."
            $speak.Speak($msg)
            $finallist=$blocklist | Format-Table
            #$finallist | ForEach-Object { write-host $_ -ForegroundColor Green}
            $finallist
            [console]::beep(3000,500)
        }
        }while($flag -eq 0)
    }
    catch{
        write-error "An Error Occurred."
    }
}
else 
{
     $msg="No District ID found for $district district." 
     write-host $msg -ForegroundColor White -BackgroundColor Red
     speak $msg
}
