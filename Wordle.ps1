param (
    [Parameter(Mandatory = $false)]
    [Switch]$Dutch
)

function Write-Overview {
    Clear-Host
    foreach ($Guess in $Guesses) {
        Write-GuessCheck -Word $Guess
        Write-Host
    }

    # Check for win
    if ($Guess -eq $Solution) {
        Write-Host "You win! The solution is $Solution." -ForegroundColor Green
        exit
    }
    
    # Check for lose
    if ($Attempts -eq 6) {
        Write-Host "You lose! The solution was $Solution." -ForegroundColor Red
        exit

    }
}

function Write-GuessCheck {
    param(
        [string]$Word
    )

    $WordArr = $word.ToCharArray()
    for ($i = 0 ; $i -lt 5 ; $i++) {
        if ($WordArr[$i] -eq $Solution[$i]) {
            # Letter in correct place
            Write-Host $WordArr[$i] -NoNewline -BackgroundColor Green -ForegroundColor Black
            $Global:CorrectLetters ++
        }
        elseif ($WordArr[$i] -in $Solution.ToCharArray()) {
            # Letter in solution
            Write-Host $WordArr[$i] -NoNewline -BackgroundColor Yellow -ForegroundColor Black
        }
        else {
            # Letter not in word
            Write-Host $WordArr[$i] -NoNewline
        }
    }
}

# Initialize
$Attempts = 0
$Guesses = @()
if ($Dutch -eq $true) {
    $WordList = Get-Content "$PSScriptRoot\WordListDutch.json" | ConvertFrom-Json
    $GuessList = $WordList
}
else {
    $WordList = Get-Content "$PSScriptRoot\WordListEnglish.json" | ConvertFrom-Json # Source: https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b
    $GuessList = Get-Content "$PSScriptRoot\GuessListEnglish.json" | ConvertFrom-Json # Source: https://gist.github.com/cfreshman/cdcdf777450c5b5301e439061d29694c
}
$Solution = ($WordList | Get-Random).ToUpper()

# Main code
Clear-Host
while ($Attempts -le 5) {
    $GuessInput = Read-Host "`r`nEnter your five-letter guess (attempt $Attemps)"
    while ($GuessList -notcontains $GuessInput -and $WordList -notcontains $GuessInput) {
        $GuessInput = Read-Host "Incorrect input, or word not in the list ($GuessInput). Please enter a valid five letter word"
    }
    $Guesses += $GuessInput.ToUpper()
    $Attempts ++

    Write-Overview
}
