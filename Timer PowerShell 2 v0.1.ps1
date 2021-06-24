$timer = new-object timers.timer
$timer.Interval = 5000 # milliseconds

$action = {
     # Votre action ici
     $timer.stop()
     Unregister-Event TimerConfirm
}

Register-ObjectEvent -InputObject $timer -EventName elapsed `
–SourceIdentifier  TimerConfirm -Action $action

$timer.start()
$timer = new-object timers.timer
$timer.Interval = 5000 # milliseconds
$cpt = 1

$action = {
    if($cpt -eq 1) {
        # aprés 5 sec
        # Action pour dégriser la cellule
        $cpt++
    } else {
        # aprés 10 sec
        # Validation du formulaire
        $timer.stop()
         Unregister-Event TimerConfirm
    }
}

Register-ObjectEvent -InputObject $timer -EventName elapsed `
–SourceIdentifier  TimerConfirm -Action $action

$timer.start()