function Function1 {
    param(
        [string]$Arg1,
        [string]$Arg2
    )
    Write-Host "Function1 called with arguments: $Arg1, $Arg2"
}

function Function2 {
    param(
        [string]$Arg1
    )
    Write-Host "Function2 called with argument: $Arg1"
}

$command = $args[0]
$arguments = @($args[1..$args.length])

switch ($command) {
    "Function1" {
        Function1 -Arg1 $arguments[0] -Arg2 $arguments[1]
    }
    "Function2" {
        Function2 -Arg1 $arguments[0]
    }
    default {
        Write-Host "Invalid command: $command"
    }
} 