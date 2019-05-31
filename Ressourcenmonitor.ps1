
#Fenster
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
[void][Windows.Forms.Application]::EnableVisualStyles()
[void][Windows.Forms.ComboBoxStyle]::DropDown

#Anfang Fenster 
$objForm = New-Object System.Windows.Forms.Form

$objForm.Backcolor="white"
$objForm.StartPosition = "CenterScreen"
$objForm.Size = New-Object System.Drawing.Size(800,500)
$objForm.Text = "Ressourcen-Monitor"



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



    #Tab Prozesse
    $Tab0=New-Object System.Windows.Forms.TabPage
    $Tab0.TabIndex=0
    $Tab0.Text="Prozesse"
    $Tab0.Name="Prozesse"
    $Tab0.Backcolor="white"
    $TabControl.Controls.Add($Tab0)

        
       #Zeigt eine Liste der aktuellen Prozesse an in einem DataGrid an. Jedoch lädt es nur am Anfang. (Ein Loop für ein regelmäßiges Aktualisieren der Prozesse ist denkbar oder ein Aktualisieren-Button)      
       $gps = get-process | select Name,ID,Description,@{n='Memory';e={$_.WorkingSet}}
       $list0 = New-Object System.collections.ArrayList
       $list0.AddRange($gps)

       $dataGridView0 = New-Object System.Windows.Forms.DataGridView -Property @{
       Size=New-Object System.Drawing.Size(500,400)
       ColumnHeadersVisible = $true
       DataSource = $list0
       }
  
        $Tab0.Controls.Add($dataGridView0)
   
          
           


    #Tab CPU
    $Tab1=New-Object System.Windows.Forms.TabPage
    $Tab1.TabIndex=1
    $Tab1.Text="CPU"
    $Tab1.Name="CPU"
    $Tab1.Backcolor="white"
    $TabControl.Controls.Add($Tab1)
    
        



        # add a TextBox
        $CPUTextBox = New-Object Windows.Forms.TextBox
        $CPUTextBox = New-Object System.Windows.Forms.TextBox
        $CPUTextBox.Location = New-Object System.Drawing.Size(15,10)
        $CPUTextBox.Size = New-Object System.Drawing.Size(700,10)
        $CPUTextBox.Height = 300
        $CPUTextBox.Font = "Lucida Console"
        $CPUTextBox.Multiline = $True                    
        $Tab1.Controls.Add($CPUTextBox)
  

        # add a button
        $CPUButton = New-Object Windows.Forms.Button
        $CPUButton.Text = "CPU Info"
        $CPUButton.Top = 40
        $CPUButton.Left = 15
        $CPUButton.Width = 150
        $CPUButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right 
        $Tab1.Controls.Add($CPUButton)

        

        #Aktion, bei Klicken des Buttons --> CPU Info als String in ein Textbox   
        $CPUButton.add_click({
  
        $sTemp = Get-WmiObject win32_processor 
  
        $item = $sTemp | ft Name,NumberOfCores,NumberOfLogicalProcessors
        $item = $item | Out-String 
        $CPUTextBox.Text = $item 
  
        })
      
        
            
                
        
        
      

    #Tab RAM (noch nichts gemacht)
    $Tab2 = New-Object System.Windows.Forms.TabPage
    $Tab2.TabIndex=2
    $Tab2.Text="RAM"
    $Tab2.Name="RAM"
    $Tab2.Backcolor="white"
    $TabControl.Controls.Add($Tab2)
                 
        
        $Text2=New-Object System.Windows.Forms.Label
        $Text2.Name="Inhalt RAM"
        $Text2.Text="Inhalt RAM"
        $Tab2.Controls.Add($Text2)
    

    #Tab GPU (noch nichts gemacht)
    $Tab3=New-Object System.Windows.Forms.TabPage
    $Tab3.TabIndex=3
    $Tab3.Text="GPU"
    $Tab3.Name="GPU"
    $Tab3.Backcolor="white"
    $TabControl.Controls.Add($Tab3)

        $Text3=New-Object System.Windows.Forms.Label
        $Text3.Name="Inhalt GPU"
        $Text3.Text="Inhalt GPU"
        $Tab3.Controls.Add($Text3)





    #Tab Festplatte
  
    $Tab4=New-Object System.Windows.Forms.TabPage
    $Tab4.TabIndex=4
    $Tab4.Text="Festplatte"
    $Tab4.Name="Festplatte"
    $Tab4.Backcolor="white"
    $TabControl.Controls.Add($Tab4)

        $Text4=New-Object System.Windows.Forms.Label
        $Text4.Name="Inhalt Festplatte"
        $Text4.Text="Pie Chart"
        $Tab4.Controls.Add($Text4)

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
        $Disks = Get-WMIObject Win32_LogicalDisk | Select-Object Size
                
        $UsedSpace = @(foreach($Disk in $Disks) {($disk.size - $disk.freespace)/1gb})
        $FreeSpace = @(foreach($Disk in $Disks) {$disk.freespace/1gb})
        
        
        # add data to chart
        [void]$Chart.Series.Add("Data")
        $Chart.Series["Data"].Points.DataBindXY($FreeSpace, $UsedSpace)
        

        # set chart type
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie


        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 

        
        # Legende (zeigt noch Quatsch an...)

          $Legend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
          $Legend.IsEquallySpacedItems = $True
          $Legend.BorderColor = 'Black'
          $Chart.Legends.Add($Legend)
          $Chart.Series["Data"].LegendText = "$FreeSpace ($UsedSpace)"

          # add chart to tab
            $Tab4.controls.add($Chart)
        

     
#Ende
[void] $objForm.ShowDialog()


