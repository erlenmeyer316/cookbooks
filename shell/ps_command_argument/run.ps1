## To add pscmdarg as a new command in your shell at the following to your $PROFILE
#function pscmdarg {
#    $command = $args[0]
#    $arguments = $args[1..($args.Length - 1)]
#    & "C:\<PATH_TO>\cookbooks\shell\ps_command_argument\run.ps1"  $command $arguments
#  }

function Function1 {     
    $argList = $($args | Join-String -DoubleQuote -Separator ',')
    Write-Host "Function1 called with arguments: $argList"
}

function Function2 {
    $argList = $($args | Join-String -DoubleQuote -Separator ',')
    Write-Host "Function2 called with argument: $argList"
}

$command = $args[0]
$arguments = $args[1]

switch ($command) {
    "Function1" {
        Function1 $arguments
    }
    "Function2" {
        Function2 $arguments
    }
    default {
        Write-Host "Invalid command: $command"
    }
} 

