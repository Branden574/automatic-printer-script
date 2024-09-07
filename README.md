Printer Installation Script - README
Overview
This PowerShell script simplifies the installation of network printers by automating the process of selecting a printer's IP address, name, and driver. It provides a graphical interface to input printer details, making it easier for users to configure multiple printers without manually using commands.

Features
Interactive GUI: Uses Windows Forms to create a dialog for printer IP input, driver selection, and naming.
Multiple Printer Support: Allows the user to configure up to 5 printers in one session.
Driver Selection: Offers a pre-defined list of drivers that the user can choose from during installation.
Automated Printer Installation: Once the details are provided, the script installs the printer automatically using PowerShell commands.
Requirements
PowerShell 5.0 or higher
Windows OS
Admin privileges (to install printers)
.NET Framework (for Windows Forms usage)
How It Works
Printer IP Input: The user is prompted to enter the printer's IP address through a dialog box.
Driver Selection: The user is provided with a drop-down list of available printer drivers to choose from.
Printer Naming: After the driver selection, the user is prompted to provide a name for the printer.
Printer Installation: Once all inputs are provided, the script installs the printer using the Add-Printer and Add-PrinterPort PowerShell commands.
Loop for Multiple Printers: The script allows up to 5 printers to be configured in one execution.
Usage Instructions
Run the Script:

Open PowerShell as an Administrator.
Execute the script.
powershell
Copy code
.\PrinterInstallationScript.ps1
Input Printer Details:

Follow the prompts to input each printer's IP address, select the printer driver, and provide the printer name.
Printer Installation:

The script will automatically install each printer based on the provided details. You will see messages indicating successful installations.
Optional: Exit Early:

If you wish to exit early (e.g., you don’t need to install all 5 printers), simply leave the IP address field blank when prompted. The script will stop.

Customization
Adding More Drivers: To add more driver options, modify the $driverOptions array in the script: $driverOptions = @(
    "Xerox Global Print Driver PCL6",
    "HP Universal Printing PCL 6",
    "Your Additional Driver Here"
)

Adjust Number of Printers: By default, the script supports configuring up to 5 printers. You can adjust this by modifying the loop: for ($i = 1; $i -le 5; $i++) {
Change 5 to the desired number of printers.

Troubleshooting
Missing Driver Error: Ensure that the selected printer driver is installed on the system. You can verify available drivers using: Get-PrinterDriver
Admin Privileges: Make sure to run PowerShell as an administrator, as printer installation requires elevated permissions.

License
This script is open-source and can be modified and redistributed as needed.

