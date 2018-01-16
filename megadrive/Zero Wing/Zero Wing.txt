// Zero Wing
// #ID = 587

// ADDRESS STUFF -------------------------------------------------------------
function demoMode() => bit7(0x0) != 0
function titleScreen() => byte(0x05) == 1
function cheatScreen() => word(0xfffa) == 0x0f50
function invincibility() => byte(0x0e4) == 1
function difficulty() => byte(0x00a)
function normalOrAbove() => never(difficulty() == 0)

function levelId() => byte(0x0e2)
level1 = 0
level2 = 1
level3 = 2
level4 = 3
level5 = 4
level6 = 5
level7 = 6
level8 = 7
levelName = {
    level1: "Natols",
    level2: "Legrous",
    level3: "Pleades",
    level4: "Aquese",
    level5: "Submarine Tunnel",
    level6: "Barracade Zone",
    level7: "Bellon",
    level8: "Gerbarra"
}
function levelStart() => byte(0x0e0) == 0

function introScene() => byte(0x06)
segaScreen = 0x05
duringIntroScene1 = 0x09
duringIntroScene2 = 0x10
endIntroScene = 0x14

function weaponLevel() => byte(0x136)
function weaponUltraPower() => bit2(0xbbb) == 1
function weapon() => byte(0x162)
homing = 0
laser = 1
valcan = 2
weaponName = {
    homing: "Homing",
    laser: "Laser",
    valcan: "Valcan"
}

function lives() => byte(0x0fc)
function score10e1() => low4(0x0f2)
function score10e2() => high4(0x0f2)
function score10e3() => low4(0x0f3)
function score10e4() => high4(0x0f3)
function score10e5() => low4(0x0f0)
function score10e6() => high4(0x0f0)
function score10e7() => low4(0x0f1)
function score10e8() => high4(0x0f1)


// FUNCTIONS -----------------------------------------------------------------

function livesDecreased() => lives() < prev(lives())

function finishLevelConditions(level) {
    once(levelId() == level) &&
    levelId() > prev(levelId()) &&
    levelId() == level + 1 &&
    normalOrAbove() &&
    never(titleScreen()) &&
    never(levelId() > level + 1)
}

function cheevoNoDeathLevel(level) {
    achievement(
        title = "Mastered "+ levelName[level],
        description = "Finish "+ levelName[level] +" without losing a life and starting with no powerups (>= Normal) - use secret menu",
        points = 5,
        trigger = 
            once(levelStart()) &&
            once(weaponLevel() == 0) &&
            finishLevelConditions(level) &&
            never(livesDecreased()) &&
            never(cheatScreen()) &&
            never(invincibility())
    )
}
cheevoNoDeathLevel(level1)
cheevoNoDeathLevel(level2)
cheevoNoDeathLevel(level3)
cheevoNoDeathLevel(level4)
cheevoNoDeathLevel(level5)
cheevoNoDeathLevel(level6)
cheevoNoDeathLevel(level7)
cheevoNoDeathLevel(level8)


function cheevoWeaponLevel3(wpn) {
    achievement(
        title = "Max "+ weaponName[wpn] +" Unit",
        description = "Max "+ weaponName[wpn] +" unit from level 1 to 3 without changing your weapon",
        points = 5,
        trigger = 
            once(weapon() == wpn) &&
            once(weaponLevel() == 1) &&
            once(weaponLevel() == 2) &&
            weaponLevel() == 3 &&
            never(weapon() != prev(weapon())) &&
            never(demoMode())
    )
}
cheevoWeaponLevel3(homing)
cheevoWeaponLevel3(laser)
cheevoWeaponLevel3(valcan)


function hiScore(num) {
    if(num == 1) {
        str = "500.000"
        score = score10e5() >= 5
        pts = 5
    }
    else if(num == 2) {
        str = "1.000.000"
        score = score10e6() >= 1
        pts = 10
    }
    achievement(
        title = "High Score "+ num,
        description = "Get a score higher than "+ str +" on a regular gameplay (>= Normal, no cheats)",
        points = 5,
        trigger = score &&
            normalOrAbove() &&
            never(cheatScreen()) &&
            never(demoMode())
    )
}
hiScore(1)
hiScore(2)


// SIMPLE ACHIEVEMENTS -------------------------------------------------------

achievement(
    title = "All you base are belong to us",
    description = "Watch the best japanese to english translated intro scene ever",
    points = 1,
    trigger =
        once(introScene() == segaScreen) &&
        once(introScene() == duringIntroScene1) &&
        once(introScene() == duringIntroScene2) &&
        prev(introScene() == endIntroScene) &&
        introScene() != endIntroScene &&
        never(prev(introScene() < 0x05))
)

achievement(
    title = "Cat Zig",
    description = "Have 9 lives or more on regular gameplay (>= Normal) - no cheat allowed",
    points = 5,
    trigger = once(titleScreen()) &&
        once(lives() == 4) && prev(lives()) < 9 && lives() >= 9 &&
        normalOrAbove() &&
        never(cheatScreen()) && never(demoMode()) && never(invincibility())
)

achievement(
    title = "Ultra Power",
    description = "Get the level 4 power up on a regular gameplay (no cheats)",
    points = 5,
    trigger =
        once(levelId() == 0) &&
        once(levelStart()) &&
        weaponUltraPower() &&
        never(cheatScreen()) &&
        never(demoMode())
)


// LEADERBOARDS --------------------------------------------------------------

difficultyName = {
    0: easy,
    1: normal,
    2: hard
}

function leaderboardScore(dif) {
    leaderboard(
        title = "High Score on regular gameplay - "+ diffcultyName[dif],
        description = "High Score on normal gameplay until game over screen - "+ difficultyName[dif],
        start = difficulty() == dif && levelId() == level1 && levelStart(),
        cancel = cheatScreen(),
        submit = gameOverScreen(),
        value = 
            score10e8() * 100000000 +
            score10e7() * 10000000 +
            score10e6() * 1000000 +
            score10e5() * 100000 +
            score10e4() * 10000 +
            score10e3() * 1000 +
            score10e2() * 100 +
            score10e1() * 10
        // that VAL using BCD: d0xf1*10000000+d0xf0*100000+d0xf3*1000+d0xf2*10
    )
}
leaderboardScore(0)
leaderboardScore(1)
leaderboardScore(2)
