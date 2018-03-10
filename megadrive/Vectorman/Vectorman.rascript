// Vectorman
// #ID = 25

// $001B: Difficulty 00=lame 01=wicked 02=insane
function difficulty() => byte(0x001b)
function normalOrAbove() => never(difficulty() == 0)

// $E88E: bit0: demo
function noDemo() => never(bit0(0xe88e) == 1)

// $C47F: Stage
//        00=stage 1 xxxx 09=stage 10
//        10=Segascreen
//        ff=Menu
function levelId() => byte(0xc47f)
function segaScreen() => levelId() == 0x10
level1 = 0
level2 = 1
level3 = 2
level4 = 3
level5 = 4
level6 = 5
level7 = 6
level8 = 7
level9 = 8
level10 = 9
level11 = 10
level12 = 11
level13 = 12
level14 = 13
level15 = 14
level16 = 15
levelName = {
    level1: "Terraport",
    level2: "Metalhead",
    level3: "Tidal Surge",
    level4: "Absolute Zero",
    level5: "Arctic Ridge",
    level6: "Bamboo Mill",
    level7: "Rock and Roller",
    level8: "Death Alley",
    level9: "Hidroponic Lab",
    level10: "Superstructure",
    level11: "Stayin' Alive",
    level12: "Nightscape",
    level13: "Dark Ruins",
    level14: "Underground Vault",
    level15: "Worldlink Center",
    level16: "Twist and Shout"
}

// $E864: (16bit) score x 2e16
// $E866: (16bit) score
function scoreX1() => word(0xe866)
function scoreX2e16() => word(0xe864)

// $E878: Health Balls
function health() => byte(0xe878)

// $E874: Photons?
function photons() => byte(0xe874)

// $E886: special weapon ammunition

// $E88D: TVs destroyed
function destroyedTVs() => byte(0xe88d)

// $E890: timer seconds
// $E891: timer minutes


// cheat codes ----------------------------------------------------------------

// $A006: (16bit)
//        87b0 = Title Screen
//        e7df = debug menu
function titleScreen() => word(0xa006) == 0x87b0
function debugScreen() => word(0xa006) == 0xe7df

function cheatedHealth() => byte(0x1e) != 4
function cheatedLevel() => byte(0x20) != 0
function cheatedLives() => byte(0x21) !=3
function noDebug() => never(cheatedHealth()) && never(cheatedLevel()) && never(cheatedLives()) && never(debugScreen())

// $DCD6: [Cheats]
//        16-Bits ffff=Light Bulbs
// $DCD8: [Cheats]
//        16-Bits e32a=Light Bulbs

// $E8AA: [Cheat]
//        0a=ABRACADABR_A
function abracadabr_a() => byte(0xe8aa)
function cheatHealth() => abracadabr_a() == 0x0a

// $E8A9: [Cheat]
//        07=CALLACA_B
// $E8B7: [Cheats]
//        ff=Invisibility ??
// $E360: [Cheat]
//        (16bit) 0000 = invisible
function callaca_b() => byte(0xe8a9)
function cheatInvisible() => word(0xe360) == 0

// $E8AE: [Cheat]
//        06=DRACUL_A
// $E8B4: [Cheats]
//        FF=Slow Motion active
function dracul_a() => byte(0xe8ae)
function cheatSlow() => byte(0xe8b4) == 0xff

function noCheats() => never(segaScreen()) && once(titleScreen()) && never(cheatInvisible()) && never(cheatSlow()) && never(cheatHealth()) && noDebug()

achievement(
    title = "ABRACADABRA",
    description = "Well done cheater, from now on most of the cheevos won't work. Reset the game.",
    points = 1,
    trigger = prev(abracadabr_a()) == 0x0a && abracadabr_a() == 0 && health() > prev(health())
)

achievement(
    title = "CALL A CAB",
    description = "All right, you can explore this stage. But you won't get more cheevos until resetting.",
    points = 1,
    trigger = prev(callaca_b()) == 0x07 && callaca_b() == 0 && cheatInvisible()
)

achievement(
    title = "DRACULA",
    description = "This is not Castlevania! Reset the game or other cheevos won't work.",
    points = 1,
    trigger = prev(dracul_a()) == 0x06 && dracul_a() == 0 && cheatSlow()
)
//-----------------------------------------------------------------------------

// progress-based -------------------------------------------------------------

function finishLevel(level) {
    achievement(
        title = "Finished "+ levelName[level],
        description = "Finish "+ levelName[level] +" (>= Wicked) - no cheats allowed",
        points = 5,
        trigger =
            once(levelId() == level)
            && levelId() == level+1
            && levelId() > prev(levelId())
            && normalOrAbove() && noCheats() && noDemo()
    )
}
finishLevel(0)
finishLevel(1)
finishLevel(2)
finishLevel(3)
finishLevel(4)
finishLevel(5)
finishLevel(6)
finishLevel(7)
finishLevel(8)
finishLevel(9)
finishLevel(10)
finishLevel(11)
finishLevel(12)
finishLevel(13)
finishLevel(14)
finishLevel(15)
    

// lives ----------------------------------------------------------------------
// $E87C: lives
function lives() => byte(0xe87c)

// - VectorCat: 9 lives
achievement(
    title = "VectorCat",
    description = "Have 9 lives or more (>= wicked) - no cheats allowed",
    points = 5,
    trigger =
        once(lives() == 4) && prev(lives()) < 9 && lives() >= 9
        && normalOrAbove() && noCheats() && noDemo()
)
//-----------------------------------------------------------------------------


// SEGA LOGO EASTER EGGS ------------------------------------------------------

// $E2EA: [Sega logo]
//        Total
// $E2E8: [Sega logo]
//        Caught
function caughtLetters() => byte(0xe2e8)


function levelWarp(num) {
    if(num == 5)  {
        pts = 5
        letters = 90
    } else if(num == 10) {
        pts = 7
        letters = 110
    }
    achievement(
        title = "Warp "+ num,
        description = "Get the warp to level "+ num,
        points = pts,
        trigger = segaScreen() && caughtLetters() >= letters
    )
}

levelWarp(5)
levelWarp(10)
//-----------------------------------------------------------------------------

// weapons --------------------------------------------------------------------

// $E390: weapon
//        1 = rapidfire
//        2 = wave (spreadshot)
//        3 = bolo
//        4 = orb
//        5 = shield
function weapon() => byte(0xe390)
rapidfire = 1
wave = 2
bolo = 3
orb = 4
shield = 5
weaponName = {
    rapidfire:  "Rapidfire",
    wave:       "Wave",
    bolo:       "Bolo",
    orb:	"Orb",
    shield:	"Shield"
}

function weaponCheevo(wpn) {
    achievement(
        title = "I Hate TV - "+ weaponName[wpn],
        description = "Destroy 10 TVs while using "+ weaponName[wpn] +" weapon",
        points = 5,
        trigger =
	    repeated(11, destroyedTVs() > prev(destroyedTVs()))
            && unless(prev(weapon()) != wpn)
            && (
                noCheats() && noDemo()
                || byte(0) == byte(0)
            )
    )
}
weaponCheevo(rapidfire)
weaponCheevo(wave)
weaponCheevo(bolo)

function collectItem(wpn) {
    achievement(
        title = weaponName[wpn] +" Collector",
        description = "Collect the "+ weaponName[wpn] +" 5 times",
        points = 5,
        trigger = 
	    repeated(5, weapon() == wpn)
            && unless(prev(weapon()) == wpn)
            && (
                noCheats() && noDemo()
                || byte(0) == byte(0)
            )
    )
}
collectItem(orb)
collectItem(shield)

//-----------------------------------------------------------------------------


//- perfect bonus round - sobreviver por um minuto (ganha 25000 pontos)

//- Transformações
//  - drill - pode quebrar alguns pisos
//  - fish - se move mais rÃ¡pido na Ã¡gua
//  - missile - atravÃ©s do teto?
//  - buggy - quebrar paredes
//  - bomb - destrÃ³i a porra toda
//  - jet - voar
//  - parachute - cai lentamente
//
//- na fase 4 existem dois caminhos (vale a pena fazer um cheevo para cada caminho?).
//
//- pegar todas as life+ orbs
//
//- terminar o jogo sem pegar life+ orbs
//












//achievement(
//    title = "Salvage King", description = "Earn over 100000 points", points = 20,
//    id = 109, badge = "00192", published = "02/03/2013 01:37:12", modified = "02/03/2013 02:39:40",
//    trigger = word(0x00E864) >= 0x0001 && word(0x00E866) >= 0x86A0 && never(byte(0x00E88E) == 0x01)
//)
//
//achievement(
//    title = "Energised", description = "Collect over 200 Photons in total", points = 10,
//    id = 110, badge = "00080", published = "02/03/2013 01:45:21", modified = "10/06/2016 19:26:29",
//    trigger = never(byte(0x00E88E) == 0x01) && word(0x00E874) >= 0x00C8
//)
//
//achievement(
//    title = "Tidal Surge", description = "Reach Day 3", points = 10,
//    id = 111, badge = "00193", published = "02/03/2013 01:57:27", modified = "02/03/2013 02:39:45",
//    trigger = word(0x00AF70) == 0x000D && never(byte(0x00E88E) == 0x01)
//)
//
//achievement(
//    title = "Satellite", description = "Destroy all TVs in the first level", points = 30,
//    id = 112, badge = "00136", published = "02/03/2013 02:02:01", modified = "25/01/2015 11:31:59",
//    trigger = byte(0x00E88D) == 0x1E && byte(0x00AF70) == 0x30 && never(byte(0x00E88E) == 0x01)
//)
//
//achievement(
//    title = "Cleanup Operation", description = "Complete the first level within 2 minutes", points = 20,
//    id = 114, badge = "00186", published = "02/03/2013 17:59:58", modified = "02/03/2013 18:02:51",
//    trigger = byte(0x00E87E) == 0x1C && word(0x00E890) >= 0x0300 && byte(0x00AF70) == 0x30
//)
//
//achievement(
//    title = "Square Eyes", description = "Destroy 10 TVs", points = 15,
//    id = 108, badge = "00191", published = "02/03/2013 01:28:14", modified = "02/03/2013 02:38:51",
//    trigger = never(byte(0x00E88E) == 0x01) && byte(0x00E88D) >= 0x0A
//)
