    
#Grundfunktionen    
    
     #CPU
        Get-WmiObject win32_processor | ft -AutoSize Name,NumberOfCores,NumberOfLogicalProcessors
        $CPUpercent =  Get-WmiObject win32_processor | select LoadPercentage 
         {0:n2} -f $CPUpercent
        Get-Counter '\Prozessorinformationen(_Total)\Prozessorauslastung'
        Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

        # Prozessorauslastung alle 5 Sekunden abfragen und ausgeben und 2 Stellen nach Komma
        get-counter -Counter "\\$env:COMPUTERNAME\prozessor(_total)\prozessorzeit (%)" -Continuous -SampleInterval 5 | select -ExpandProperty CounterSamples | select CookedValue | %{[Math]::Round($_.CookedValue,2)}
        Get-Counter '\Memory\Available MBytes'
        Get-Counter '\Processor(_Total)\% Processor Time'
        # list of memeory counters
        Get-Counter -ListSet *memory* | Select-Object -ExpandProperty  Counter

        #load
        Get-WmiObject win32_processor | select LoadPercentage  |fl
        Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

    #Temperatur motherboard
        Get-Class Win32_PerfFormattedData_Counters_ThermalZoneInformation |Select-Object Name,Temperature


    #GPU
        Get-WmiObject Win32_VideoController | Select description,driverversion

    #RAM
        Get-WMIObject -class Win32_Physicalmemory

    #Speicherplatz Laufwerke
        Get-WmiObject Win32_LogicalDisk
        Get-WMIObject Win32_LogicalDisk | Select DeviceID, FileSystem | Format-Table -AutoSize
    #Festplatte
        Get-Wmiobject Win32_Diskdrive
        Get-Disk


####################

#Bauteile einer GUI
 
    #Button
        $Button = New-Object System.Windows.Forms.Button
        $Button.Location = New-Object System.Drawing.Size(75,120)
        $Button.Size=New-Object System.Drawing.Size(75,23)
        $Button.Text = "OK"
        $Button.Name = "OK"
        $Button.DialogResult = "OK"
        $Button.Add_Click({$Fenster.Close()})  #schließt Fenster nach Klick
        $objForm.Controls.Add($Button)

         $Button.Add_Click(
                {
                   
                })

    #Textbox
        $windowTextBox = New-Object System.Windows.Forms.TextBox
        $windowTextBox.Location = New-Object System.Drawing.Size(10,30)
        $windowTextBox.Size = New-Object System.Drawing.Size(500,500)
        $windowTextBox.Multiline = $true
        $Tab1.Controls.Add($windowTextBox)


    #Label
        $TextCPUpercent=New-Object System.Windows.Forms.Label
        $TextCPUpercent.Name="CPU LoadPercentage"
        $TextCPUpercent.Text= $CPUpercent | write-output
        $TextCPUpercent.Location = New-Object System.Drawing.Size(15,30)
        $Tab1.Controls.Add($TextCPUpercent)


   

    # add a Listbox
        $objListBox = New-Object Windows.Forms.Listbox
        $objListBox = New-Object System.Windows.Forms.ListBox
        $objListBox.Location = New-Object System.Drawing.Size(15,10)
        $objListBox.Size = New-Object System.Drawing.Size(550,10)
        $objListBox.Height = 400
  
        # add a save button
            $oButton = New-Object Windows.Forms.Button
            $oButton.Text = "Get Computer Name"
            $oButton.Top = 500
            $oButton.Left = 350
            $oButton.Width = 150
            $oButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
  
            $oButton.add_click({$SaveButton.Text = $env:ComputerName})
            $oButton.add_click({$objListBox.Items.Add($env:ComputerName)})
  
            $oButton.add_click({
  
            $sTemp = Get-Process
  
            $sTemp | % { $item = $_.ProcessName
            $objListBox.Items.Add($item) }
  
            })
  
    # Build the GUI
        $Form = New-Object Windows.Forms.Form
        $Form.Text = "PowerShell Output"
        $Form.Width = 600
        $Form.Height = 600 
  
        $Form.Add_Shown({$Form.Activate()}) 
  
        $Form.controls.add($oButton)
        $Form.controls.add($objListBox)
  
        $Form.ShowDialog()

    #TabControl
        $TabControl = New-Object System.Windows.Forms.TabControl
        $TabControl.Name="Karten Sammlung"
        $TabControl.SelectedIndex=0
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 7
        $System_Drawing_Point.Y = 5
        $TabControl.Location = $System_Drawing_Point
        $TabControl.Name = "tabControl"
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Height = 450
        $System_Drawing_Size.Width = 772
        $TabControl.Size = $System_Drawing_Size
        $objForm.Controls.Add($TabControl)

     #Tab  
        $Tab=New-Object System.Windows.Forms.TabPage
        $Tab.TabIndex=0 #mit jedem neuen Tab wird hochgezählt
        $Tab.Text="Tab"
        $Tab.Name="Name"
        $Tab.Backcolor="white"
        $TabControl.Controls.Add($Tab)

    #Legende 
          $Legend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
          $Legend.IsEquallySpacedItems = $True
          $Legend.BorderColor = 'Black'
          $Chart.Legends.Add($Legend)
          $Chart.Series["Data"].LegendText = "$xx ($xy)"

   ######################
            


#Beispiel für timer. Evtl. für ein Loop bei Prozesse verwendbar

        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 1000
        $timer.add_tick({
        ($Fenster.Controls | ? {$_.name -like "Zeitanzeige"}).Text="{0:HH:mm:ss}" -f (get-date)
        })
        $timer.Enabled = $true


#Beipsiel 2 timer

        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        $window = New-Object System.Windows.Forms.Form
        $window.Width = 1000
        $window.Height = 800
        $Label = New-Object System.Windows.Forms.Label
        $Label.Location = New-Object System.Drawing.Size(10,10)
        $Label.Text = "Text im Fenster"
        $Label.AutoSize = $True
        $window.Controls.Add($Label)

          $i=0
          $timer_Tick={
             $script:i++
             $Label.Text= "$i new text"
          }
          $timer = New-Object 'System.Windows.Forms.Timer'
          $timer.Enabled = $True 
          $timer.Interval = 1000
          $timer.add_Tick($timer_Tick)
 
        [void]$window.ShowDialog()

##################

# Beispiel für multiple form


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Child ($Parentlabel)
{

$ChildForm = New-Object system.Windows.Forms.Form

$textbox1 = New-Object System.Windows.Forms.TextBox
$textbox1.Location = New-Object System.Drawing.Point(20,20)
$ChildForm.Controls.Add($textbox1)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(20,80)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$OKButton.Add_Click({$Parentlabel.text = $textbox1.Text})
$ChildForm.AcceptButton = $OKButton
$ChildForm.Controls.Add($OKButton)

$ChildForm.ShowDialog()

}

#

$ParentForm = New-Object system.Windows.Forms.Form

$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(20,20)
$button1.Text = "Open Child" 
$button1.Add_Click({Child $label1}) 
$ParentForm.Controls.Add($button1)

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(20,80)
$label1.BorderStyle = "Fixed3D"
$ParentForm.Controls.Add($label1)

$ParentForm.ShowDialog()

# Beispiel für Auslisting von Prozessen in einer DataGrid

        $gps = get-process | select Name,ID,Description,@{n='Memory';e={$_.WorkingSet}}
        $list0 = New-Object System.collections.ArrayList
        $list0.AddRange($gps)

        $dataGridView0 = New-Object System.Windows.Forms.DataGridView -Property @{
            Size=New-Object System.Drawing.Size(500,400)
            ColumnHeadersVisible = $true
            DataSource = $list0
             }
  
        $Form.Controls.Add($dataGridView0)


  ################
 
 # Beispiel für Tabelle der Laufwerke 
   Write-Host "Drive information for $env:ComputerName"

Get-WmiObject -Class Win32_LogicalDisk |
    Where-Object {$_.DriveType -ne 5} |
    Sort-Object -Property Name | 
    Select-Object Name, VolumeName, FileSystem, Description, VolumeDirty, `
        @{"Label"="DiskSize(GB)";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `
        @{"Label"="FreeSpace(GB)";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}}, `
        @{"Label"="%Free";"Expression"={"{0:N}" -f ($_.FreeSpace/$_.Size*100) -as [float]}} |
    Format-Table -AutoSize


  
 ############################
 
   # Run this script to see connected hard disk status with nifty bar graph!
 
$myDisk = Get-WmiObject -class win32_logicaldisk
$myDisk | ForEach-Object {
    $free = ($_.freespace)
    $total = ($_.size)
    $used = $total - $free
    $perUsed = ($used / $total) * 100
    $perFree = ($free / $total) * 100
    $t = [math]::Round($total/1gb)
    $f = [math]::Round($free/1gb)
    $u = [math]::Round($used/1gb)
    $pu = [math]::Round($perUsed)
    $pf = [math]::Round($perFree)
   
    write-host "Volume:    "$_.VolumeName
    write-host "DeviceID:  "$_.DeviceID
    echo "Total:      $t/Gb"
    echo "Used:       $u/Gb"
    echo "Free:       $f/Gb"
    echo "% used:     $pu%"
    echo "% free:     $pf%"
   
    # Create bar graph
    function drawBar{
        # Tracks how many ticks to draw
        $tick
        Write-Host '['-NoNewline
        # Loop that animates the bar also scales the percentage so bar does not take up too much space
        While($tick++ -le $pu/100*30-1){  
            write-Host "$([char]0x25A0)" -NoNewline
            # Smaller number, faster animation
            Start-Sleep -Milliseconds 5
        }
        # Calculates how much free space at end of the graph
        $spaceLeft = ((100/100)*30) - $tick
        # Tracks empty space to draw to push end of graph
        $add
        # Loop draws empty space and end of graph
        While($add++ -le $spaceLeft){
        Write-Host ' ' -NoNewline
        }
        Write-Host ']'
        # Makes space between reports
        "`n"
    }
    #Calls bar graph function
    drawBar
}

 #####################################
        
  #Beispiel für ein Kreisdiagramm mit Anzeige von den letzten 5 Prozessen
        
        $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
        $Chart.Width = 150
        $Chart.Height = 100
        $Chart.Left = 20
        $Chart.Top = 10
       
        # create a chartarea to draw on and add to chart
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
        $Chart.ChartAreas.Add($ChartArea)


        # add data to chart 
        $Processes = Get-Process | Sort-Object -Property WS | Select-Object Name,WS,ID -Last 5
        $ProcNames = @(foreach($Proc in $Processes){$Proc.Name + "_" + $Proc.ID})
        $WS = @(foreach($Proc in $Processes){$Proc.WS/1MB})

        [void]$Chart.Series.Add("Data")
        $Chart.Series["Data"].Points.DataBindXY($ProcNames, $WS)

        # set chart type
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie


        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 

        
        
        $objForm.controls.add($Chart)


        ######################
   
   #Ram usage
    function Get-MemoryUsage ($ComputerName=$ENV:ComputerName) {

    if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
    $ComputerSystem = Get-WmiObject -ComputerName $ComputerName -Class Win32_operatingsystem -Property CSName, TotalVisibleMemorySize, FreePhysicalMemory
    $MachineName = $ComputerSystem.CSName
    $FreePhysicalMemory = ($ComputerSystem.FreePhysicalMemory) / (1mb)
    $TotalVisibleMemorySize = ($ComputerSystem.TotalVisibleMemorySize) / (1mb)
    $TotalVisibleMemorySizeR = “{0:N2}” -f $TotalVisibleMemorySize
    $TotalFreeMemPerc = ($FreePhysicalMemory/$TotalVisibleMemorySize)*100
    $TotalFreeMemPercR = “{0:N2}” -f $TotalFreeMemPerc

    # print the machine details:
    “Name: $MachineName”
    “RAM: $TotalVisibleMemorySizeR GB”
    “Free Physical Memory: $TotalFreeMemPercR %”

    } }

    Get-MemoryUsage

################################

#Beispiel eines Ressourcenmonitor (voller Code für Gerüst)


function CreateForm {
#[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.drawing

#Form Setup
$form1 = New-Object System.Windows.Forms.Form
$button1 = New-Object System.Windows.Forms.Button
$button2 = New-Object System.Windows.Forms.Button
$checkBox1 = New-Object System.Windows.Forms.CheckBox
$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox4 = New-Object System.Windows.Forms.CheckBox
$TabControl = New-object System.Windows.Forms.TabControl
$SQLHealthPage = New-Object System.Windows.Forms.TabPage
$CPUPage = New-Object System.Windows.Forms.TabPage
$DiskPage = New-Object System.Windows.Forms.TabPage
$MemoryPage = New-Object System.Windows.Forms.TabPage

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#Form Parameter
$form1.Text = "My PowerShell Form"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 725
$System_Drawing_Size.Height = 450
$form1.ClientSize = $System_Drawing_Size


#Tab Control 
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 75
$System_Drawing_Point.Y = 85
$tabControl.Location = $System_Drawing_Point
$tabControl.Name = "tabControl"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 300
$System_Drawing_Size.Width = 575
$tabControl.Size = $System_Drawing_Size
$form1.Controls.Add($tabControl)

#SQLHealth Page
$SQLHealthPage.DataBindings.DefaultDataSourceUpdateMode = 0
$SQLHealthPage.UseVisualStyleBackColor = $True
$SQLHealthPage.Name = "SQLHealthPage"
$SQLHealthPage.Text = "SQL Health Check”
$tabControl.Controls.Add($SQLHealthPage)

#CPU Page
$CPUPage.DataBindings.DefaultDataSourceUpdateMode = 0
$CPUPage.UseVisualStyleBackColor = $True
$CPUPage.Name = "CPUPage"
$CPUPage.Text = "CPU”
$tabControl.Controls.Add($CPUPage)

#Disk Page
$DiskPage.DataBindings.DefaultDataSourceUpdateMode = 0
$DiskPage.UseVisualStyleBackColor = $True
$DiskPage.Name = "DiskPage"
$DiskPage.Text = "Disk”
$tabControl.Controls.Add($DiskPage)

#Memory Page
$MemoryPage.DataBindings.DefaultDataSourceUpdateMode = 0
$MemoryPage.UseVisualStyleBackColor = $True
$MemoryPage.Name = "MemoryPage"
$MemoryPage.Text = "Memory”
$tabControl.Controls.Add($MemoryPage)

#Add Label and TextBox
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,45)  
$objLabel.Size = New-Object System.Drawing.Size(110,50)  
$objLabel.Text = "Enter Server Name"
$form1.Controls.Add($objLabel)
$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(120,45) 
$objTextBox.Size = New-Object System.Drawing.Size(200,20)  
$form1.Controls.Add($objTextBox) 
 
#Button 1 Action 
$button1_RunOnClick= 
{   
    if ($checkBox1.Checked)     {  SQLVersion }
    if ($checkBox2.Checked)    {  LastReboot }
    if ($checkBox3.Checked)    {  Requests }   
}

#Button 2 Action
$button2_RunOnClick= 
{   
    if ($checkBox1.Checked) {$checkBox1.CheckState = 0}
    if ($checkBox2.Checked) {$checkBox2.CheckState = 0}
    if ($checkBox3.Checked) {$checkBox3.CheckState = 0}
}

$OnLoadForm_StateCorrection=
{
    $form1.WindowState = $InitialFormWindowState
}
 
#Button 1
$button1.TabIndex = 4
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 25
$button1.Size = $System_Drawing_Size
$button1.UseVisualStyleBackColor = $True
$button1.Text = "Run"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 350
$System_Drawing_Point.Y = 45
$button1.Location = $System_Drawing_Point
$button1.DataBindings.DefaultDataSourceUpdateMode = 0
$button1.add_Click($button1_RunOnClick)
$form1.Controls.Add($button1)

#Button 2
$button2.TabIndex = 4
$button2.Name = "button2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 25
$button2.Size = $System_Drawing_Size
$button2.UseVisualStyleBackColor = $True
$button2.Text = "Clear CheckBox"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 450
$System_Drawing_Point.Y = 45
$button2.Location = $System_Drawing_Point
$button2.DataBindings.DefaultDataSourceUpdateMode = 0
$button2.add_Click($button2_RunOnClick)
$form1.Controls.Add($button2)


#SQLVersion
$checkBox1.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox1.Size = $System_Drawing_Size
$checkBox1.TabIndex = 0
$checkBox1.Text = "SQL Version"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 25
$checkBox1.Location = $System_Drawing_Point
$checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox1.Name = "checkBox1"
$SQLHealthPage.Controls.Add($checkBox1)



#LastReBoot
$checkBox2.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox2.Size = $System_Drawing_Size
$checkBox2.TabIndex = 1
$checkBox2.Text = "Last Reboot"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 50
$checkBox2.Location = $System_Drawing_Point
$checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox2.Name = "checkBox2"
$SQLHealthPage.Controls.Add($checkBox2)


#Request
$checkBox3.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox3.Size = $System_Drawing_Size
$checkBox3.TabIndex = 0
$checkBox3.Text = "Requests"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 75
$checkBox3.Location = $System_Drawing_Point
$checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox3.Name = "checkBox3"
$SQLHealthPage.Controls.Add($checkBox3)


#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null
} #End function CreateForm
 
 function Invoke-Sqlcmd3

{
    param(
    [string]$Query,             
    [string]$Database="tempdb",
    [Int32]$QueryTimeout=30
    )
    $conn=new-object System.Data.SqlClient.SQLConnection
    $conn.ConnectionString="Server={0};Database={1};Integrated Security=True" -f $Server,$Database
    $conn.Open()
    $cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn)
    $cmd.CommandTimeout=$QueryTimeout
    $ds=New-Object system.Data.DataSet
    $da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
    [void]$da.fill($ds)
    $conn.Close()
    $ds.Tables[0]
}

 

Function SQLVersion
{
[string]$SQLVersion = @"
SELECT  @@Version
"@ 
 $Server = $objTextBox.text
Invoke-Sqlcmd3 -ServerInstance $Server -Database Master -Query $SQLVersion | Out-GridView -Title "$server SQL Server Version"
}

Function LastReboot
{
$Server = $objTextBox.text
$wmi = Get-WmiObject -Class Win32_OperatingSystem -Computer $server
$wmi.ConvertToDatetime($wmi.LastBootUpTime) | Select DateTime | Out-GridView -Title "$Server Last Reboot"
}

Function Requests
{
[string]$Requests = @"
SELECT
   db_name(r.database_id) as database_name, r.session_id AS SPID,r.status,s.host_name,
     r.start_time,(r.total_elapsed_time/1000) AS 'TotalElapsedTime Sec',
   r.wait_type as current_wait_type,r.wait_resource as current_wait_resource,
   r.blocking_session_id,r.logical_reads,r.reads,r.cpu_time as cpu_time_ms,r.writes,r.row_count,
   substring(st.text,r.statement_start_offset/2,
   (CASE WHEN r.statement_end_offset = -1 THEN len(convert(nvarchar(max), st.text)) * 2 ELSE r.statement_end_offset END - r.statement_start_offset)/2) as statement
FROM
   sys.dm_exec_requests r
      LEFT OUTER JOIN sys.dm_exec_sessions s on s.session_id = r.session_id
      LEFT OUTER JOIN sys.dm_exec_connections c on c.connection_id = r.connection_id       
      CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st 
WHERE r.status NOT IN ('background','sleeping')
"@ 
 $Server = $objTextBox.text
Invoke-Sqlcmd3 -ServerInstance $Server -Database Master -Query $Requests | Out-GridView -Title "$server Requests"
}



#Call the Function

CreateForm

###############################################
 # add a Chart
        $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
        $Chart.Width = 150
        $Chart.Height = 100
        $Chart.Left = 20
        $Chart.Top = 10
       
        # create a chartarea to draw on and add to chart
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
        $Chart.ChartAreas.Add($ChartArea)


        # Funktion für Anzeige von Speicherplatz (Noch nicht ganz richtig. Zeigt den Speicher von allen Laufwerken anstatt used und free space)
        $Disks = Get-WMIObject Win32_LogicalDisk | Select-Object Size, FreeSpace
                
        $UsedSpace = @(foreach($Disk in $Disks) {($disk.size - $disk.freespace)/1gb})
        $FreeSpace = @(foreach($Disk in $Disks) {$disk.freespace/1gb})
        
        
        # add data to chart
        [void]$Chart.Series.Add("Data")
        $Chart.Series["Data"].Points.DataBindXY($UsedSpace, $FreeSpace)
        

        # set chart type
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie


        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 

        
      

          # add chart to tab
            $Tab4.controls.add($Chart)