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

// $37E7: Ninjutsu amount
function ninjitsuAmount() => byte(0x37e7)

// $4156: (lower4) 2 = using fushin ninjitsu (high jump)
function usingFushinJitsu() => low4(0x4156) == 2

// $415E: (16bit) non-zero = using ikazuchi ninjitsu (normally start with 4 and decreases as you got hit)
function usingIkazuchiJitsu() => word(0x415e) > 0

// $37E8: Health
//        full = 10
//        dead = 00
function health() => byte(0x37e8)

function noDamage() => never(health() < prev(health()))
    && never(move() == 0x28)
    && never(move() == 0x3a)


// $37E6: Ninjutsu selected
//        0x00=Jitsu of Ikazuchi
//        0x01=Jitsu of Kariu
//        0x02=Jitsu of Fushin
//        0x03=Jitsu of Mijin
// $37EE: (16bit) Shinobi Bonus = 0300
//        in the Round Clear Stage
// $3D2A: X - area

// $37EC: Bonuses (1 means no bonus)
//        bit0 = no shurikin (shinobi)
//        bit1 = no ninjitsu
//        bit2 = damage
//        on Round Clear screen 08 means perfect bonus
function shinobiBonus() => never(bit0(0x37ec) == 1)
function noShurikin() => shinobiBonus()
function noNinjitsuBonus() => never(bit1(0x37ec) == 1)
function noNinjitsu() => noNinjitsuBonus()
function technicalBonus() => never(bit2(0x37ec) == 1) // whole stage damageless
function perfectBonus() => byte(0x37ec) == 0x08

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
//        3a = damage surfing
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
function bgPosY() => word(0xe004)


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
  pts = 4
  requirements = 
      once(completeRound() == (round - 1) * 256)
      && once(completeRound() == (round - 1) * 256 + 1)
      && completeRound() == (round - 1) * 256 + 2
      && roundClear()
      && noCheats()
      
  if(round == 1){
      pts = pts - 1
  } else if(round == 7) {
      desc = desc +" and beat the game"
      pts = pts + 4
      requirements = requirements && bossHealth[round] > 0xf0
  } else {
      requirements = requirements && bossHealth[round] == 0
  }

  
  if(noJitsu == true) {
      name = "Nojitsu "+ round
      desc = desc +" without using Ninjitsu"
      pts = pts + 4
      requirements = requirements && noNinjitsu()
  }
  
  achievement(
    title = name,
    description = desc,
    points = pts,
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
    points = 16,
    trigger = allRounds
      && noCheats()
      && noNinjitsu()
)

achievement(
    title = "Shinobi",
    description = "Beat the game on expert without using continues",
    points = 25,
    trigger = allRounds
      && noCheats()
      && expertMode()
      && noContinues()
)


// 9 LIVES (EXPERT)
// ============================================================================

achievement(
    title = "Never die",
    description = "Get 9 lives (expert mode)",
    points = 15,
    trigger =
      lives() >= 9
      && repeated(7, lives() > prev(lives()))
      && expertMode()
)


// collect shurikins
// ============================================================================

function collectShurikins(amount) {
    name = {
        100: "Newbie",
        200: "More",
        300: "Infinite"
    }
    pts = {
        100: 2,
        200: 5,
        300: 10
    }
    shurikinAmountCondition = defShurikins() == defShurikinsAmount[0] && shurikins() >= amount

    for defAmount in range(10, 70, 10) {
        shurikinAmountCondition = shurikinAmountCondition
            || defShurikins() == defShurikinsAmount[defAmount] && shurikins() >= defAmount + amount
    }

    achievement(
        title = name[amount] +" Shurikins",
        description = "Collect "+ amount +" shurikins plus the default amount",
        points = pts[amount],
        trigger =
          noCheats()
          && repeated(amount/20, shurikins() > prev(shurikins()))
          && ( shurikinAmountCondition )
    )
}

collectShurikins(100)
collectShurikins(200)
collectShurikins(300)


// HI SCORES
// ============================================================================
function hiScore(score) {
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
    pts = {
        50 : 2,
        150: 5,
        300: 10        
    }
    achievement(
        title = adjective[score] +" Score",
        description = "Get "+ score +"k score (>= Normal)",
        points = pts[score],
        trigger = normalOrAbove()
            && score10e4() >= value[score]
            && repeated(score/5, score10e4() > prev(score10e4()))
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
        2: "Cowboy Ninja",
        3: "The Floor is Lava",
        4: "Surfing is a Martial Art",
        5: "Drop Your Weapons",
        6: "I Believe I Can Fly"
    }
    desc = {
        1: "no jump, damage, shurikins nor ninjitsu",
        2: "no damage nor ninjitsu",
        3: "don't touch the floor, no damage nor ninjitsu",
        4: "using only your surfboard (ninjitsu allowed)",
        5: "using only the drop kick move, no damage nor ninjitsu",
        6: "no damage nor ninjitsu"
    }
    roundID = {
        1: 0x0000,
        2: 0x0100,
        3: 0x0200,
        4: 0x0300,
        5: 0x0400,
        6: 0x0500
    }
    pts = 10
    conditions = never(completeRound() != roundID[round])
    if(round == 1) {
        pts = 5
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
        points = pts,
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


bossHP = {
    1: boss1HP(),
    2: boss2HP(),
    3: boss3HP(),
    4: boss4HP(),
    5: boss5HP(),
    6: boss6HP(),
    7: boss7HP()
}
bossName = {
    1: "Samurai Lord",
    2: "Master Brain",
    3: "Body Weapons",
    4: "Jet",
    5: "Mecha Godzilla",
    6: "Zeed",
    7: "Grand Master"
}
roundID = {
    1: 0x0002,
    2: 0x0102,
    3: 0x0202,
    4: 0x0302,
    5: 0x0402,
    6: 0x0502,
    7: 0x0602
}

for round in range(1, 7) {
    bossStart = once(bossHP[round] > prev(bossHP[round]))
    constraints = noDamage() && noCheats() && noNinjitsu()
    desc = "Beat "+ bossName[round] +" without taking damage, no ninjitsu"
    pts = 15

    
    if(round == 1) { // no shurikins on first boss
        pts = 10
        constraints = constraints && noShurikin()
        desc = desc +" nor shurikin"
    }
    else if(round == 4) {
        bossStart = repeated(3, bossStart)
    }
    else if(round == 6) {
        bossStart = repeated(2, bossStart)
    }
    else if(round == 7) {
        pts = 25
        bossStart = repeated(4, bossStart)
    }

    bossFinish = music() != roundClear()

    achievement(
        title = bossName[round],
        description = desc,
        points = pts,
        trigger =  never(completeRound() != roundID[round])
            && bossStart
            && constraints
            && bossFinish
    )
}



// SECRET SPOTS
// ============================================================================

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


// SPECIAL BONUSES
// ============================================================================

conditions = noCheats()
    && once(subRound() == 0)
    && once(subRound() == 1)
    && subRound() == 2
    && never(subRound() < prev(subRound()))
    && roundClear()

// shinobi bonus (don't use a shurikin)
achievement(
    title = "Shinobi Bonus",
    description = "Finish a stage without using shurikins",
    points = 10,
    trigger = conditions
        && shinobiBonus()
)

// damageless bonus
achievement(
    title = "Technical Bonus",
    description = "Finish a stage without taking damage",
    points = 15,
    trigger = conditions
        && technicalBonus()
)

// perfect bonus: no damage, no shurikins, no ninjitsu
achievement(
    title = "Perfect Bonus",
    description = "Finish a stage without taking damage nor using shurikins nor ninjitsu",
    points = 20,
    trigger = conditions
        && perfectBonus()
)
