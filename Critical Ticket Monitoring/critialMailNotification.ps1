#Function to fire up system tray notifications
Function TaskTrayAlert()
{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Data Entry Form'
    $form.Size = New-Object System.Drawing.Size(1920,1080)
    $form.StartPosition = 'CenterScreen'
    $Form.BackColor = 'Red'

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Critical Ticket received. Please act quickly'
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)
    $form.Topmost = $true
    $form.ShowDialog()
}

$exit=$true
$info = New-Object -ComObject Outlook.Application
$objNamespace = $info.GetNamespace("MAPI")

#Code to search inbox
do {
    $allCrticalTicket=$colItems=$objFolder=$null
	$skipsleep=$false
    $objFolder = $objnamespace.Folders.Item('shishir.kushawaha').Folders.item("Critical Tickets")
    $colItems = $objFolder.Items
	$crticalCsv="c:\temp\criticalTicket.csv"
	$allCrticalTicket= import-csv $crticalCsv
    foreach ($item in $colItems) 
    {
		$ticket=$null
		$ticket=$item.subject.split(' ')[0]
		if($ticket -notin $allCrticalTicket.incidentnumber)
		{
			"$ticket is added to the list"
			$item | select subject,creationtime,@{ Name = 'IncidentNumber';  Expression = {$_.subject.split(' ')[0]}} | Export-Csv $crticalCsv -notypeinformation -append
			TaskTrayAlert
			$skipsleep=$true
		}
		else
		{
			$skipsleep=$false
		}
    }
		
		if(!$skipsleep){"Resting for 300 sec";Start-Sleep 300;}
} while ($true -and $exit)
