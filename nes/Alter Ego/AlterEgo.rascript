// Alter Ego
// #ID = 8170

//  1. Hello World (5)
//  2. Promenade (5)
//  3. Broken Bridge (5)
//  4. Phanton Pixels (5)
//  5. Another Phanton (5)
//  6. Skulls Lair (5)
//  7. Abracadabra (5)
//  8. Vertical Illusions (5)
//  9. Mirrors (5)
// 10. 16 Pixels (5)
// 11. Perfect Reflect (5)
// 12. Icelands (5)
// 13. Midnight (5)
// 14. Lonely Skull (5)
// 15. Made in Heaven (5)
// 16. Underwater (5)
// 17. Zupapixels (5)
// 18. Skullpedia (5)
// 19. After the War (5)
// 20. Virus Kvartirus (5)
// 21. Neverskull (5)
// 22. Old Tower (5)
// 23. Fake Wall (5)
// 24. Almost There (5)
// 25. Final Chamber (5)
// 26. Beat levels 1-5 without losing a life (10)
// 27. Beat levels 5-10 without losing a life (10)
// 28. Beat levels 11-15 without losing a life (10)
// 29. Beat levels 16-20 without losing a life (10)
// 30. Beat levels 21-25 without losing a life (10)
// 31. Beat the game without losing a life (25)


// ADDRESSES
// 0x06b8 - level
// 0x06b9 - level completed
// 0x06bb - lives
// 0x06bc - exchanges

function levelId() => byte(0x06b8)
function levelCompleted() => byte(0x06b9)
function lives() => byte(0x06bb)

function achievementLevelCompleted(level, name) {
    achievement(
        title = name,
        description = "Finished level " + level+1,
        points = 5,
        badge = "00136",
        trigger = levelId() == level && levelCompleted() == 1 && levelCompleted() > prev(levelCompleted())
    )
}

function achievement5LevelsNoDeath(level) {
    achievement(
        title = "Deathless " + (level+1)/5,
        description = "Beat levels " + level-3 + "-" + level+1 + " without losing a life",
        points = 10,
        badge = "00136",
        trigger = 
            once(levelId() == level-1) &&
            once(levelId() == level-2) &&
            once(levelId() == level-3) &&
            once(levelId() == level-4) &&
            never(lives() < prev(lives())) &&
            levelId() == level && levelCompleted() == 1 && levelCompleted() > prev(levelCompleted())
    )
}


achievementLevelCompleted(0, "Hello World")
achievementLevelCompleted(1, "Promenade")
achievementLevelCompleted(2, "Broken Bridge")
achievementLevelCompleted(3, "Phantom Pixels")
achievementLevelCompleted(4, "Another Phantom")
achievementLevelCompleted(5, "Skulls Lair")
achievementLevelCompleted(6, "Abracadabra")
achievementLevelCompleted(7, "Vertical Illusions")
achievementLevelCompleted(8, "Mirrors")
achievementLevelCompleted(9, "16 Pixels")
achievementLevelCompleted(10, "Perfect Reflect")
achievementLevelCompleted(11, "Icelands")
achievementLevelCompleted(12, "Midnight")
achievementLevelCompleted(13, "Lonely Skull")
achievementLevelCompleted(14, "Made in Heaven")
achievementLevelCompleted(15, "Underwater")
achievementLevelCompleted(16, "Zupapixels")
achievementLevelCompleted(17, "Skullpedia")
achievementLevelCompleted(18, "After the War")
achievementLevelCompleted(19, "Virus Kvartirus")
achievementLevelCompleted(20, "Neverskull")
achievementLevelCompleted(21, "Old Tower")
achievementLevelCompleted(22, "Fake Wall")
achievementLevelCompleted(23, "Almost There")
achievementLevelCompleted(24, "Final Chamber")

achievement5LevelsNoDeath(4)
achievement5LevelsNoDeath(9)
achievement5LevelsNoDeath(14)
achievement5LevelsNoDeath(19)
achievement5LevelsNoDeath(24)

// Beat the game without losing a life
achievement(
    title = "Multiple Personality",
    description = "Beat the game without losing a life",
    points = 25,
    badge = "00136",
    trigger = 
        once(levelId() == 0) && once(levelId() == 1) && once(levelId() == 2) &&
        once(levelId() == 3) && once(levelId() == 4) && once(levelId() == 5) &&
        once(levelId() == 6) && once(levelId() == 7) && once(levelId() == 8) &&
        once(levelId() == 9) && once(levelId() == 10) && once(levelId() == 11) &&
        once(levelId() == 12) && once(levelId() == 13) && once(levelId() == 14) &&
        once(levelId() == 15) && once(levelId() == 16) && once(levelId() == 17) &&
        once(levelId() == 18) && once(levelId() == 19) && once(levelId() == 20) &&
        once(levelId() == 21) && once(levelId() == 22) && once(levelId() == 23) &&
        never(lives() < prev(lives())) &&
        levelId() == 24 && levelCompleted() == 1 && levelCompleted() > prev(levelCompleted())
)
