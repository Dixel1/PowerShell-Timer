#Timer PowerShell v1.4

Add-Type -assemblyName PresentationFramework
Add-Type -assemblyName PresentationCore
Add-Type -assemblyName WindowsBase

#XML for menu
[xml]$xaml = @"
<Window
    xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
    xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
    x:Name='Window' Title='Countdown' WindowStartupLocation = 'CenterScreen' ResizeMode='NoResize'
    Width = '320' Height = '240' ShowInTaskbar = 'True' Background = 'LightBlue' WindowStyle='ThreeDBorderWindow'>
    <StackPanel Margin='0,0,0,7' HorizontalAlignment='Right' Width='314' >
        <StackPanel.Effect>
            <DropShadowEffect/>
        </StackPanel.Effect>
        <Label Content='Time remaining before Lock' VerticalAlignment='Center' HorizontalAlignment='Center' />
        <TextBox x:Name='TimeBox' IsReadOnly = 'False' Height = '30'
            TextWrapping='Wrap' VerticalScrollBarVisibility = 'Auto' Text='0:00' HorizontalContentAlignment='Center' MaxWidth='100' MaxHeight='25'/>
        <Label Content='Enter countdown duration (minutes)' VerticalAlignment='Center' HorizontalAlignment='Center' />
        <TextBox x:Name='DurationBox' IsReadOnly = 'False' Height = '30'
            TextWrapping='Wrap' VerticalScrollBarVisibility = 'Auto' Text='5' HorizontalContentAlignment='Center' MaxWidth='100' MaxHeight='25'/>
        <StackPanel Orientation = 'Horizontal' Margin='10,0,0,0' Panel.ZIndex='5' Height='64'>
            <Button x:Name = 'StartBtn' Height = '50' Width = '65' Content = 'Start' Background='Green' HorizontalAlignment='Right' VerticalAlignment='Center' >
                <Button.Effect>
                    <DropShadowEffect/>
                </Button.Effect>
            </Button>
            <Button x:Name = 'PauseBtn' Height = '50' Width = '65' Content = 'Pause' Background='Yellow' Margin = '10,0,0,0' VerticalAlignment='Center' >
                <Button.Effect>
                    <DropShadowEffect/>
                </Button.Effect>
            </Button>
            <Button x:Name = 'ResetBtn' Height = '50' Width = '65' Content = 'Reset' Background='Red' Margin = '10,0,0,0' VerticalAlignment='Center' >
                <Button.Effect>
                    <DropShadowEffect/>
                </Button.Effect>
            </Button>
            <Button x:Name = 'CancelBtn' Height = '50' Width = '65' Content = 'Cancel' Background='Red' Margin = '10,0,0,0' VerticalAlignment='Center' >
                <Button.Effect>
                    <DropShadowEffect/>
                </Button.Effect>
            </Button>
        </StackPanel>
    </StackPanel>
</Window>
"@
# "
$iCtr = 0
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

#Connect to Controls
$StartBtn = $Window.FindName('StartBtn')
$PauseBtn = $Window.FindName('PauseBtn')
$ResetBtn = $Window.FindName('ResetBtn')
$Cancelbtn = $Window.FindName('CancelBtn')
$TimeBox = $Window.FindName('TimeBox')
$DurationBox = $Window.FindName('DurationBox')

#Event handlers
$Window.Add_SourceInitialized({
    # Before the window's even displayed ...
    # We'll create a timer
    $script:seconds =([timespan]"0:$($DurationBox.Text):0") # User-specified minutes
    $script:timer = new-object System.Windows.Threading.DispatcherTimer
    # Which fire 1 time each second
    $timer.Interval = [TimeSpan]'0:0:1.0'
    # And will invoke the $updateBlock
    $timer.Add_Tick.Invoke($UpDateBlock)
    # Now start the timer running
    $timer.Start()
    if ($timer.IsEnabled -eq $false) {
        write-warning "Timer didn't start"
    }
})

$StartBtn.Add_Click({
    $timer.Start()
})

$PauseBtn.Add_Click({
    $timer.Stop()
})

$ResetBtn.Add_Click({
    $timer.Stop()
    $script:seconds =([timespan]"0:$($DurationBox.Text):0") # User-specified minutes
    $timer.Start()
})

$CancelBtn.Add_Click({
    clear-variable -name ("StartBtn", "PauseBtn", "timer", "reader", "TimeBox", "UpDateBlock", "xaml", "reader", "iCtr")
    Close-Form
})

Function Close-Form {
    #$timer.Enabled = $false
    #$timer.Dispose()
    $Window.Close()
}

$UpDateBlock = ({
    $script:seconds= $script:seconds.Subtract([timespan]'0:0:1')

    $Timebox.Text=$seconds.ToString('mm\:ss')

    if($seconds -eq 0) { Close-Form }
})

$Window.ShowDialog() | Out-Null
