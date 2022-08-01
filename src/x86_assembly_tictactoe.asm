;==========================================================================
; Module: x86 Assembly Tic-Tac-Toe
;
; Author: t-mthy
;
; Description: This program lets user play tic-tac-toe against the computer
;==========================================================================

format PE console
include 'win32ax.inc'

;=======================================
section '.code' code readable executable
;=======================================
start:
        cinvoke time, 0             ;get time null from comp
        cinvoke srand, eax          ;seed rand w/ time

gameLoop:
        call cls
        call intro
        call printBoard
        cinvoke printf, "%c                                                 Your move (1-9)?  ", 10
        cinvoke scanf, "%d", square
        call placeX
        call checkXWin
        call checkForDraw
        call computerMove
        call checkOWin
        jmp gameLoop

cls:
        cinvoke printf, "%c[2J%c[1;1H", 27, 27
        ret

intro:
        cinvoke printf, "%c%c[33;1m", 10, 27
        cinvoke printf, "      ___   __     _                     _    _        _____ _       _____           _____         %c", 10
        cinvoke printf, " __ _( _ ) / /    /_\   ______ ___ _ __ | |__| |_  _  |_   _(_)__ __|_   _|_ _ __ __|_   _|__  ___ %c", 10
        cinvoke printf, " \ \ / _ \/ _ \  / _ \ (_-<_-</ -_) '  \| '_ \ | || |   | | | / _|___|| |/ _` / _|___|| |/ _ \/ -_)%c", 10
        cinvoke printf, " /_\_\___/\___/ /_/ \_\/__/__/\___|_|_|_|_.__/_|\_, |   |_| |_\__|    |_|\__,_\__|    |_|\___/\___|%c", 10
        cinvoke printf, "                                                |__/                                               %c", 10
        cinvoke printf, "%c%c[0m                                                                                     by t-mthy", 10, 27
        cinvoke printf, "%c%c", 10, 10
        cinvoke printf, "                                                   %c[35;1m 1 | 2 | 3 %c[0m%c", 27, 27, 10
        cinvoke printf, "You will be X's and the computer will be O's.      %c[35;1m---|---|---%c[0m%c", 27, 27, 10
        cinvoke printf, "The squares are numbered 1 - 9.                    %c[35;1m 4 | 5 | 6 %c[0m%c", 27, 27, 10
        cinvoke printf, "Let the game begin!                                %c[35;1m---|---|---%c[0m%c", 27, 27, 10
        cinvoke printf, "                                                   %c[35;1m 7 | 8 | 9 %c[0m%c%c", 27, 27, 10, 10
        cinvoke printf, "[NOTE: Choose only empty slot or you will loose your turn!]%c%c", 10, 10
        ret

printBoard:
        cinvoke printf, "%c%c%c[36;1m", 10, 10, 27
        cinvoke printf, "                                                    %1.1s | %1.1s | %1.1s %c", s1, s2, s3, 10
        cinvoke printf, "                                                   ---|---|---%c", 10
        cinvoke printf, "                                                    %1.1s | %1.1s | %1.1s %c", s4, s5, s6, 10
        cinvoke printf, "                                                   ---|---|---%c", 10
        cinvoke printf, "                                                    %1.1s | %1.1s | %1.1s %c", s7, s8, s9, 10
        cinvoke printf, "%c[0m", 27
        ret

placeX:
        mov eax, [square]
        mov [s1 + eax-1], 'X'                   ; NOTE the contiguous address s1 - s9
        ret

;--------------------------------check player X win--------------------------------
checkXWin:
    topRowX:
        cmp [s1], 'X'
        jne midRowX
        cmp [s2], 'X'
        jne midRowX
        cmp [s3], 'X'
        je playWin
    midRowX:
        cmp [s4], 'X'
        jne endRowX
        cmp [s5], 'X'
        jne endRowX
        cmp [s6], 'X'
        je playWin
    endRowX:
        cmp [s7], 'X'
        jne lftColX
        cmp [s8], 'X'
        jne lftColX
        cmp [s9], 'X'
        je playWin
    lftColX:
        cmp [s1], 'X'
        jne midColX
        cmp [s4], 'X'
        jne midColX
        cmp [s7], 'X'
        je playWin
    midColX:
        cmp [s2], 'X'
        jne rhtColX
        cmp [s5], 'X'
        jne rhtColX
        cmp [s8], 'X'
        je playWin
    rhtColX:
        cmp [s3], 'X'
        jne lftDiagX
        cmp [s6], 'X'
        jne lftDiagX
        cmp [s9], 'X'
        je playWin
    lftDiagX:
        cmp [s1], 'X'
        jne rhtDiagX
        cmp [s5], 'X'
        jne rhtDiagX
        cmp [s9], 'X'
        je playWin
    rhtDiagX:
        cmp [s3], 'X'
        jne noXWin
        cmp [s5], 'X'
        jne noXWin
        cmp [s7], 'X'
        je playWin
    noXWin:
        ret

;--------------------------------check game draw--------------------------------
checkForDraw:
        mov ecx, -1                             ; initialize counter reg to -1
    drawLoop:
        inc ecx                                 ; counter starts at 0 (0 - 8 for board)
        cmp ecx, 9                              ; after last filled square (counter 8)...counter == 9
        je drawGame
        cmp [s1 + ecx], ' '                     ; check for empty square
        jne drawLoop                            ; if not empty...increment counter, check next square
        ret

;--------------------------------computer moves--------------------------------
computerMove:
;--------------------------------comp aim moves--------------------------------
compMoveForOWin:
    aimTopRowS1:                                ;computer move aims for top row
        cmp [s1], ' '
        jne aimTopRowS2
        cmp [s2], 'O'
        jne aimTopRowS2
        cmp [s3], 'O'
        jne aimTopRowS2
        mov [s1], 'O'
        jmp compWin
    aimTopRowS2:
        cmp [s1], 'O'
        jne aimTopRowS3
        cmp [s2], ' '
        jne aimTopRowS3
        cmp [s3], 'O'
        jne aimTopRowS3
        mov [s2], 'O'
        jmp compWin
    aimTopRowS3:
        cmp [s1], 'O'
        jne aimMidRowS4
        cmp [s2], 'O'
        jne aimMidRowS4
        cmp [s3], ' '
        jne aimMidRowS4
        mov [s3], 'O'
        jmp compWin
    aimMidRowS4:                                ;computer move aims for mid row
        cmp [s4], ' '
        jne aimMidRowS5
        cmp [s5], 'O'
        jne aimMidRowS5
        cmp [s6], 'O'
        jne aimMidRowS5
        mov [s4], 'O'
        jmp compWin
    aimMidRowS5:
        cmp [s4], 'O'
        jne aimMidRowS6
        cmp [s5], ' '
        jne aimMidRowS6
        cmp [s6], 'O'
        jne aimMidRowS6
        mov [s5], 'O'
        jmp compWin
    aimMidRowS6:
        cmp [s4], 'O'
        jne aimEndRowS7
        cmp [s5], 'O'
        jne aimEndRowS7
        cmp [s6], ' '
        jne aimEndRowS7
        mov [s6], 'O'
        jmp compWin
    aimEndRowS7:                                ;computer move aims for end row
        cmp [s7], ' '
        jne aimEndRowS8
        cmp [s8], 'O'
        jne aimEndRowS8
        cmp [s9], 'O'
        jne aimEndRowS8
        mov [s7], 'O'
        jmp compWin
    aimEndRowS8:
        cmp [s7], 'O'
        jne aimEndRowS9
        cmp [s8], ' '
        jne aimEndRowS9
        cmp [s9], 'O'
        jne aimEndRowS9
        mov [s8], 'O'
        jmp compWin
    aimEndRowS9:
        cmp [s7], 'O'
        jne aimLftColS1
        cmp [s8], 'O'
        jne aimLftColS1
        cmp [s9], ' '
        jne aimLftColS1
        mov [s9], 'O'
        jmp compWin
    aimLftColS1:                                ;computer move aims for lft col
        cmp [s1], ' '
        jne aimLftColS4
        cmp [s4], 'O'
        jne aimLftColS4
        cmp [s7], 'O'
        jne aimLftColS4
        mov [s1], 'O'
        jmp compWin
    aimLftColS4:
        cmp [s1], 'O'
        jne aimLftColS7
        cmp [s4], ' '
        jne aimLftColS7
        cmp [s7], 'O'
        jne aimLftColS7
        mov [s4], 'O'
        jmp compWin
    aimLftColS7:
        cmp [s1], 'O'
        jne aimMidColS2
        cmp [s4], 'O'
        jne aimMidColS2
        cmp [s7], ' '
        jne aimMidColS2
        mov [s7], 'O'
        jmp compWin
    aimMidColS2:                                ;computer move aims for mid col
        cmp [s2], ' '
        jne aimMidColS5
        cmp [s5], 'O'
        jne aimMidColS5
        cmp [s8], 'O'
        jne aimMidColS5
        mov [s2], 'O'
        jmp compWin
    aimMidColS5:
        cmp [s2], 'O'
        jne aimMidColS8
        cmp [s5], ' '
        jne aimMidColS8
        cmp [s8], 'O'
        jne aimMidColS8
        mov [s5], 'O'
        jmp compWin
    aimMidColS8:
        cmp [s2], 'O'
        jne aimRhtColS3
        cmp [s5], 'O'
        jne aimRhtColS3
        cmp [s8], ' '
        jne aimRhtColS3
        mov [s8], 'O'
        jmp compWin
    aimRhtColS3:                                ;computer move aims for rht col
        cmp [s3], ' '
        jne aimRhtColS6
        cmp [s6], 'O'
        jne aimRhtColS6
        cmp [s9], 'O'
        jne aimRhtColS6
        mov [s3], 'O'
        jmp compWin
    aimRhtColS6:
        cmp [s3], 'O'
        jne aimRhtColS9
        cmp [s6], ' '
        jne aimRhtColS9
        cmp [s9], 'O'
        jne aimRhtColS9
        mov [s6], 'O'
        jmp compWin
    aimRhtColS9:
        cmp [s3], 'O'
        jne aimLftDiagS1
        cmp [s6], 'O'
        jne aimLftDiagS1
        cmp [s9], ' '
        jne aimLftDiagS1
        mov [s9], 'O'
        jmp compWin
    aimLftDiagS1:                               ;computer move aims for lft diag
        cmp [s1], ' '
        jne aimLftDiagS5
        cmp [s5], 'O'
        jne aimLftDiagS5
        cmp [s9], 'O'
        jne aimLftDiagS5
        mov [s1], 'O'
        jmp compWin
    aimLftDiagS5:
        cmp [s1], 'O'
        jne aimLftDiagS9
        cmp [s5], ' '
        jne aimLftDiagS9
        cmp [s9], 'O'
        jne aimLftDiagS9
        mov [s5], 'O'
        jmp compWin
    aimLftDiagS9:
        cmp [s1], 'O'
        jne aimRhtDiagS3
        cmp [s5], 'O'
        jne aimRhtDiagS3
        cmp [s9], ' '
        jne aimRhtDiagS3
        mov [s9], 'O'
        jmp compWin
    aimRhtDiagS3:                               ;computer move aims for rht diag
        cmp [s3], ' '
        jne aimRhtDiagS5
        cmp [s5], 'O'
        jne aimRhtDiagS5
        cmp [s7], 'O'
        jne aimRhtDiagS5
        mov [s3], 'O'
        jmp compWin
    aimRhtDiagS5:
        cmp [s3], 'O'
        jne aimRhtDiagS7
        cmp [s5], ' '
        jne aimRhtDiagS7
        cmp [s7], 'O'
        jne aimRhtDiagS7
        mov [s5], 'O'
        jmp compWin
    aimRhtDiagS7:
        cmp [s3], 'O'
        jne compMoveForXBlk
        cmp [s5], 'O'
        jne compMoveForXBlk
        cmp [s7], ' '
        jne compMoveForXBlk
        mov [s7], 'O'
        jmp compWin

;-------------------------------comp block moves-------------------------------
compMoveForXBlk:
    blkTopRowS1:                                ;computer move blks for top row
        cmp [s1], ' '
        jne blkTopRowS2
        cmp [s2], 'X'
        jne blkTopRowS2
        cmp [s3], 'X'
        jne blkTopRowS2
        mov [s1], 'O'
        ret
    blkTopRowS2:
        cmp [s1], 'X'
        jne blkTopRowS3
        cmp [s2], ' '
        jne blkTopRowS3
        cmp [s3], 'X'
        jne blkTopRowS3
        mov [s2], 'O'
        ret
    blkTopRowS3:
        cmp [s1], 'X'
        jne blkMidRowS4
        cmp [s2], 'X'
        jne blkMidRowS4
        cmp [s3], ' '
        jne blkMidRowS4
        mov [s3], 'O'
        ret
    blkMidRowS4:                                ;computer move blks for mid row
        cmp [s4], ' '
        jne blkMidRowS5
        cmp [s5], 'X'
        jne blkMidRowS5
        cmp [s6], 'X'
        jne blkMidRowS5
        mov [s4], 'O'
        ret
    blkMidRowS5:
        cmp [s4], 'X'
        jne blkMidRowS6
        cmp [s5], ' '
        jne blkMidRowS6
        cmp [s6], 'X'
        jne blkMidRowS6
        mov [s5], 'O'
        ret
    blkMidRowS6:
        cmp [s4], 'X'
        jne blkEndRowS7
        cmp [s5], 'X'
        jne blkEndRowS7
        cmp [s6], ' '
        jne blkEndRowS7
        mov [s6], 'O'
        ret
    blkEndRowS7:                                ;computer move blks for end row
        cmp [s7], ' '
        jne blkEndRowS8
        cmp [s8], 'X'
        jne blkEndRowS8
        cmp [s9], 'X'
        jne blkEndRowS8
        mov [s7], 'O'
        ret
    blkEndRowS8:
        cmp [s7], 'X'
        jne blkEndRowS9
        cmp [s8], ' '
        jne blkEndRowS9
        cmp [s9], 'X'
        jne blkEndRowS9
        mov [s8], 'O'
        ret
    blkEndRowS9:
        cmp [s7], 'X'
        jne blkLftColS1
        cmp [s8], 'X'
        jne blkLftColS1
        cmp [s9], ' '
        jne blkLftColS1
        mov [s9], 'O'
        ret
    blkLftColS1:                                ;computer move blks for lft col
        cmp [s1], ' '
        jne blkLftColS4
        cmp [s4], 'X'
        jne blkLftColS4
        cmp [s7], 'X'
        jne blkLftColS4
        mov [s1], 'O'
        ret
    blkLftColS4:
        cmp [s1], 'X'
        jne blkLftColS7
        cmp [s4], ' '
        jne blkLftColS7
        cmp [s7], 'X'
        jne blkLftColS7
        mov [s4], 'O'
        ret
    blkLftColS7:
        cmp [s1], 'X'
        jne blkMidColS2
        cmp [s4], 'X'
        jne blkMidColS2
        cmp [s7], ' '
        jne blkMidColS2
        mov [s7], 'O'
        ret
    blkMidColS2:                                ;computer move blks for mid col
        cmp [s2], ' '
        jne blkMidColS5
        cmp [s5], 'X'
        jne blkMidColS5
        cmp [s8], 'X'
        jne blkMidColS5
        mov [s2], 'O'
        ret
    blkMidColS5:
        cmp [s2], 'X'
        jne blkMidColS8
        cmp [s5], ' '
        jne blkMidColS8
        cmp [s8], 'X'
        jne blkMidColS8
        mov [s5], 'O'
        ret
    blkMidColS8:
        cmp [s2], 'X'
        jne blkRhtColS3
        cmp [s5], 'X'
        jne blkRhtColS3
        cmp [s8], ' '
        jne blkRhtColS3
        mov [s8], 'O'
        ret
    blkRhtColS3:                                ;computer move blks for rht col
        cmp [s3], ' '
        jne blkRhtColS6
        cmp [s6], 'X'
        jne blkRhtColS6
        cmp [s9], 'X'
        jne blkRhtColS6
        mov [s3], 'O'
        ret
    blkRhtColS6:
        cmp [s3], 'X'
        jne blkRhtColS9
        cmp [s6], ' '
        jne blkRhtColS9
        cmp [s9], 'X'
        jne blkRhtColS9
        mov [s6], 'O'
        ret
    blkRhtColS9:
        cmp [s3], 'X'
        jne blkLftDiagS1
        cmp [s6], 'X'
        jne blkLftDiagS1
        cmp [s9], ' '
        jne blkLftDiagS1
        mov [s9], 'O'
        ret
    blkLftDiagS1:                               ;computer move blks for lft diag
        cmp [s1], ' '
        jne blkLftDiagS5
        cmp [s5], 'X'
        jne blkLftDiagS5
        cmp [s9], 'X'
        jne blkLftDiagS5
        mov [s1], 'O'
        ret
    blkLftDiagS5:
        cmp [s1], 'X'
        jne blkLftDiagS9
        cmp [s5], ' '
        jne blkLftDiagS9
        cmp [s9], 'X'
        jne blkLftDiagS9
        mov [s5], 'O'
        ret
    blkLftDiagS9:
        cmp [s1], 'X'
        jne blkRhtDiagS3
        cmp [s5], 'X'
        jne blkRhtDiagS3
        cmp [s9], ' '
        jne blkRhtDiagS3
        mov [s9], 'O'
        ret
    blkRhtDiagS3:                               ;computer move blks for rht diag
        cmp [s3], ' '
        jne blkRhtDiagS5
        cmp [s5], 'X'
        jne blkRhtDiagS5
        cmp [s7], 'X'
        jne blkRhtDiagS5
        mov [s3], 'O'
        ret
    blkRhtDiagS5:
        cmp [s3], 'X'
        jne blkRhtDiagS7
        cmp [s5], ' '
        jne blkRhtDiagS7
        cmp [s7], 'X'
        jne blkRhtDiagS7
        mov [s5], 'O'
        ret
    blkRhtDiagS7:
        cmp [s3], 'X'
        jne compMoveForRand
        cmp [s5], 'X'
        jne compMoveForRand
        cmp [s7], ' '
        jne compMoveForRand
        mov [s7], 'O'
        ret

;-------------------------------comp rand moves-------------------------------
compMoveForRand:
    checkS5First:                               ;computer steals S5 advantage :)
        cmp [s5], ' '
        jne loopRand
        mov [s5], 'O'
        ret
    loopRand:
        cinvoke rand                            ;random int is returned to EAX
        cdq                                     ;convert EAX to 64-bit quad word EDX:EAX
        mov ebx, 9
        idiv ebx                                ;edx remainder: now is 0-8
        cmp [s1 + edx], ' '                     ;check if (s1 + offset) == empty space
        jne loopRand                            ;if not empty, choose another rand
        mov [s1 + edx], 'O'                     ;if empty, place O
        ret

;--------------------------------check computer O win--------------------------------
checkOWin:
    topRowO:
        cmp [s1], 'O'
        jne midRowO
        cmp [s2], 'O'
        jne midRowO
        cmp [s3], 'O'
        je compWin
    midRowO:
        cmp [s4], 'O'
        jne endRowO
        cmp [s5], 'O'
        jne endRowO
        cmp [s6], 'O'
        je compWin
    endRowO:
        cmp [s7], 'O'
        jne lftColO
        cmp [s8], 'O'
        jne lftColO
        cmp [s9], 'O'
        je compWin
    lftColO:
        cmp [s1], 'O'
        jne midColO
        cmp [s4], 'O'
        jne midColO
        cmp [s7], 'O'
        je compWin
    midColO:
        cmp [s2], 'O'
        jne rhtColO
        cmp [s5], 'O'
        jne rhtColO
        cmp [s8], 'O'
        je compWin
    rhtColO:
        cmp [s3], 'O'
        jne lftDiagO
        cmp [s6], 'O'
        jne lftDiagO
        cmp [s9], 'O'
        je compWin
    lftDiagO:
        cmp [s1], 'O'
        jne rhtDiagO
        cmp [s5], 'O'
        jne rhtDiagO
        cmp [s9], 'O'
        je compWin
    rhtDiagO:
        cmp [s3], 'O'
        jne noOWin
        cmp [s5], 'O'
        jne noOWin
        cmp [s7], 'O'
        je compWin
    noOWin:
        ret

;--------------------------------end game results--------------------------------
playWin:
        call cls
        call printBoard
        cinvoke printf, "%c%c%c[32;1m", 10, 10, 27
        cinvoke printf, "                            _____  _                                  _           _ %c", 10
        cinvoke printf, "                           |  __ \| |                                (_)         | |%c", 10
        cinvoke printf, "                           | |__) | | __ _ _   _  ___ _ __  __      ___ _ __  ___| |%c", 10
        cinvoke printf, "                           |  ___/| |/ _` | | | |/ _ \ '__| \ \ /\ / / | '_ \/ __| |%c", 10
        cinvoke printf, "                           | |    | | (_| | |_| |  __/ |     \ V  V /| | | | \__ \_|%c", 10
        cinvoke printf, "                           |_|    |_|\__,_|\__, |\___|_|      \_/\_/ |_|_| |_|___(_)%c", 10
        cinvoke printf, "                                            __/ |                                   %c", 10
        cinvoke printf, "                                           |___/                                    %c", 10
        jmp finish

drawGame:
        call cls
        call printBoard
        cinvoke printf, "%c%c%c[36;1m", 10, 10, 27
        cinvoke printf, "                               ______ _                       __                    __%c", 10
        cinvoke printf, "                              /  _/ /( )_____   ____ _   ____/ /________ __      __/ /%c", 10
        cinvoke printf, "                              / // __/// ___/  / __ `/  / __  / ___/ __ `/ | /| / / / %c", 10
        cinvoke printf, "                            _/ // /_  (__  )  / /_/ /  / /_/ / /  / /_/ /| |/ |/ /_/  %c", 10
        cinvoke printf, "                           /___/\__/ /____/   \__,_/   \__,_/_/   \__,_/ |__/|__(_)   %c", 10
        jmp finish

compWin:
        call cls
        call printBoard
        cinvoke printf, "%c%c%c[31;1m", 10, 10, 27
        cinvoke printf, "                       ______ _                         _                           %c", 10
        cinvoke printf, "                       | ___ \ |                       | |                          %c", 10
        cinvoke printf, "                       | |_/ / | __ _ _   _  ___ _ __  | | ___  ___  ___  ___       %c", 10
        cinvoke printf, "                       |  __/| |/ _` | | | |/ _ \ '__| | |/ _ \/ __|/ _ \/ __|      %c", 10
        cinvoke printf, "                       | |   | | (_| | |_| |  __/ |    | | (_) \__ \  __/\__ \_ _ _ %c", 10
        cinvoke printf, "                       \_|   |_|\__,_|\__, |\___|_|    |_|\___/|___/\___||___(_|_|_)%c", 10
        cinvoke printf, "                                       __/ |                                        %c", 10
        cinvoke printf, "                                      |___/                                         %c", 10
        jmp finish

finish:
        invoke Sleep, -1

;======================================
section '.data' data readable writeable
;======================================
square  dd 0
s1      db ' '
s2      db ' '
s3      db ' '
s4      db ' '
s5      db ' '
s6      db ' '
s7      db ' '
s8      db ' '
s9      db ' '

;====================================
section '.idata' import data readable
;====================================
library msvcrt,'msvcrt.dll',kernel32,'kernel32.dll'
import msvcrt,printf,'printf',scanf,'scanf',rand,'rand',srand,'srand',time,'time'
import kernel32,Sleep,'Sleep'
