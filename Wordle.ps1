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
        Write-Host "`r`nYou win! The solution is $Solution." -ForegroundColor Green
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
            if ($Global:LettersGreen -notcontains $WordArr[$i]) {
                $Global:LettersGreen += $WordArr[$i]
            }
            if ($Global:LettersYellow -contains $WordArr[$i]) {
                $Global:LettersYellow = $Global:LettersYellow | Where-Object { $_ -ne $WordArr[$i] }
            }
        }
        elseif ($WordArr[$i] -in $Solution.ToCharArray()) {
            # Letter in solution
            Write-Host $WordArr[$i] -NoNewline -BackgroundColor Yellow -ForegroundColor Black
            if ($Global:LettersYellow -notcontains $WordArr[$i] -and $Global:LettersGreen -notcontains $WordArr[$i]) {
                $Global:LettersYellow += $WordArr[$i]
            }
        }
        else {
            # Letter not in word
            if ($Global:LettersFalse -notcontains $WordArr[$i]) {
                $Global:LettersFalse += $WordArr[$i]
            }
            Write-Host $WordArr[$i] -NoNewline
        }
    }
}

function Write-LettersOverview {
    Write-Host
    Write-Host "Guessed letters overview:"
    foreach ($KeyboardRow in $Keyboard) {
        foreach ($Letter in $KeyboardRow) {
            if ($Global:LettersGreen -contains $Letter) {
                Write-Host $Letter -NoNewline -BackgroundColor Green -ForegroundColor Black
            }
            elseif ($Global:LettersYellow -contains $Letter) {
                Write-Host $Letter -NoNewline -BackgroundColor Yellow -ForegroundColor Black
            }
            elseif ($Global:LettersFalse -contains $Letter) {
                Write-Host $Letter -NoNewline -BackgroundColor Red -ForegroundColor Black
            }
            else {
                Write-Host $Letter -NoNewline
            }
            Write-Host " " -NoNewline
        }
        Write-Host
    }
    Write-Host

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
$Keyboard = @(
    @("Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"),
    @("A", "S", "D", "F", "G", "H", "J", "K", "L"),
    @("Z", "X", "C", "V", "B", "N", "M")
)
$Global:LettersGreen = @()
$Global:LettersYellow = @()
$Global:LettersFalse = @()

# Main code
Clear-Host
while ($Attempts -le 5) {
    Write-LettersOverview
    $GuessInput = Read-Host "`r`nEnter your five-letter guess (attempt $($Guesses.count + 1))"
    while ($GuessList -notcontains $GuessInput -and $WordList -notcontains $GuessInput) {
        $GuessInput = Read-Host "Incorrect input, or word not in the list ($GuessInput). Please enter a valid five letter word"
    }
    $Guesses += $GuessInput.ToUpper()
    $Attempts ++

    Write-Overview
}
