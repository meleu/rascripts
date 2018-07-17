// Shinobi III: Return of the Ninja Master
// #ID = 64

false = 0
true = 1

// $0000: Upper4 = initial Shurikins
//        0 = 50 (default)
//        1 = 60
//        2 = 70
//        3 = 0
//        4 = 10
//        5 = 20
//        6 = 30
//        7 = 40
//        b = infinite shurikins (cheat)
function defShurikins() => high4(0x0000)
function infiniteShurikins() => high4(0x0000) == 0xb

defShurikinsAmount = {
     0: 0x3,
    10: 0x4,
    20: 0x5,
    30: 0x6,
    40: 0x7,
    50: 0x0,
    60: 0x1,
    70: 0x2,
    999: 0x0b,
}

// $0000: Lower4 = Difficulty
//        0 = Normal (default)
//        5 = Easy
//        a = Hard
//        f = Expert
function normalOrAbove() => low4(0x0000) != 5
function expertMode() => low4(0x0000) == 0xf

// $000A: invincibility cheat = 52
function invincibilityCheat() => byte(0x000a) == 0x52

function noCheats() => !invincibilityCheat() && !infiniteShurikins()


// $0030: 90 = demo mode
//        da = playing
function noDemo() => byte(0x0030) != 0x90


// $00E6: Power
function powerUp() => byte(0x00e6) == 0x01

// $37A7: Round Finish Flag
//        change from N to N+1 when finishing a round (even on the last round)
//        Hint: ($37a7 > $37ad) means end of a level
function nextRound() => byte(0x37a7)

// $37AC: sub-round
// $37AD: round
function round() => byte(0x37ad)
function subRound() => byte(0x37ac)
function completeRound() => word(0x37ac)

function roundClear() => nextRound() > round()


// $37B1: Continue (default is 3)
function continuesLeft() => byte(0x37b1)
function noContinues() => never(continuesLeft() < prev(continuesLeft()))
// TODO: detect game over (maybe lives == 0) for noContinues()


// $37B6: (16bit) score x10e4
// $37B8: (16bit) score
function score()   => word(0x37b8)
function score10e4() => word(0x37b6)

// $37E1: lives
function lives() => byte(0x37e1)

// $37E2: (16bit) Shurikins amount
function shurikins() => word(0x37e2)
function noShurikin() => never(shurikins() < prev(shurikins()))


// $37E7: Ninjutsu amount
function ninjitsuAmount() => byte(0x37e7)

// $4156: (lower4) 2 = using fushin ninjitsu (high jump)
function usingFushinJitsu() => low4(0x4156) == 2

// $415E: (16bit) non-zero = using ikazuchi ninjitsu (normally start with 4 and decreases as you got hit)
function usingIkazuchiJitsu() => word(0x415e) > 0

function noNinjitsu() => never(usingFushinJitsu()) && never(usingIkazuchiJitsu()) && never(move() == 0x40) && never(move() == 0x44)
    
// $37E8: Health
//        full = 10
//        dead = 00
function health() => byte(0x37e8)

function noDamage() => never(health() < prev(health())) && never(move() == 0x28)


// $37E6: Ninjutsu selected
//        0x00=Jitsu of Ikazuchi
//        0x01=Jitsu of Kariu
//        0x02=Jitsu of Fushin
//        0x03=Jitsu of Mijin
// $37EE: (16bit) Shinobi Bonus = 0300
//        in the Round Clear Stage
// $3D2A: X - area

// $3D2A: Shinobi Bonus
//        0 = didn't use shurikin
//        1 = used shurikin
//        8 = didn't use shurikin, while on "round clear" screen
function shinobiBonus() => never(byte(0x3d2a) == 1)

// $415A: character position
//        01 = stand
//        03 = defending
//        05 = using dagger (no power)
//        06 = using sword (pow)
//        07 = throwing shurikin
//        08 = crouch
//        0a = defending while crouching
//        0c = kicking while crouching
//        0d = using sword while crouching
//        0e = throwing shurikin while crounching
//        10 = jumping
//        11 = while on double jump roll
//        13 = using sword while jumping
//        16 = throwing shurikin while jumping
//        1a = walking
//        20 = grabing the roof
//        24 = throwing shurikin while grabing the roof
//        28 = damage
//        38 = surfing
//        39 = shurikin while surfing
//        3b = jumping while surfing
//        3d = using dagger while surfing
//        3f = using sword while surfing
//        40 = using ninjitsu
function move() => byte(0x415a)

function noJump() => never(move() == 0x10)

function noStand() => never(move() == 0x01)
    && never(move() == 0x1a)
    && never(move() == 0x03)
    && never(move() == 0x08)
    && never(move() == 0x0a)
    
function surfBoardOnly() => never(move() == 0x39)
    && never(move() == 0x3d)
    && never(move() == 0x3f)
    
function dropKickOnly() => never(move() == 0x05)
    && never(move() == 0x06)
    && never(move() == 0x07)
    && never(move() == 0x0c)
    && never(move() == 0x0d)
    && never(move() == 0x0e)
    && never(move() == 0x13)
    && never(move() == 0x16)
    && noShurikin()

// $F822: Music type
//        (16bit) 0693 = sub-boss match
function music() => word(0xf822)
function subBossStart() => once(prev(music()) != 0x0693)
function subBossFinish() => prev(music()) == 0x0693 && music() == 0x6452


// $414e: (16bit) ninja posX
// $4152: (16bit) ninja posY
// $e000: (16bit) background X
// $e004: (16bit) background Y
function ninjaPosX() => word(0x414e)
function ninjaPosY() => word(0x4152)
function bgPosX() => word(0xe000)
function bgPosX() => word(0xe004)

secretSpots = {
  "s12a": [ 0x3a0, 0xc0, 0x2f8, 0x5f, 0x33f, 0x88, 0x291, 0x00 ],
  "s12b": [ 0x718, 0x80, 0x6a8, 0x1f, 0x697, 0x48, 0x5e7, 0x00 ],
  "s22":  [ 0x39d, 0x40, 0x32d, 0xfffe, 0x30f, 0x00, 0x25f, 0xffe8 ],
  "s31":  [ 0x30f, 0x90, 0x29f, 0xffe8, 0x2e7, 0x68, 0x237, 0xffe7 ],
  "s32":  [ 0xaf0, 0x100, 0xa80, 0x9f, 0xa4f, 0xc8, 0x99f, 0x68 ],
  "s42L": [ 0x2d4, 0x88, 0x24f, 0xfffe, 0x28d, 0x0, 0x1dd, 0xffe8 ],
  "s52a": [ 0xff, 0x180, 0x8f, 0xff, 0x51, 0x138, 0x0, 0xb8 ],
  "s52b": [ 0x7f0, 0x1c0, 0x6c0, 0x120, 0x78b, 0x198, 0x6c0, 0x11a ],
  "s52c": [ 0x7f0, 0x110, 0x6c0, 0x5f, 0x75b, 0xcf, 0x6ab, 0x5f ],
  "s52d": [ 0x1e0, 0x670, 0xc0, 0x5af, 0x125, 0x648, 0x75, 0x588 ], 
  "s72":  [ 0xabf, 0x80, 0xa4f, 0xffff, 0xa3f, 0x58, 0x98f, 0xffe8 ]
}
// 4 bottom right coordinates, 4 top left coordinates
//secretSpot12a = [ 0x3a0, 0xc0, 0x2f8, 0x5f, 0x33f, 0x88, 0x291, 0x00 ]
//secretSpot12b = [ 0x718, 0x80, 0x6a8, 0x1f, 0x697, 0x48, 0x5e7, 0x00 ]
//secretSpot22  = [ 0x39d, 0x40, 0x32d, 0xfffe, 0x30f, 0x00, 0x25f, 0xffe8 ]
//secretSpot31  = [ 0x30f, 0x90, 0x29f, 0xffe8, 0x2e7, 0x68, 0x237, 0xffe7 ]
//secretSpot32  = [ 0xaf0, 0x100, 0xa80, 0x9f, 0xa4f, 0xc8, 0x99f, 0x68 ]
//secretSpot42L = [ 0x2d4, 0x88, 0x24f, 0xfffe, 0x28d, 0x0, 0x1dd, 0xffe8 ]
//secretSpot52a = [ 0xff, 0x180, 0x8f, 0xff, 0x51, 0x138, 0x0, 0xb8 ]
//secretSpot52b = [ 0x7f0, 0x1c0, 0x6c0, 0x120, 0x78b, 0x198, 0x6c0, 0x11a ]
//secretSpot52c = [ 0x7f0, 0x110, 0x6c0, 0x5f, 0x75b, 0xcf, 0x6ab, 0x5f ]
//secretSpot52d = [ 0x1e0, 0x670, 0xc0, 0x5af, 0x125, 0x648, 0x75, 0x588 ] 
//secretSpot72  = [ 0xabf, 0x80, 0xa4f, 0xffff, 0xa3f, 0x58, 0x98f, 0xffe8 ]




// $41C4: 1st boss health
function boss1HP() => byte(0x41c4)

// $41B4: 2nd boss health
function boss2HP() => byte(0x41b4)

// $4188: 3rd boss and last boss (both forms) health
function boss3HP() => byte(0x4188)
function boss7HP() => byte(0x4188)

// $41AE: 4th boss: health of 1st and last form
function boss4HP() => byte(0x41ae)

// $4284: 5th boss health
function boss5HP() => byte(0x4284)

// $4230: 6th boss 1st form health
function boss6HP() => byte(0x4230)

bossHealth = {
    1: boss1HP(),
    2: boss2HP(),
    3: boss3HP(),
    4: boss4HP(),
    5: boss5HP(),
    6: boss6HP(),
    7: boss7HP()
}



// FINISH EACH ROUND [NO NINJITSU]
// ============================================================================

roundName = {
  0: "Zeed's Resurrection",
  1: "Secret Entry",
  2: "Body Weapon",
  3: "Destruction",
  4: "Electric Demon",
  5: "Traps",
  6: "The Final Confrontation"
}

function finishRound(round, noJitsu) {
  name = roundName[round-1]
  desc = "Finish Round "+ round
  requirements = 
      once(completeRound() == (round - 1) * 256)
      && once(completeRound() == (round - 1) * 256 + 1)
      && completeRound() == (round - 1) * 256 + 2
      && roundClear()
      && noCheats()

  if(round == 7) {
      desc = desc +" and beat the game"
      requirements = requirements && bossHealth[round] > 0xf0
  } else {
      requirements = requirements && bossHealth[round] == 0
  }

  
  if(noJitsu == true) {
      name = "Nojitsu "+ round
      desc = desc +" without using Ninjitsu"
      requirements = requirements && noNinjitsu()
  }
  
  achievement(
    title = name,
    description = desc ,
    points = 1,
    trigger = requirements
  )
}
finishRound(1, false)
finishRound(2, false)
finishRound(3, false)
finishRound(4, false)
finishRound(5, false)
finishRound(6, false)
finishRound(7, false)

finishRound(1, true)
finishRound(2, true)
finishRound(3, true)
finishRound(4, true)
finishRound(5, true)
finishRound(6, true)
finishRound(7, true)


// BEAT THE GAME [NO NINJITSU / EXPERT + NO CONTINUES]
// ============================================================================

allRounds = roundClear()
for round in range(1, 7) {
    allRounds = allRounds
        && once(completeRound() == (round - 1) * 256)
        && once(completeRound() == (round - 1) * 256 + 1)
        && once(completeRound() == (round - 1) * 256 + 2)
}

achievement(
    title = "Nojitsu Master",
    description = "Beat the game without using ninjitsu",
    points = 5,
    trigger = allRounds
      && noCheats()
      && noNinjitsu()
)

achievement(
    title = "Shinobi",
    description = "Beat the game on expert without using continues",
    points = 1,
    trigger = allRounds
      && noCheats()
      && expertMode()
      && noContinues()
)


// 9 LIVES (EXPERT)
// ============================================================================

achievement(
    title = "9 Lives",
    description = "Get 9 lives (expert mode)",
    points = 1,
    trigger =
      lives() >= 9
      && round() != 0
      && once(lives() == 2)
      && expertMode()
)


// collect shurikins
// ============================================================================

function collectShurikins(amount) {
    shurikinAmountCondition = defShurikins() == defShurikinsAmount[0] && shurikins() >= amount

    for defAmount in range(10, 70, 10) {
        shurikinAmountCondition = shurikinAmountCondition
            || defShurikins() == defShurikinsAmount[defAmount] && shurikins() >= defAmount + amount
    }

    achievement(
        title = "Shurikin Collector "+ amount,
        description = "Collect "+ amount +" shurikins plus the default amount",
        points = 1,
        trigger =
          noCheats()
          && ( shurikinAmountCondition )
    )
}

collectShurikins(100)
collectShurikins(200)
collectShurikins(300)


// HI SCORES
// ============================================================================
function hiScore(pts) {
    adjective = {
        50 : "Nice",
        150: "Good",
        300: "Awesome"
    }
    value = {
        50 : 5,
        150: 15,
        300: 30        
    }
    achievement(
        title = adjective[pts] +" Score",
        description = "Get "+ pts +"k score (>= Normal)",
        points = 1,
        trigger = normalOrAbove()
            && score10e4() > value[pts]
            && score() > 0
            && noCheats()
    )
}

hiScore(50)
hiScore(150)
hiScore(300)


// BOSS CHALLENGES
// ============================================================================

// ideas for sub-bosses
// 1: (samurai) no jump, no damage, no shurikins, no ninjitsu
// 2: (horse) no damage, no ninjitsu
// 3: (little-brains) don't touch the floor (floor is lava)
// 4: (surfing) damageless
// 5: (robot on fire) drop kick only, no damage
// 6: (eagle man) no damage, no ninjitsu

function subBossChallenge(round) {
    challenge = {
        1: "Acrophobia",
        2: "Like a Cowboy",
        3: "The Floor is Lava",
        4: "Surfing is a Martial Art",
        5: "Drop Your Weapons",
        6: "I Believe I Can Fly"
    }
    desc = {
        1: "no jump, damage, shurikins, ninjitsu",
        2: "no damage, ninjitsu",
        3: "don't touch the floor, no ninjitsu",
        4: "use only your surfboard",
        5: "use only the drop kick move, no damage",
        6: "no damage, ninjitsu"
    }
    roundID = {
        1: 0x0000,
        2: 0x0100,
        3: 0x0200,
        4: 0x0300,
        5: 0x0400,
        6: 0x0500
    }

    conditions = never(completeRound() != roundID[round])
    if(round == 1) {
        conditions = conditions && noJump() && noDamage() && noShurikin() && noNinjitsu()
    } else if(round == 2 || round == 6) {
        conditions = conditions && noDamage() && noNinjitsu()
    } else if(round == 3) {
        conditions = once(bgPosX() < 0xac0) && noStand() && noNinjitsu() && noDamage()
    } else if(round == 4) {
        conditions = conditions && surfBoardOnly()
    } else if(round == 5) {
        conditions = conditions && dropKickOnly() && noDamage() && noNinjitsu()
    }

    achievement(
        title = challenge[round],
        description = "Defeat sub-boss "+ round +" - "+ desc[round],
        points = 1,
        trigger = conditions
            && subBossStart()
            && subBossFinish()
            && noCheats()
    )
}

subBossChallenge(1)
subBossChallenge(2)
subBossChallenge(3)
subBossChallenge(4)
subBossChallenge(5)
subBossChallenge(6)




// - (7) finish each boss no damage and no ninjitsu
//   - (1) 1st boss no damage/shurikin/ninjitsu





// SECRET SPOTS
// ============================================================================

function ninjaPosX() => word(0x414e)
function ninjaPosY() => word(0x4152)
function bgPosX() => word(0xe000)
function bgPosY() => word(0xe004)

secretSpots = {
  "s12a": [ 0x3a0, 0xc0, 0x2f8, 0x5f, 0x33f, 0x88, 0x291, 0x00 ],
  "s12b": [ 0x718, 0x80, 0x6a8, 0x1f, 0x697, 0x48, 0x5e7, 0x00 ],
  "s22":  [ 0x39d, 0x40, 0x32d, 0xfffe, 0x30f, 0x00, 0x25f, 0xffe8 ],
//  "s31":  [ 0x30f, 0x90, 0x29f, 0xffe8, 0x2e7, 0x68, 0x237, 0xffe7 ],
  "s32":  [ 0xaf0, 0x100, 0xa80, 0x9f, 0xa4f, 0xc8, 0x99f, 0x68 ],
  "s42L": [ 0x2d4, 0x88, 0x24f, 0xfffe, 0x28d, 0x0, 0x1dd, 0xffe8 ],
  "s52a": [ 0xff, 0x180, 0x8f, 0xff, 0x51, 0x138, 0x0, 0xb8 ],
  "s52b": [ 0x7f0, 0x1c0, 0x6c0, 0x120, 0x78b, 0x198, 0x6c0, 0x11a ],
  "s52c": [ 0x7f0, 0x110, 0x6c0, 0x5f, 0x75b, 0xcf, 0x6ab, 0x5f ],
  "s52d": [ 0x1e0, 0x670, 0xc0, 0x5af, 0x125, 0x648, 0x75, 0x588 ], 
  "s72":  [ 0xabf, 0x80, 0xa4f, 0xffff, 0xa3f, 0x58, 0x98f, 0xffe8 ]
}


for spot in secretSpots
{
    cheevoTitle = "Secret Spot "

    posCondition =
        ninjaPosX()    <= secretSpots[spot][0]
        && ninjaPosY() <= secretSpots[spot][1]
        && bgPosX()    <= secretSpots[spot][2]
        && bgPosY()    <= secretSpots[spot][3]
        && ninjaPosX() >= secretSpots[spot][4]
        && ninjaPosY() >= secretSpots[spot][5]
        && bgPosX()    >= secretSpots[spot][6]
        && bgPosY()    >= secretSpots[spot][7]

    if(spot == "s12a" || spot == "s12b")
    {
        posCondition = posCondition
            && completeRound() == 0x0001

        if(spot == "s12a") {
            cheevoTitle = cheevoTitle + "1a"
            spotDesc = "first "
        }
        else {
            cheevoTitle = cheevoTitle + "1b"
            spotDesc = "second "
        }

        spotDesc = spotDesc +"secret spot on round 1"
    }
    else if(spot == "s22")
    {
        cheevoTitle = cheevoTitle + "2"

        posCondition = posCondition
            && completeRound() == 0x0101
            
        spotDesc = "secret spot on round 2"
    }
    else if(spot == "s32")
    {
        cheevoTitle = cheevoTitle + "3"

        posCondition = posCondition
            && completeRound() == 0x0201
            
        spotDesc = "secret spot on round 3"
    }
    else if(spot == "s42L")
    {
        cheevoTitle = cheevoTitle + "4"

        posCondition = posCondition
            && completeRound() == 0x0301
            && lives() > prev(lives())
            
        spotDesc = "secret spot on round 4 and get the extra life"
    }
    else if(spot == "s52a" || spot == "s52b" || spot == "s52c" || spot == "s52d")
    {
        posCondition = posCondition
            && completeRound() == 0x0401

        if(spot == "s52a") {
            cheevoTitle = cheevoTitle + "5a"
            spotDesc = "first "
        } else if(spot == "s52b") {
            cheevoTitle = cheevoTitle + "5b"
            spotDesc = "second "
        } else if(spot == "s52c") {
            cheevoTitle = cheevoTitle + "5c"
            spotDesc = "third "
        } else {
            cheevoTitle = cheevoTitle + "5d"
            spotDesc = "fourth "
        }

        spotDesc = spotDesc +"secret spot on round 5"
    }
    else if(spot == "s72")
    {
        cheevoTitle = cheevoTitle + "7"

        posCondition = posCondition
            && completeRound () == 0x0601
            
        spotDesc = "secret spot on round 7"
    }
    
    achievement(
        title = cheevoTitle,
        description = "Find the "+ spotDesc,
        points = 1,
        trigger = noCheats()
            && posCondition
    )
}











// - (1) shinobi bonus (don't use a shurikin)
// - (1) perfect bonus














//achievement(
//    title = "Shinobi", description = "Beat game as Expert Level without use continue", points = 60,
//    id = 3099, badge = "03584", published = "02/10/2013 00:30:04", modified = "06/07/2018 22:02:16",
//    trigger = low4(0x000000) == 0xF && never(byte(0x0037B1) != 0x03) && word(0x004188) == 0x02FE && 
//              once(byte(0x0037AD) == 0x00) && once(byte(0x0037AD) == 0x01) && once(byte(0x0037AD) == 0x02) && 
//              once(byte(0x0037AD) == 0x03) && once(byte(0x0037AD) == 0x04) && once(byte(0x0037AD) == 0x05) && 
//              once(byte(0x0037AD) == 0x06) && never(byte(0x0037AD) < prev(byte(0x0037AD)))
//)
//
//achievement(
//    title = "Zeed's Resurrection", description = "Finish Round 1", points = 10,
//    id = 250, badge = "65234", published = "20/04/2013 20:01:37", modified = "09/07/2018 00:41:17",
//    trigger = byte(0x0037AD) == 0x00 && byte(0x0037A7) > byte(0x0037AD) && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Secret Entry", description = "Finish Round 2", points = 10,
//    id = 251, badge = "65235", published = "20/04/2013 20:01:42", modified = "09/07/2018 00:41:27",
//    trigger = byte(0x0037A7) > byte(0x0037AD) && byte(0x0037AD) == 0x01 && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Body Weapon", description = "Finish Round 3", points = 10,
//    id = 252, badge = "65236", published = "20/04/2013 20:01:46", modified = "09/07/2018 00:41:35",
//    trigger = byte(0x0037AD) == 0x02 && byte(0x0037A7) > byte(0x0037AD) && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Destruction", description = "Finish Round 4", points = 10,
//    id = 253, badge = "65237", published = "20/04/2013 20:01:51", modified = "09/07/2018 00:41:44",
//    trigger = byte(0x0037AD) == 0x03 && byte(0x0037A7) > byte(0x0037AD) && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Electric Demon", description = "Finish Round 5", points = 10,
//    id = 254, badge = "65238", published = "20/04/2013 20:01:55", modified = "09/07/2018 00:42:26",
//    trigger = byte(0x0037AD) == 0x04 && byte(0x0037A7) > byte(0x0037AD) && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90 && byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Traps", description = "Finish Round 6", points = 10,
//    id = 255, badge = "65239", published = "20/04/2013 20:01:59", modified = "09/07/2018 00:42:35",
//    trigger = byte(0x0037AD) == 0x05 && byte(0x0037A7) > byte(0x0037AD) && byte(0x00000A) != 0x52 && 
//              byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "it is the Shadow...", description = "Finish the Game", points = 20,
//    id = 433, badge = "00649", published = "03/05/2013 17:39:56", modified = "03/05/2013 17:40:13",
//    trigger = byte(0x00FFF8) == 0x01 && byte(0x00002A) == 0x01 && byte(0x0016E8) == 0x01 && byte(0x00F9DF) == 0x01 && 
//              byte(0x00F8EF) == 0x01
//)
//
//achievement(
//    title = "Samurai Lord", description = "Beat Samurai Lord as Expert Level", points = 20,
//    id = 3092, badge = "03577", published = "02/10/2013 00:29:35", modified = "13/11/2013 03:39:06",
//    trigger = byte(0x0037A7) == 0x01 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Master Brain", description = "Beat Master Brain as Expert level", points = 20,
//    id = 3093, badge = "03578", published = "02/10/2013 00:29:39", modified = "13/11/2013 03:39:09",
//    trigger = byte(0x0037A7) == 0x02 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Body Weapons", description = "Beat Body Weapons as Expert Level", points = 20,
//    id = 3094, badge = "03579", published = "02/10/2013 00:29:46", modified = "13/11/2013 03:39:12",
//    trigger = byte(0x0037A7) == 0x03 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Jet", description = "Beat Jet as Expert level", points = 20,
//    id = 3095, badge = "03580", published = "02/10/2013 00:29:50", modified = "13/11/2013 03:39:15",
//    trigger = byte(0x0037A7) == 0x04 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Mecha Godzilla ", description = "Beat Mecha Godzilla as Expert Level", points = 20,
//    id = 3096, badge = "03581", published = "02/10/2013 00:29:54", modified = "13/11/2013 03:39:18",
//    trigger = byte(0x0037A7) == 0x05 && byte(0x000002) == 0xF3
//)
//
//// Ticket 7835: pop whan i select the expert mode in the option
//achievement(
//    title = "Zeed", description = "Beat Zeed as Expert Level", points = 20,
//    id = 3097, badge = "03582", published = "02/10/2013 00:29:57", modified = "13/11/2013 03:39:21",
//    trigger = byte(0x0037A7) == 0x06 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Grand Master", description = "Beat Grand Master as Expert Level", points = 20,
//    id = 3098, badge = "03583", published = "02/10/2013 00:30:00", modified = "13/11/2013 03:39:24",
//    trigger = byte(0x0037A7) == 0x06 && byte(0x000002) == 0xF3 && byte(0x000029) == 0x02 && byte(0x004280) == 0xE4 && 
//              byte(0x000106) == 0x03 && byte(0x004156) == 0x20
//)
//
//achievement(
//    title = "Horse vs Ninja", description = "Beat mini-boss without taking damage in act 1 the Level 2 - Secret Entry as Exp", points = 15,
//    id = 10937, badge = "10747", published = "31/07/2014 03:21:51", modified = "31/07/2014 03:22:13",
//    trigger = never(byte(0x00415A) == 0x32) && byte(0x0037A7) == 0x01 && once(byte(0x00F822) == 0x12) && 
//              byte(0x00F822) == 0x52 && byte(0x0037AC) == 0x00 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Skater-Water VS Robot", description = "Beat mini-boss without taking damage in act 1 the Level 4 - Destruction as Expe", points = 15,
//    id = 10938, badge = "10748", published = "31/07/2014 03:21:56", modified = "31/07/2014 03:22:17",
//    trigger = never(byte(0x00415A) == 0x32) && byte(0x0037A7) == 0x03 && once(byte(0x00F822) == 0xD2) && 
//              byte(0x00F822) == 0x52 && byte(0x0037AC) == 0x00 && byte(0x000002) == 0xF3
//)
//
//achievement(
//    title = "Power Up", description = "Get the power up", points = 5,
//    id = 3107, badge = "03593", published = "02/10/2013 01:04:45", modified = "09/07/2018 01:24:00",
//    trigger = byte(0x0000E6) == 0x01 && byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Newbie Shurikins", description = "Get 100 Shurikins", points = 5,
//    id = 3100, badge = "03585", published = "02/10/2013 00:30:07", modified = "09/07/2018 00:44:19",
//    trigger = byte(0x0037CE) >= 0x64 && byte(0x000030) != 0x90
//)
//
//achievement(
//    title = "Never die", description = "Get 9 Max Live", points = 15,
//    id = 10936, badge = "10746", published = "31/07/2014 03:21:47", modified = "31/07/2014 03:22:10",
//    trigger = byte(0x0037CD) >= 0x09
//)
//
//achievement(
//    title = "More Shurikins", description = "Get 200 Shurikins", points = 10,
//    id = 3101, badge = "03586", published = "02/10/2013 00:30:11", modified = "04/02/2014 12:51:53",
//    trigger = byte(0x0037CE) >= 0xC8
//)
//
//achievement(
//    title = "Infinite Shurikins", description = "Get 300 Shurikins", points = 15,
//    id = 3102, badge = "03587", published = "02/10/2013 00:30:14", modified = "04/02/2014 12:51:56",
//    trigger = word(0x0037CE) >= 0x012C
//)
//
//achievement(
//    title = "No need Shurikins", description = "Clear a stage without using shurikins", points = 10,
//    id = 3103, badge = "03589", published = "02/10/2013 00:30:18", modified = "06/07/2018 22:14:16",
//    trigger = byte(0x0037A7) > prev(byte(0x0037AD)) && word(0x0037EE) == 0x0300
//)
//
//achievement(
//    title = "Nice Score", description = "Get 50000 Score", points = 5,
//    id = 3104, badge = "03590", published = "02/10/2013 00:30:21", modified = "15/08/2014 02:21:33",
//    trigger = byte(0x0037B2) >= 0x05
//)
//
//achievement(
//    title = "Good Score", description = "Get 150000 Score", points = 10,
//    id = 3105, badge = "03591", published = "02/10/2013 00:30:24", modified = "15/08/2014 02:21:38",
//    trigger = byte(0x0037B2) >= 0x15
//)
//
//achievement(
//    title = "Awesome Score", description = "Get 300000 Score", points = 15,
//    id = 3106, badge = "03592", published = "02/10/2013 00:30:28", modified = "15/08/2014 02:21:41",
//    trigger = byte(0x0037B2) >= 0x2A
//)
//
//achievement(
//    title = "Power Ups 5X", description = "Get 5 power ups in sequence without being harmed", points = 0,
//    id = 61954, badge = "65245", published = "09/07/2018 01:24:39", modified = "09/07/2018 01:36:45",
//    trigger = byte(0x0000E6) == 0x01 && byte(0x000030) != 0x90 && repeated(5, byte(0x00F801) == 0x7D) && 
//              repeated(5, unless(prev(byte(0x00F801)) == 0x7D)) && never(byte(0x000030) == 0x00) && 
//              byte(0x00000A) != 0x52 && never(byte(0x0000E6) == 0x00)
//)
//
//achievement(
//    title = "Surfing is a Martial Art", description = "Defeat 4th boss using only your board", points = 0,
//    id = 61992, badge = "00000", published = "10/07/2018 04:12:23", modified = "10/07/2018 04:51:18",
//    trigger = byte(0x0037A7) > byte(0x0037AD) && byte(0x0037AD) == 0x03 && never(byte(0x0037AC) != 0x02) && 
//              repeated(3, byte(0x0041AE) > prev(byte(0x0041AE))) && repeated(40, byte(0x0041AE) < prev(byte(0x0041AE))) && 
//              never(byte(0x0037E7) < prev(byte(0x0037E7))) && never(byte(0x0037E2) < prev(byte(0x0037E2))) && 
//              never(byte(0x0037E8) == 0x00) && never(byte(0x00415A) == 0x3D) && never(byte(0x00415A) == 0x3F)
//)
