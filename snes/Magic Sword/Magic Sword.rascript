// Magic Sword
// #ID = 1012


function inGame() => byte(0x0401) == 0
function floorSelectScreen() => byte(0x0401) == 4
function bonusScreen() => byte(0x0692) == 4

function difficulty() => byte(0x0409)
function levelId() => byte(0x0403)
function swordId() => byte(0x040a)
function shieldId() => byte(0x040b)
function partnerId() => byte(0x0424)
function partnerLevel() => byte(0x0412)
function itemId() => byte(0x0427)
function silverKeys() => byte(0x040f)
function goldKeys() => byte(0x0410)
function platinumKeys() => byte(0x0411)

function score10() => low4(0x0442)
function score10e2() => low4(0x0443)
function score10e3() => low4(0x0444)
function score10e4() => low4(0x0445)
function score10e5() => low4(0x0446)
function score10e6() => low4(0x0447)
function score10e7() => low4(0x0448)

function gameFinished(d) {
    difficulty() >= d
    && levelId() > 50
    && once(levelId() == 50)
    && levelId() > prev(levelId())
    && never(floorSelectScreen())
    && never(levelId() < prev(levelId()))
}


// GET SWORD ACHIEVEMENTS
// ---------------------------------------------------------------------------
function achievementGetSword(swordName, level) {
    if(swordName == "Falchion") sword = 1
    else if(swordName == "Samurai") sword = 2
    else if(swordName == "Broad") sword = 3
    else if(swordName == "Flame") sword = 4
    else if(swordName == "Great") sword = 5
    else if(swordName == "Thunder") sword = 6
    achievement(
        title = swordName + " Sword",
        description = "Get the " + swordName + " Sword in floor " + level,
        points = 5,
        trigger = inGame() && swordId() == sword && levelId() == level
    )
}

achievementGetSword("Falchion", 0)
achievementGetSword("Samurai", 4)
achievementGetSword("Broad", 12)
achievementGetSword("Flame", 24)
achievementGetSword("Great", 36)
achievementGetSword("Thunder", 43)
// ---------------------------------------------------------------------------


// GET SHIELD ACHIEVEMENTS
// ---------------------------------------------------------------------------
function achievementGetShield(shieldName) {
    if(shieldName == "Buckler") shield = 1
    else if(shieldName == "Kite") shield = 2
    else if(shieldName == "Steel Tower") shield = 3
    else if(shieldName == "Holy") shield = 4
    achievement(
        title = shieldName + " Shield",
        description = "Get the " + shieldName + " Shield",
        points = 5,
        trigger = inGame() && shieldId() == shield && prev(shieldId()) != shield
            && never(levelId() != prev(levelId()))
            && (
                once(score10() > prev(score10())) // got from a chest
                || once(silverKeys() < prev(silverKeys())) // got from a partner
                || once(goldKeys() < prev(goldKeys()))
                || once(platinumKeys() < prev(platinumKeys()))
            )
    )
}

achievementGetShield("Buckler")
achievementGetShield("Kite")
achievementGetShield("Steel Tower")
achievementGetShield("Holy")
// ---------------------------------------------------------------------------


// GET ITEMS
// ---------------------------------------------------------------------------
function achievementGetItem(itemName, itemDescription) {
    if(itemName == "Magic Potion") item = 6
    else if(itemName == "Scroll") item = 46
    else if(itemName == "Crystal Ball") item = 4
    else if(itemName == "Gauntlet") item = 56
    else if(itemName == "Diamond Ring") item = 32
    else if(itemName == "King's Crown") item = 80
    else if(itemName == "Golden Pot") item = 10
    else if(itemName == "Pendant") item = 8
    else if(itemName == "Power Stone") item = 88
    achievement(
        title = itemName,
        description = itemDescription,
        points = 2,
        trigger = inGame() && itemId() == item
    )
}

achievementGetItem("Magic Potion", "This Incriases Your Magic Power")
achievementGetItem("Scroll", "This Incriases Your Luck")
achievementGetItem("Crystal Ball", "This Reveals The Secret Treasures")
achievementGetItem("Gauntlet", "This Increases The Power of Your Partner")
achievementGetItem("Diamond Ring", "This Allows the LizardMan To Be Your Partner")
achievementGetItem("King's Crown", "This Gives You Magical Protection")
achievementGetItem("Golden Pot", "This Heals Your Partner")
achievementGetItem("Pendant", "This Doubles Your Score")
achievementGetItem("Power Stone", "This Boosts Attack, Defense and Magic")

// ---------------------------------------------------------------------------


// PARTNERS
// ---------------------------------------------------------------------------
function achievementGetPartner(partnerName) {
    pts = 5
    if(partnerName == "Amazon")
        partner = 0x03
    else if(partnerName == "Big Man")
        partner = 0x06
    else if(partnerName == "Wizard")
        partner = 0x09
    else if(partnerName == "Ninja")
        partner = 0x12
    else if(partnerName == "Thief")
        partner = 0x15
    else if(partnerName == "Priest")
        partner = 0x18
    else if(partnerName == "Knight") {
        partner = 0x0c
        pts = 10
    } else if(partnerName == "Lizard Man") {
        partner = 0x0f
        pts = 10
    }
    achievement(
        title = partnerName,
        description = "Have the " + partnerName + " as your partner",
        points = pts,
        trigger = inGame()
            && partnerId() == partner
            && prev(partnerId()) != partner
            && never(levelId() != prev(levelId()))
            && (
                once(silverKeys() < prev(silverKeys()))
                || once(goldKeys() < prev(goldKeys()))
                || once(platinumKeys() < prev(platinumKeys()))
            )
    )
}

achievementGetPartner("Amazon")
achievementGetPartner("Big Man")
achievementGetPartner("Wizard")
achievementGetPartner("Knight")
achievementGetPartner("Lizard Man")
achievementGetPartner("Ninja")
achievementGetPartner("Thief")
achievementGetPartner("Priest")

function achievementEvolvePartner(partnerName) {
    pts = 10
    if(partnerName == "Amazon")
        partner = 0x03
    else if(partnerName == "Big Man")
        partner = 0x06
    else if(partnerName == "Wizard")
        partner = 0x09
    else if(partnerName == "Ninja")
        partner = 0x12
    else if(partnerName == "Thief")
        partner = 0x15
    else if(partnerName == "Priest")
        partner = 0x18
    else if(partnerName == "Knight") {
        partner = 0x0c
        pts = 15
    } else if(partnerName == "Lizard Man") {
        partner = 0x0f
        pts = 15
    }
    achievement(
        title = "Max " + partnerName,
        description = "Max the " + partnerName + " to Level 8",
        points = pts,
        trigger = inGame()
            && partnerId() == partner
            && partnerLevel() == 7
            && prev(partnerLevel() == 6)
    )
}
    
achievementEvolvePartner("Amazon")
achievementEvolvePartner("Big Man")
achievementEvolvePartner("Wizard")
achievementEvolvePartner("Knight")
achievementEvolvePartner("Lizard Man")
achievementEvolvePartner("Ninja")
achievementEvolvePartner("Thief")
achievementEvolvePartner("Priest")
// ---------------------------------------------------------------------------

// BOSSES
// ---------------------------------------------------------------------------
function achievementDefeatBoss(bossName, bossDescription, level, pts) {
    achievement(
        title = "Slay the " + bossName,
        description = bossDescription + " (>= Normal)",
        points = pts,
        trigger = 
            difficulty() >= 1
            && levelId() == level+1
            && once(levelId() == level) 
            && levelId() > prev(levelId())
            && never(floorSelectScreen())
            && never(levelId() < prev(levelId()))
    )
}

achievementDefeatBoss("Quimyra", "Wasn't it supposed to be Chimera?", 0, 5)
achievementDefeatBoss("Gold Dragon", "He didn't put an end to your little adventure", 4, 10)
achievementDefeatBoss("Skull Chimera", "He is not bored anymore because he is dead", 12, 10)
achievementDefeatBoss("Celestial Serpents", "They aren't Hungry anymore because they're dead", 24, 10)
achievementDefeatBoss("Hydra", "Still Shakin but at Least the Dragon is dead", 36, 10)
achievementDefeatBoss("Queen Chimera", "The Queen of Palette Swaps", 49, 10)

achievement(
    title = "Slay the Drokmar",
    description = "The King of Shadow is no more! (>= Normal)",
    points = 15,
    trigger = gameFinished(1)
)
// ---------------------------------------------------------------------------

// FINISH THE GAME
// ---------------------------------------------------------------------------
achievement(
    title = "The New Dark Lord",
    description = "Finish the Game with the Bad Ending (>= Normal)",
    points = 25,
    trigger = gameFinished(1) && levelId() == 53
)

achievement(
    title = "The Lonely Dark Lord",
    description = "Finish the Game with the Bad Ending and without a Partner(>= Normal)",
    points = 25,
    trigger = gameFinished(1) && levelId() == 53 && partnerId() == 0
)

achievement(
    title = "The Brave One",
    description = "Finish the Game with the Good Ending (>= Normal)",
    points = 25,
    trigger = gameFinished(1) && levelId() == 51
)

achievement(
    title = "The Legendary One",
    description = "Finish the Game with the Good Ending and with the First Sword (>= Normal)",
    points = 25,
    trigger = gameFinished(1) && levelId() == 51 && swordId() == 0
)

achievement(
    title = "Marathonist",
    description = "Finish the Game starting from the Beginning",
    points = 25,
    trigger = once(levelId() == 0)
        && once(levelId() == 1)
        && once(levelId() == 2)
        && once(levelId() == 4)
        && once(levelId() == 6)
        && once(levelId() == 7)
        && once(levelId() == 8)
        && once(levelId() == 10)
        && once(levelId() == 12)
        && once(levelId() == 14)
        && once(levelId() == 15)
        && once(levelId() == 17)
        && once(levelId() == 18)
        && once(levelId() == 21)
        && once(levelId() == 22)
        && once(levelId() == 23)
        && once(levelId() == 25)
        && once(levelId() == 27)
        && once(levelId() == 28)
        && once(levelId() == 29)
        && once(levelId() == 31)
        && once(levelId() == 32)
        && once(levelId() == 34)
        && once(levelId() == 35)
        && once(levelId() == 39)
        && once(levelId() == 40)
        && once(levelId() == 41)
        && once(levelId() == 42)
        && once(levelId() == 46)
        && once(levelId() == 47)
        && once(levelId() == 48)
        && once(levelId() == 49)
        && gameFinished(0)
)
// ---------------------------------------------------------------------------


// SECRET DOORS
// ---------------------------------------------------------------------------
function achievementSecretDoor(secret, fromLevel, toLevel) {
    achievement(
        title = "Secret Door " + secret,
        description = "Find the Secret Door on Floor " + fromLevel + " and enter it",
        points = 5,
        trigger = inGame() && levelId() == toLevel-1 && prev(levelId() == fromLevel)
    )
}

achievementSecretDoor(1, 1, 4)
achievementSecretDoor(2, 7, 11)
achievementSecretDoor(3, 14, 19)
achievementSecretDoor(4, 17, 20)
achievementSecretDoor(5, 34, 36)
achievementSecretDoor(6, 39, 42)
// ---------------------------------------------------------------------------


// OTHER CHEEVOS
// ---------------------------------------------------------------------------
achievement(
    title = "The Number of the Beast",
    description = "Get exactly 6 of each key",
    points = 10,
    trigger = silverKeys() == 6 && goldKeys() == 6 && platinumKeys() == 6
)

achievement(
    title = "Just Like the Cover",
    description = "Get to Floor 50 with an Level 8 Amazon as your Partner (>= Normal)",
    points = 25,
    trigger = 
        difficulty() >= 1
        && levelId() == 50
        && once(levelId() == 49) 
        && levelId() > prev(levelId())
        && never(floorSelectScreen())
        && never(levelId() < prev(levelId()))
        && partnerId() == 3
        && partnerLevel() == 7
)

achievement(
    title = "Top Score",
    description = "Beat the Top Score",
    points = 10,
    trigger = inGame() && score10e5() == 5
)
// ---------------------------------------------------------------------------
