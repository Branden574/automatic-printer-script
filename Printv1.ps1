Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-PrinterInstallDialog {
    param (
        [string]$title,
        [string]$prompt
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"

    $label = New-Object Windows.Forms.Label
    $label.Text = $prompt
    $label.AutoSize = $true
    $label.Location = New-Object Drawing.Point(10, 30)
    $form.Controls.Add($label)

    $textBox = New-Object Windows.Forms.TextBox
    $textBox.Location = New-Object Drawing.Point(10, 60)
    $textBox.Size = New-Object Drawing.Size(260, 20)
    $form.Controls.Add($textBox)

    $okButton = New-Object Windows.Forms.Button
    $okButton.Location = New-Object Drawing.Point(75, 120)
    $okButton.Size = New-Object Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button
    $cancelButton.Location = New-Object Drawing.Point(175, 120)
    $cancelButton.Size = New-Object Drawing.Size(75, 23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $form.Topmost = $true

    $form.Add_Shown({ $textBox.Select() })
    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } else {
        return $null
    }
}

function Show-PrinterDriverDialog {
    param (
        [string]$title,
        [string]$prompt,
        [string[]]$options
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"

    $label = New-Object Windows.Forms.Label
    $label.Text = $prompt
    $label.AutoSize = $true
    $label.Location = New-Object Drawing.Point(10, 30)
    $form.Controls.Add($label)

    $comboBox = New-Object Windows.Forms.ComboBox
    $comboBox.Location = New-Object Drawing.Point(10, 60)
    $comboBox.Size = New-Object Drawing.Size(260, 20)
    $comboBox.Items.AddRange($options)
    $comboBox.SelectedIndex = 0
    $form.Controls.Add($comboBox)

    $okButton = New-Object Windows.Forms.Button
    $okButton.Location = New-Object Drawing.Point(75, 120)
    $okButton.Size = New-Object Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button
    $cancelButton.Location = New-Object Drawing.Point(175, 120)
    $cancelButton.Size = New-Object Drawing.Size(75, 23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $form.Topmost = $true

    $form.Add_Shown({ $comboBox.Select() })
    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        return $comboBox.SelectedItem.ToString()
    } else {
        return $null
    }
}

function Install-Printer {
    param (
        [string]$printerIP,
        [string]$printerName,
        [string]$driverName
    )

    $portName = "IP_$printerIP"
    Add-PrinterPort -Name $portName -PrinterHostAddress $printerIP -PortNumber 9100

    $driver = Get-PrinterDriver -Name $driverName

    Add-Printer -Name $printerName -DriverName $driver.Name -PortName $portName
}

# Show dialog to input printer IP addresses and select drivers
$printerData = @()
for ($i = 1; $i -le 5; $i++) {
    $ip = Show-PrinterInstallDialog -title "Printer Installation" -prompt "Enter printer IP address $i (e.g., 172.24.4.11):"
    if (![string]::IsNullOrEmpty($ip)) {
        # Define an array of driver options
        $driverOptions = @(
            "Xerox Global Print Driver PCL6",
            "HP Universal Printing PCL 6"
            # Add other driver options here as needed
        )

        # Show dialog to select the driver from the predefined options
        $selectedDriver = Show-PrinterDriverDialog -title "Select Printer Driver" -prompt "Select a printer driver for IP address ${ip}:" -options $driverOptions

        if (![string]::IsNullOrEmpty($selectedDriver)) {
            $printerName = Show-PrinterInstallDialog -title "Printer Installation" -prompt "Enter printer name for IP address ${ip} (e.g., MyPrinter):"
            if (![string]::IsNullOrEmpty($printerName)) {
                $printerData += [PSCustomObject]@{
                    IPAddress = $ip
                    Driver = $selectedDriver
                    PrinterName = $printerName
                }
            } else {
                Write-Output "Printer name input cancelled for IP address $ip."
            }
        } else {
            Write-Output "Driver selection cancelled for IP address $ip."
        }
    } else {
        break
    }
}

if ($printerData.Count -gt 0) {
    foreach ($printerInfo in $printerData) {
        Write-Output "Installing printer for IP address: $($printerInfo.IPAddress)"
        Install-Printer -printerIP $printerInfo.IPAddress -printerName $printerInfo.PrinterName -driverName $printerInfo.Driver
        Write-Output "Printer installation for IP address $($printerInfo.IPAddress) completed."
    }
}
