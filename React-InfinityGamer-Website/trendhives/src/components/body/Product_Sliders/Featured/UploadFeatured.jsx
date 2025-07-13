// UploadFeatured.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../../firebase/';

const Featured = [
    {
        "id": 1,
        "title": "God of War dummy",
        "description": "Kratos and son journey through Norse realms.",
        "About": "Embark on an epic and visceral journey as Kratos, a hardened warrior, and his son Atreus navigate the brutal and beautiful realms of Norse mythology. Years after his vengeance against the Olympian gods, Kratos now lives in the world of Norse gods and monsters. He must learn to control his rage and, more importantly, teach his son, Atreus, how to survive in this dangerous world. Their journey is one of discovery, of family bonds, and of facing the consequences of Kratos' past actions.\n\nThe game features a dynamic blend of action and storytelling. Players will wield Kratos' signature weapons, including his iconic Blades of Chaos and the Leviathan Axe, battling formidable foes in intense and strategic combat encounters. Explore stunning environments, from the frozen wastes of Midgard to the fiery realm of Muspelheim, each location filled with hidden secrets and opportunities for exploration. The relationship between Kratos and Atreus is central to the game, with their interactions shaping the narrative and offering moments of both vulnerability and strength.\n\nAs Kratos and Atreus venture deeper into the Norse world, they'll encounter a host of memorable characters, both friend and foe. They face off against mythical creatures and powerful gods. These encounters enrich the narrative and allow players to experience the lore, mythology, and complex relationships that define this world. Players will be able to upgrade Kratos' combat style and the weapons he uses through an in-depth system. Solving puzzles, completing side quests, and uncovering hidden lore provide a rewarding and immersive gaming experience.\n\nGod of War is more than just a game; it's a cinematic masterpiece that offers a captivating story, stunning visuals, and an engaging gameplay experience. The game masterfully blends brutal action with emotional depth, creating an unforgettable adventure that will resonate with players long after the credits roll. Prepare yourself to face gods, monsters, and the trials of fatherhood in this unforgettable journey filled with exploration, discovery, and personal growth.",
        "productspecification": {
            "platform": "PlayStation 5",
            "genre": "Action-Adventure",
            "developer": "Santa Monica Studio",
            "publisher": "Sony Interactive Entertainment",
            "releaseDate": "November 9, 2022",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545015/SZRc7OMwGgv8lJXIOlYyuBU2_zjzob5.avif",
        "price": "₹3999"
    },
    {
        "id": 2,
        "title": "Spider-Man 2",
        "description": "Swing through New York as Spidey.",
        "About": "Step into the webs of Peter Parker and Miles Morales as they face new challenges and threats in the bustling city of New York. Players experience the thrill of web-slinging through iconic landmarks, from towering skyscrapers to the vibrant neighborhoods, all rendered with stunning realism. The game builds on its predecessor, delivering a thrilling adventure filled with exciting missions, formidable villains, and a deeper exploration of both Spider-Men's personal lives and responsibilities.\n\nThe gameplay experience is enhanced by the ability to switch between Peter and Miles, each with their own unique abilities, gadgets, and combat styles. You will encounter both familiar faces and new threats. Players can explore new gadgets, master powerful combat moves, and face off against iconic Spider-Man adversaries, most notably the terrifying Venom. The game's narrative delves into the personal lives of both Spider-Men. The story explores the challenges they face, both individually and as a team.\n\nWith its enhanced graphics, fluid traversal, and fast-paced combat, Spider-Man 2 offers a compelling and immersive experience for both fans of the series and newcomers. Explore a vast and dynamic open world filled with side activities, collectibles, and challenges to keep players engaged. The dynamic weather system and improved movement mechanics add to the immersion of the world.\n\nPrepare for a gripping narrative, thrilling combat, and breathtaking visuals. The game transports you into the world of Spider-Man, with its ability to switch between Peter Parker and Miles Morales. Whether battling iconic villains or saving civilians from danger, Spider-Man 2 provides an unforgettable experience, delivering a memorable superhero adventure. Experience the story of friendship, heroism, and the never-ending responsibility of protecting the city.",
        "productspecification": {
            "platform": "PlayStation 5",
            "genre": "Action-Adventure",
            "developer": "Insomniac Games",
            "publisher": "Sony Interactive Entertainment",
            "releaseDate": "October 20, 2023",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545014/spiderman2_yw2avq.jpg",
        "price": "₹2999"
    },
    {
        "id": 3,
        "title": "Ghost of Tsushima",
        "description": "Samurai action in feudal Japan.",
        "About": "Embark on a visually stunning and emotionally resonant journey through the war-torn landscapes of 13th-century Japan in Ghost of Tsushima. Assume the role of Jin Sakai, a samurai warrior who must abandon his traditions and embrace the ways of the Ghost to protect his homeland from the invading Mongol forces. This game blends historical fiction with compelling character development and breathtaking visuals to create a unique and immersive gaming experience.\n\nExplore a vast and dynamic open world, from windswept fields to dense forests, all meticulously crafted to capture the beauty and brutality of feudal Japan. The gameplay features thrilling sword combat. Players can master the katana and adapting to different fighting styles to overcome enemies. Unleash devastating special moves and utilize stealth tactics to outmaneuver opponents. The game offers a diverse array of weapons, skills, and armor. Customizing your approach to combat and exploration.\n\nExperience a compelling narrative that delves into Jin's internal conflict as he grapples with his duty to his clan and the moral implications of his actions. Encounter memorable characters. Both allies and enemies will intertwine with Jin's journey, driving the story forward. Discover a rich and historically accurate world, filled with side quests, secrets, and opportunities for exploration, allowing players to fully immerse themselves in the feudal Japanese setting.\n\nWith its captivating storyline, breathtaking visuals, and engaging gameplay, Ghost of Tsushima invites you to step into the shoes of a samurai. Forge your destiny in a world on the brink of war. Experience honor, betrayal, and the struggle to survive in a beautiful yet dangerous world, embodying the spirit of the samurai and what it means to be a hero. Prepare to fight, explore, and immerse yourself in a tale of sacrifice, loyalty, and the enduring spirit of the samurai and what it means to be a hero.",
        "productspecification": {
            "platform": "PlayStation 5",
            "genre": "Action-Adventure",
            "developer": "Sucker Punch Productions",
            "publisher": "Sony Interactive Entertainment",
            "releaseDate": "July 17, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545012/ghost_of_tsushima_iabprx.avif",
        "price": "₹3999"
    },
    {
        "id": 4,
        "title": "Sekiro",
        "description": "Intense samurai combat with stealth elements.",
        "About": "Immerse yourself in a dark and captivating world as the 'One-Armed Wolf' in Sekiro. A disgraced warrior is tasked with protecting a young divine heir. The game is set in a stylized, Sengoku-era Japan. Sekiro offers a unique blend of intense combat, stealth mechanics, and environmental exploration. It places a strong emphasis on precision, timing, and strategic decision-making.\n\nPrepare for challenging combat encounters. Skillful use of your katana, grappling hook, and prosthetic arm is required. Master the art of parrying, deflecting, and exploiting enemy weaknesses to overcome formidable foes. The game rewards patience and careful observation. You must learn enemy attack patterns and adapt your strategies accordingly. The game also encourages stealth. Sneaking through environments, eliminating enemies silently, and gaining the upper hand in combat is vital to your survival.\n\nExplore a visually stunning and detailed world. It includes sprawling castles to hidden temples, each environment providing unique challenges and opportunities. The game also features a gripping narrative. It is filled with intrigue, betrayal, and the struggle for survival. Unravel the mysteries of your past and the divine heir's fate as you journey through this perilous land. The prosthetic arm provides players with access to various tools that can shift the tide of battle.\n\nSekiro offers a demanding and rewarding experience. Your skills and resolve will be tested. It's not just a combat game. It is a test of your ability to learn, adapt, and overcome adversity. Get ready to face tough fights, explore the world, and discover the secrets of the past as you strive to reclaim your honor and protect the divine heir. Sekiro is a masterclass in both action and game design, offering a unique and challenging experience.",
        "productspecification": {
            "platform": "PlayStation 4, Xbox One, PC",
            "genre": "Action-Adventure",
            "developer": "FromSoftware",
            "publisher": "Activision",
            "releaseDate": "March 22, 2019",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545002/1146370_wntkxm.jpg",
        "price": "₹4999"
    },
    {
        "id": 5,
        "title": "Resident Evil 4",
        "description": "Classic horror, beautifully reimagined.",
        "About": "Step back into the nightmare as Leon S. Kennedy in this stunning reimagining of the iconic Resident Evil 4. The game takes the familiar survival horror formula and elevates it with enhanced visuals, updated gameplay mechanics, and a reimagined storyline. Your mission is to rescue the president's daughter, Ashley Graham, from a sinister cult in rural Spain. This new take on the classic offers an unparalleled level of detail and intensity.\n\nBattle hordes of infected villagers, known as Ganados. You'll use a variety of weapons and strategic thinking to conserve resources. The environment plays a vital role; you'll need to use your surroundings to your advantage, utilizing cover and traps to survive the relentless onslaught. The game's combat is more dynamic and engaging than ever, allowing for precise aiming, melee attacks, and environmental interactions. Players are encouraged to think on their feet.\n\nAs you traverse the unsettling villages, ominous castles, and other eerie locations, you'll encounter a cast of memorable characters, both friends and foes. These characters test your resolve and guide you through the unfolding story. The game expands on the original narrative with new plot elements and character development, delving deeper into the mysteries and conspiracies that plague the world. Prepare to face terrifying boss battles that will test your skill and resilience.\n\nResident Evil 4 is a must-play for fans of survival horror and newcomers alike. The game offers a thrilling and terrifying experience that will keep you on the edge of your seat. Face the horrors, rescue Ashley, and uncover the truth behind the sinister plot in this reimagined classic. Experience the story of survival and the pursuit of justice in this horror masterpiece.",
        "productspecification": {
            "platform": "PlayStation 5, Xbox Series X/S, PC",
            "genre": "Survival Horror",
            "developer": "Capcom",
            "publisher": "Capcom",
            "releaseDate": "March 24, 2023",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545012/resident_evil4_ibjw60.avif",
        "price": "₹5999"
    },
    {
        "id": 6,
        "title": "Halo Infinite",
        "description": "Master Chief battles enemies on Zeta Halo.",
        "About": "Step back into the MJOLNIR armor and embark on a thrilling new chapter in the legendary Halo saga. Halo Infinite delivers a sprawling open-world experience where the Master Chief must fight against the forces of the Banished on the fractured Zeta Halo ring. The game introduces new gameplay mechanics and a compelling narrative while staying true to the series' roots. Experience the vastness of the Halo universe.\n\nExplore the vast and dynamic landscapes of Zeta Halo, filled with secrets, challenges, and opportunities for exploration. Engage in intense firefights against the Banished. You can utilize a variety of weapons, vehicles, and gadgets, including the new grappling hook. The grappling hook adds a new layer of tactical combat. The game offers a robust campaign mode, filled with memorable characters, gripping story moments, and epic battles that push the limits of the universe.\n\nBeyond the campaign, Halo Infinite features a comprehensive multiplayer mode. It brings back the classic Halo action with new modes, maps, and customization options. Team up with friends or compete against other players in fast-paced matches. The game also introduces a new sandbox where players can create custom maps and modes. The multiplayer mode has also implemented a battle pass system, allowing players to customize their character and earn rewards.\n\nHalo Infinite combines a compelling single-player experience with a robust multiplayer mode. It offers something for both new players and veterans. Get ready to fight, explore, and battle your way through Zeta Halo in this epic addition to the Halo universe. It offers an unparalleled amount of action and a story to match. Experience the next chapter of the iconic saga.",
        "productspecification": {
            "platform": "Xbox Series X/S, Xbox One, PC",
            "genre": "First-Person Shooter",
            "developer": "343 Industries",
            "publisher": "Xbox Game Studios",
            "releaseDate": "December 8, 2021",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545005/capsule_616x353_pdtunw.jpg",
        "price": "₹6999"
    },
    {
        "id": 7,
        "title": "Grand Theft Auto V",
        "description": "Three criminals' stories intertwine in Los Santos.",
        "About": "Experience the sprawling open world of Los Santos and Blaine County in this epic action-adventure game. Grand Theft Auto V tells the interconnected stories of three criminals—Michael, Trevor, and Franklin—as they navigate a world of crime, corruption, and high-stakes heists. The game allows you to seamlessly switch between the three main characters, experiencing the story from different perspectives. Immerse yourself in the lives of each individual, exploring their unique backgrounds and motivations.\n\nExplore a massive and detailed open world. It is filled with diverse environments, from the sun-drenched beaches to the towering skyscrapers of the city. Engage in a wide array of activities, from completing story missions to participating in side quests, heists, and mini-games. The game also features a robust online multiplayer mode. It allows players to team up with friends to complete missions, compete in races, and cause mayhem in Los Santos.\n\nThe game's narrative explores themes of ambition, betrayal, and the dark underbelly of society. It offers a compelling story with memorable characters, moral ambiguity, and thrilling plot twists. With its enhanced graphics, improved gameplay mechanics, and a vast amount of content, Grand Theft Auto V provides an immersive experience that is both engaging and entertaining. The world is so vast with lots of customization options. You're offered the freedom to do whatever you want, making it a truly unique experience.\n\nWith its immersive open world, engaging story, and diverse gameplay, Grand Theft Auto V is a must-play for fans of action-adventure games. Dive into the world of Los Santos, live the life of a criminal, and experience an unforgettable journey of heists, mayhem, and thrilling adventures. The game delivers a world of chaos and crime with an unparalleled level of detail. Experience a world where anything can happen.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC",
            "genre": "Action-Adventure",
            "developer": "Rockstar North",
            "publisher": "Rockstar Games",
            "releaseDate": "September 17, 2013",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545011/GTAV_EGS_Artwork_2560x1440_Landscaped_Store-2560x1440-79155f950f32c9790073feaccae570fb_q0cnto.jpg",
        "price": "₹799"
    },
    {
        "id": 8,
        "title": "Hogwarts Legacy",
        "description": "Open-world adventure in the Wizarding World.",
        "About": "Embark on a magical journey through the enchanting world of Hogwarts in this open-world RPG. The game is set in the late 1800s. Create your own character, attend classes, and discover a vast world filled with magic, mystery, and adventure. Experience the iconic Hogwarts School of Witchcraft and Wizardry like never before. Explore its hallowed halls, secret passages, and the surrounding areas and expand your knowledge.\n\nLearn spells, brew potions, and master a variety of magical skills as you progress through your classes. Uncover ancient secrets and confront dangerous creatures as you explore the Forbidden Forest, Hogsmeade, and the vast open world. Form friendships with fellow students and make choices that will shape your character's destiny. The game encourages player choice, allowing you to shape your story within the world, developing your character and skills. \n\nCustomize your character's appearance, choose your Hogwarts house, and develop your magical abilities to suit your playstyle. Engage in challenging combat encounters. You utilize a variety of spells and abilities to defeat enemies and solve puzzles. Discover hidden secrets, complete side quests, and unravel the mysteries of the wizarding world. The game allows for endless customization.\n\nHogwarts Legacy is the ultimate experience for any fan of the Wizarding World, allowing players to live out their dreams of attending Hogwarts. Dive into a world filled with magic, adventure, and endless possibilities. Experience the magic and create your own legacy. Become the wizard or witch you have always wanted to be.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "Action RPG",
            "developer": "Avalanche Software",
            "publisher": "Warner Bros. Games",
            "releaseDate": "February 10, 2023",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545011/Hogwarts_Legacy_c6bduu.jpg",
        "price": "₹999"
    },
    {
        "id": 9,
        "title": "Dark Souls 3",
        "description": "Brutal and rewarding action RPG.",
        "About": "Prepare to die—again—in the unforgiving world of Dark Souls 3, a challenging action RPG that will test your skills, patience, and resolve. Set in a dark fantasy world. The game offers a unique blend of strategic combat, intricate level design, and a deeply rewarding sense of accomplishment. Face off against formidable bosses, explore a world of ancient ruins, and uncover a captivating story filled with mystery and despair.\n\nMaster a challenging combat system that demands precision, timing, and strategic decision-making. Experiment with a variety of weapons, armor, and magic spells to find the perfect playstyle. The game emphasizes player choice, allowing you to customize your character and build based on your preferences. Explore a world of interconnected levels, filled with hidden secrets, treacherous traps, and deadly enemies. The game also allows you to use co-op mode.\n\nEncounter memorable characters, learn about the lore, and uncover the mysteries of the fading world. Dark Souls 3 encourages exploration, rewarding players who delve into every nook and cranny. The game is known for its high difficulty. It also offers a deeply satisfying experience for those willing to persevere. You will have to use skill to overcome challenges.\n\nDark Souls 3 delivers an epic and challenging adventure that will push you to your limits. Are you ready to face the darkness, battle fearsome foes, and uncover the secrets of the First Flame? Dive into a world of shadows, where death is a lesson and every victory is earned. The game delivers a powerful experience with a large amount of content. It is one of the hardest games available.",
        "productspecification": {
            "platform": "PlayStation 4, Xbox One, PC",
            "genre": "Action RPG",
            "developer": "FromSoftware",
            "publisher": "Bandai Namco Entertainment",
            "releaseDate": "March 24, 2016",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545006/Dark_Souls_bhch9f.avif",
        "price": "₹999"
    },
    {
        "id": 10,
        "title": "Metal Gear Solid V",
        "description": "Tactical stealth action in an open world.",
        "About": "Step into the boots of the legendary Big Boss in Metal Gear Solid V: The Phantom Pain, a tactical stealth action game set in a vast open world. Set in the 1980s, the game takes place across the globe. You go from war-torn Afghanistan to the jungles of Africa. It offers unparalleled freedom and a unique blend of stealth, strategy, and action.\n\nExperience a revolutionary open-world gameplay. It lets you approach missions in various ways. Use stealth tactics, strategic planning, and a wide range of weapons and gadgets to overcome your enemies. Recruit soldiers, build your Mother Base, and manage your resources to prepare for challenging missions. You have a great amount of customization. Choose your approach, whether you prefer stealth, direct assault, or a combination of both.\n\nUnravel a gripping narrative that delves into the dark underbelly of war and the cost of vengeance. Encounter memorable characters and face difficult choices as you navigate complex moral landscapes. Metal Gear Solid V focuses on providing an immersive gameplay experience. It puts a strong emphasis on replayability. The game encourages player choice and offers numerous possibilities, each decision having a lasting impact on the story.\n\nMetal Gear Solid V: The Phantom Pain is a cinematic masterpiece. Prepare for a tactical stealth action experience that is unparalleled. Experience the thrill of building your army, taking down enemy bases, and uncovering a compelling narrative that will keep you engaged. The game provides a powerful experience. Engage in tactical gameplay and master the art of espionage in the open world, offering a unique blend of stealth, strategy, and action.",
        "productspecification": {
            "platform": "PlayStation 4, PlayStation 3, Xbox One, Xbox 360, PC",
            "genre": "Stealth Action",
            "developer": "Kojima Productions",
            "publisher": "Konami",
            "releaseDate": "September 1, 2015",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545006/133971_bpqwxt.jpg",
        "price": "₹1999"
    },
    {
        "id": 11,
        "title": "Elden Ring",
        "description": "Open-world RPG with challenging combat.",
        "About": "Embark on an epic journey through the Lands Between in Elden Ring, a vast open-world RPG crafted by FromSoftware and George R.R. Martin. Explore a sprawling world filled with ancient mysteries, perilous dungeons, and challenging combat encounters. Create your own character, choose your path, and confront the shattered fragments of the Elden Ring to become the Elden Lord.\n\nTraverse the vast open world on foot or on horseback, discovering hidden locations, meeting memorable characters, and facing off against fearsome foes. Master a challenging combat system that demands precision, timing, and strategic thinking. Experiment with a variety of weapons, spells, and abilities to tailor your playstyle. You will need skill to overcome the obstacles and face powerful bosses.\n\nUnravel a captivating narrative filled with lore and mystery. As you uncover the secrets of the Lands Between and the shattered Elden Ring, you will make your own choices and shape your destiny in a world where every decision has consequences. Experience a world filled with intricate detail, stunning visuals, and a gripping atmosphere. The game’s atmosphere is truly one of a kind.\n\nElden Ring is an unparalleled experience that will test your skills, reward your curiosity, and captivate your imagination. Embrace the challenge and step into a world of adventure. Every encounter is a test of your skills, and every victory is hard-earned. Prepare to battle, explore, and discover the secrets of the Elden Ring and fight to survive in this dangerous world.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC",
            "genre": "Action RPG",
            "developer": "FromSoftware",
            "publisher": "Bandai Namco Entertainment",
            "releaseDate": "February 25, 2022",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547322/11_nq6nxe.png",
        "price": "₹1999"
    },
    {
        "id": 12,
        "title": "Cyberpunk 2077",
        "description": "Futuristic RPG in Night City.",
        "About": "Step into the neon-lit, dystopian metropolis of Night City in Cyberpunk 2077. It is an open-world RPG from the creators of The Witcher 3: Wild Hunt. Create your own character, known as V. Embark on a journey of self-discovery and survival in a world of corporate power, technological enhancement, and dangerous gangs. The game combines action, role-playing, and a gripping narrative to create a truly unique experience.\n\nExplore a massive and detailed open world, filled with diverse districts, towering skyscrapers, and the gritty underbelly of Night City. Engage in thrilling combat encounters. You can utilize a variety of weapons, cybernetic enhancements, and hacking abilities. The expansive character customization system allows you to tailor V's appearance, skills, and playstyle to your liking. You can choose how you wish to play.\n\nUnravel a complex narrative, filled with intrigue, betrayal, and difficult choices. Forge relationships with memorable characters. The decisions that you make in the game shape your destiny. Experience the world of the future, where technology is both a tool and a weapon. The lines between humanity and machine blur and everything is brought to life.\n\nCyberpunk 2077 invites you to immerse yourself in the vibrant and dangerous world of Night City. Get ready to battle, explore, and uncover the secrets of a world on the brink of change. Prepare to face the darkness, confront your demons, and live life on the edge, becoming a true cyberpunk. You will experience a futuristic world with intense combat.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Stadia",
            "genre": "Action RPG",
            "developer": "CD Projekt Red",
            "publisher": "CD Projekt",
            "releaseDate": "December 10, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545006/cyberpunk_2077_wuxxub.jpg",
        "price": "₹1999"
    },
    {
        "id": 13,
        "title": "Red Dead Redemption 2",
        "description": "Experience Arthur Morgan’s Wild West journey.",
        "About": "Step into the boots of Arthur Morgan, a member of the Van der Linde gang. Red Dead Redemption 2 is a sprawling open-world action-adventure game. It is set in a meticulously crafted Wild West. Experience the beauty and danger of a world on the cusp of change. The gang struggles to survive in a time of lawlessness and industrialization. Experience the story of the outlaw life. The story will stay with you long after the credits roll.\n\nExplore a vast and dynamic open world. It is filled with diverse environments, from snow-capped mountains to swampy bayous. Engage in a variety of activities, from completing story missions to hunting, fishing, and participating in side quests. The game features a deep and engaging narrative. It has memorable characters and a captivating story of loyalty, betrayal, and survival. Ride your horse through the countryside and encounter other people, both friend and foe.\n\nExperience a historically accurate and immersive world, filled with intricate details and authentic period elements. The game features a robust combat system, with a vast array of weapons, items, and customization options. The game's realistic physics and detailed environments create a world that feels truly alive. You will have a unique experience. The world of Red Dead Redemption 2 is alive, and you can experience it all.\n\nRed Dead Redemption 2 offers an unforgettable adventure, transporting you to a time and place where the rules are few. Survival is a constant struggle. Get ready to ride, shoot, and uncover a story that will leave a lasting impact. Prepare for an epic tale of redemption in a world where the Wild West is rapidly fading. You will be a part of the Wild West.",
        "productspecification": {
            "platform": "PlayStation 4, Xbox One, PC, Stadia",
            "genre": "Action-Adventure",
            "developer": "Rockstar Games",
            "publisher": "Rockstar Games",
            "releaseDate": "October 26, 2018",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547323/13_yt19ud.jpg",
        "price": "₹1999"
    },
    {
        "id": 14,
        "title": "The Witcher 3: Wild Hunt",
        "description": "Geralt’s epic monster-hunting adventure.",
        "About": "Embark on an epic journey as Geralt of Rivia, a monster hunter for hire, in The Witcher 3: Wild Hunt. It is an open-world action RPG. It sets a new standard for immersion and storytelling. The game is set in a vast and detailed world. It is filled with political intrigue, dangerous creatures, and complex characters. Experience the story and explore the world.\n\nExplore a sprawling open world, filled with diverse environments, from dense forests to war-torn battlefields. Engage in challenging combat encounters. You'll utilize Geralt's swords, signs, and potions to defeat your enemies. The game also allows you to craft a variety of weapons, items, and gear to enhance your abilities. You will uncover secrets. The game is filled with them. Unravel a complex narrative. The game is filled with difficult choices. The world is filled with moral ambiguities and a gripping story. There are also many side quests.\n\nEncounter memorable characters, both friend and foe. The game also requires you to make decisions that will shape the fate of the world. Explore the world and discover side quests, hidden locations, and rewarding activities. The game’s dynamic weather system and detailed environments create a world that feels truly alive. The detailed world, and memorable moments will provide a unique experience. \n\nThe Witcher 3: Wild Hunt offers a thrilling and unforgettable adventure. Step into Geralt's boots, explore the world, and uncover the secrets of a world on the brink of war. Get ready to hunt monsters, forge alliances, and make choices that will determine the fate of the Northern Kingdoms and become a Witcher.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "Action RPG",
            "developer": "CD Projekt Red",
            "publisher": "CD Projekt",
            "releaseDate": "May 19, 2015",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547592/id_14_ibleaa.jpg",
        "price": "₹1999"
    },
    {
        "id": 15,
        "title": "Assassin’s Creed Mirage",
        "description": "Stealth action set in ancient Baghdad.",
        "About": "Step back in time to the vibrant streets of 9th-century Baghdad in Assassin's Creed Mirage. It is a return to the series' stealth-action roots. Take on the role of Basim Ibn Is'haq, a young thief who joins the Hidden Ones, the precursors to the Assassins. Immerse yourself in a richly detailed historical setting. Explore iconic locations, and experience a more focused and intimate Assassin's Creed adventure.\n\nMaster the art of stealth, utilizing a variety of tools and techniques to eliminate your targets silently. The game features a return to the series' classic parkour and social stealth mechanics. Explore the bustling city of Baghdad, scaling buildings, navigating crowds, and uncovering secrets. Uncover the dark side of ancient Baghdad. The game features a more linear structure. This allows the player to focus on the world around them and the story.\n\nExperience a compelling narrative that follows Basim's transformation from a street thief to a master assassin. Meet memorable characters, uncover historical secrets, and delve into the origins of the Assassin Brotherhood. The game places a strong emphasis on stealth, environmental interaction, and a narrative-driven experience. The game features beautiful graphics and an engaging story.\n\nAssassin’s Creed Mirage is a love letter to the series' original formula, offering a focused and engaging experience. Prepare to blend into the shadows, eliminate your targets, and uncover the truth behind the Hidden Ones. Get ready to immerse yourself in the world and the world of the Hidden Ones. The gameplay is very exciting and the world is vibrant.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Amazon Luna",
            "genre": "Action-Adventure",
            "developer": "Ubisoft Bordeaux",
            "publisher": "Ubisoft",
            "releaseDate": "October 5, 2023",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547328/15_g9uwdh.jpg",
        "price": "₹1999"
    },
    {
        "id": 16,
        "title": "Call of Duty: Warzone",
        "description": "Fast-paced battle royale shooter.",
        "About": "Dive into the high-octane world of Call of Duty: Warzone, a free-to-play battle royale experience that pits players against each other in intense combat. Drop into a massive map, gather weapons and equipment, and fight to be the last team standing. Experience intense firefights, strategic gameplay, and thrilling moments in this fast-paced, action-packed shooter. The core of the game is about survival.\n\nExplore a dynamic and ever-evolving map, featuring a variety of locations, from urban environments to open landscapes. Engage in fast-paced combat, utilizing a wide range of weapons, attachments, and tactical equipment. The game offers a variety of gameplay modes. The game also features a unique Gulag system, where defeated players get a chance to fight their way back into the game. Team up with friends and compete against other squads to achieve the ultimate victory.\n\nExperience regular updates, new content, and a constantly evolving meta. Customize your loadouts, choose your Operators, and dominate the battlefield. The game has a deep progression system. Unlock new weapons, perks, and cosmetic items as you progress through the ranks. Get ready to experience the thrill and adrenaline of Call of Duty: Warzone. Your loadout will be what gets you through many battles.\n\nCall of Duty: Warzone provides a thrilling and accessible battle royale experience for players of all skill levels. Get ready to experience the adrenaline and battle against your enemies. With its intense gameplay, strategic depth, and constant updates, Call of Duty: Warzone is a must-play for fans of the genre and newcomers. Prepare to be challenged and entertained in this unique game.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC",
            "genre": "First-Person Shooter",
            "developer": "Infinity Ward, Raven Software",
            "publisher": "Activision",
            "releaseDate": "March 10, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547593/id_16_yrscn9.jpg",
        "price": "₹1999"
    },
    {
        "id": 17,
        "title": "Fortnite",
        "description": "Battle royale with creative building mechanics.",
        "About": "Dive into the vibrant and ever-evolving world of Fortnite, a free-to-play battle royale experience that has captured the hearts of millions. Drop into a dynamic island, where 100 players compete to be the last one standing. The game combines fast-paced combat with a unique building mechanic. This allows players to construct structures for defense, offense, and traversal, adding a layer of strategic depth.\n\nExplore a constantly changing map, with new locations, events, and challenges added regularly, keeping the experience fresh and exciting. Engage in intense gunfights, utilizing a wide array of weapons, gadgets, and items. The game also features a robust crafting system. Players will use the materials they gather to build structures, providing both tactical advantage and creative expression. Fortnite offers a vast array of cosmetics.\n\nExperience regular seasonal updates that introduce new themes, characters, weapons, and gameplay mechanics. Join limited-time events and collaborate with other players. The game fosters a strong sense of community. You can also customize your character with a vast array of skins, emotes, and other cosmetic items. Whether you're a seasoned veteran or a newcomer, Fortnite provides a welcoming and entertaining experience.\n\nFortnite is more than just a battle royale; it's a constantly evolving social hub. You're able to express yourself and your creativity. Get ready to build, battle, and explore in this ever-popular phenomenon. With its constant updates, collaborative events, and creative gameplay, Fortnite provides a fun experience for all. Jump in today and start your journey to the top.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch, Android, iOS",
            "genre": "Battle Royale",
            "developer": "Epic Games",
            "publisher": "Epic Games",
            "releaseDate": "July 25, 2017",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545009/EN_BXECO_33-00_Shooter_EGS_Launcher_Blade_2560x1440_2560x1440-36e1ff15dc00cd506986a2565764bbd3_hkbzxq.jpg",
        "price": "₹1999"
    },
    {
        "id": 18,
        "title": "Baldur’s Gate 3",
        "description": "Deep RPG based on Dungeons & Dragons.",
        "About": "Step into the rich world of Baldur’s Gate 3, a sprawling role-playing game deeply rooted in the rules and lore of Dungeons & Dragons. Embark on an unforgettable adventure where your choices truly matter, shaping not only your own destiny but also the fate of the world around you. Explore a world filled with intricate detail, dynamic environments, and a cast of compelling characters. The game is incredibly deep.\n\nCreate a character from a vast array of races, classes, and backgrounds, each with their own unique abilities and storylines. Engage in turn-based combat, utilizing strategy, tactics, and the environment to overcome challenging encounters. Baldur’s Gate 3 is known for its depth and complexity. Experience a narrative that reacts to your every decision, with branching storylines, meaningful consequences, and a world that feels truly alive. You will be able to customize your character a great deal.\n\nForge alliances, make enemies, and uncover the secrets of the Forgotten Realms. The game features a high degree of player agency. Explore a vast and dynamic world, filled with hidden locations, challenging dungeons, and unforgettable moments. The game offers many possibilities, which will make for a unique experience.\n\nBaldur’s Gate 3 is an exceptional RPG. Whether you're a seasoned D&D player or new to the genre, Baldur's Gate 3 offers an unparalleled experience. Prepare for an immersive journey through a world filled with magic, mystery, and endless possibilities. Explore a large world with many things to do.",
        "productspecification": {
            "platform": "PlayStation 5, PC, Xbox Series X/S",
            "genre": "Role-Playing Game",
            "developer": "Larian Studios",
            "publisher": "Larian Studios",
            "releaseDate": "August 3, 2023",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547594/id_18_x7mybe.avif",
        "price": "₹1999"
    },
    {
        "id": 19,
        "title": "The Legend of Zelda: Breath of the Wild",
        "description": "Explore a vast open-world Hyrule.",
        "About": "Embark on a breathtaking adventure across the vast, open world of Hyrule in The Legend of Zelda: Breath of the Wild. As Link, you awaken from a century-long slumber to find Hyrule in ruins, threatened by the malevolent Calamity Ganon. The game is a true masterpiece. You will explore a large and detailed world.\n\nExplore a stunningly realized world, filled with diverse landscapes, from towering mountains and dense forests to ancient ruins and vast plains. The game emphasizes exploration. Master a variety of weapons, abilities, and items to overcome challenges, solve puzzles, and defeat enemies. You will have to learn to use the world around you to succeed. The game is known for its creativity and unique gameplay.\n\nUnravel a captivating story of heroism, loss, and the enduring power of hope. Meet memorable characters, uncover the secrets of Hyrule's past, and embark on a quest to save the kingdom. The game allows for freedom and exploration. The game offers a large amount of content, making for a unique and immersive experience.\n\nThe Legend of Zelda: Breath of the Wild is a revolutionary open-world adventure. You can experience the thrill of exploration, the satisfaction of discovery, and the joy of freedom. Prepare to embark on an unforgettable journey. The game offers something for everyone. Whether you're a veteran or a new player, you'll enjoy the game.",
        "productspecification": {
            "platform": "Nintendo Switch, Wii U",
            "genre": "Action-Adventure",
            "developer": "Nintendo EPD",
            "publisher": "Nintendo",
            "releaseDate": "March 3, 2017",
            "rating": "Everyone 10+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547323/19_q3dbxg.jpg",
        "price": "₹1999"
    },
    {
        "id": 20,
        "title": "Overwatch 2",
        "description": "Team-based shooter with unique heroes.",
        "About": "Enter the vibrant and fast-paced world of Overwatch 2, a team-based hero shooter where players choose from a diverse roster of heroes, each with unique abilities and roles. Team up with five other players to battle against another team, with different game modes. These modes will test your skills, strategy, and coordination.\n\nMaster a variety of heroes, each with distinct abilities and roles, from damage dealers to healers and tanks. Coordinate with your team to create synergistic compositions and strategies. The game is focused on strategic gameplay and coordination. Adapt to the ever-changing conditions of battle. You will always be trying to improve in this game.\n\nExperience a constantly evolving game, with new heroes, maps, and game modes added regularly, keeping the experience fresh and exciting. The game has a diverse roster of heroes. You will be able to customize your heroes with a variety of skins and other cosmetic items. Join a vibrant and competitive community, participating in ranked matches, tournaments, and other events.\n\nOverwatch 2 is a fast-paced and engaging experience that will challenge your skills, reward your teamwork, and captivate your imagination. Get ready to choose your hero. With its dynamic gameplay, diverse cast of characters, and dedicated community, Overwatch 2 is a must-play for fans of the hero shooter genre.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "First-Person Shooter",
            "developer": "Blizzard Entertainment",
            "publisher": "Blizzard Entertainment",
            "releaseDate": "October 4, 2022",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739547594/id_20_b6fovn.jpg",
        "price": "₹2999"
    },
    {
        "id": 21,
        "title": "Minecraft",
        "description": "Endless creativity and exploration.",
        "About": "Enter the endless world of Minecraft, a block-based sandbox game that allows for unparalleled creativity and exploration. Build anything you can imagine, from simple shelters to elaborate castles, using a vast array of blocks and resources. Survive the night, fend off monsters, and gather resources to craft tools, weapons, and armor to thrive in this limitless world.\n\nExplore a procedurally generated world, with diverse biomes, hidden caves, and ancient ruins waiting to be discovered. Engage in creative building, constructing structures, contraptions, and entire worlds based on your imagination. Survive the harsh realities of the game's world. You can create your own adventure.\n\nExperience a vast array of gameplay modes, from survival to creative, allowing you to tailor your experience to your preferences. Join multiplayer servers and collaborate with friends or compete in mini-games. The game offers a vast amount of customization, allowing you to create your own unique experience and express your individuality.\n\nMinecraft is a timeless classic that has captivated players of all ages with its simple yet incredibly versatile gameplay. Get ready to explore, build, survive, and create in this endlessly engaging sandbox. With its limitless possibilities, Minecraft provides a fun and educational experience for players of all ages, encouraging creativity, problem-solving, and social interaction. Dive into the infinite world today.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch, Android, iOS, and more",
            "genre": "Sandbox",
            "developer": "Mojang Studios",
            "publisher": "Mojang Studios",
            "releaseDate": "November 18, 2011",
            "rating": "Everyone 10+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548878/21_xkppth.jpg",
        "price": "₹2999"
    },
    {
        "id": 22,
        "title": "Fall Guys",
        "description": "Fun obstacle course battle royale.",
        "About": "Dive into the wacky and hilarious world of Fall Guys, a chaotic and competitive battle royale where dozens of jelly bean-like characters compete in a series of obstacle courses and mini-games. Eliminate your opponents. The goal is to be the last one standing. The game combines platforming, physics-based gameplay, and a healthy dose of slapstick humor to create an experience that's both challenging and incredibly fun.\n\nNavigate a series of increasingly difficult and ridiculous obstacle courses, from spinning platforms to giant swinging hammers. You'll be able to jump, grab, and dive. Compete in a variety of mini-games, including team-based challenges, races, and survival modes, where teamwork and quick thinking are crucial. You will need skill to overcome your opponents.\n\nExperience regular updates, with new rounds, costumes, and events added to keep the experience fresh and engaging. Customize your Fall Guy with a variety of quirky costumes, emotes, and other cosmetic items to stand out from the crowd. Fall Guys features a casual and friendly environment. The game is very accessible to players of all skill levels.\n\nFall Guys offers a hilariously entertaining experience that's perfect for playing with friends or on your own. Prepare to stumble, trip, and laugh your way to victory. With its charming visuals, chaotic gameplay, and simple mechanics, Fall Guys is a must-play for fans of party games and competitive fun.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "Battle Royale, Platformer",
            "developer": "Mediatonic",
            "publisher": "Mediatonic",
            "releaseDate": "August 4, 2020",
            "rating": "Everyone 10+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548877/22_efmnwv.png",
        "price": "₹2999"
    },
    {
        "id": 23,
        "title": "Apex Legends",
        "description": "Fast-paced hero-based battle royale.",
        "About": "Dive into the arena of Apex Legends, a hero-based battle royale shooter that combines fast-paced action with strategic team play. Choose from a roster of unique Legends, each with distinct abilities that complement different playstyles. Team up with two other players to form a squad and compete against other teams in a battle to be the last one standing on a shrinking map.\n\nExperience a dynamic and fluid movement system, allowing for thrilling combat encounters and tactical maneuvers. Master the unique abilities of your chosen Legend, combining them with your teammates' skills to outsmart and outplay your opponents. Apex Legends requires a great deal of thinking.\n\nThe game offers regular updates, new Legends, weapons, and cosmetic items to keep the experience fresh and engaging. The game features a ping system that allows for enhanced communication. You can easily coordinate with your team, even without voice chat. Compete against other squads for ultimate victory.\n\nApex Legends offers a thrilling and competitive battle royale experience for players of all skill levels. Experience the thrill of victory. Get ready to choose your Legend, drop into the arena, and fight for survival. With its innovative features, strategic gameplay, and diverse cast of characters, Apex Legends is a must-play for fans of the battle royale genre.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "First-Person Shooter, Battle Royale",
            "developer": "Respawn Entertainment",
            "publisher": "Electronic Arts",
            "releaseDate": "February 4, 2019",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548877/23_kyb3xt.jpg",
        "price": "₹2999"
    },
    {
        "id": 24,
        "title": "Among Us",
        "description": "Social deduction and betrayal in space.",
        "About": "Among Us thrusts players into a spaceship setting where social deduction and teamwork are paramount. Crewmates must collaboratively complete tasks across the ship, ranging from fixing electrical systems to charting courses, all while trying to identify and vote out the Impostors. These Impostors, disguised as crew, secretly sabotage the ship and silently eliminate crew members, creating an atmosphere of paranoia and suspense. Players must rely on observation, deduction, and communication to uncover the Impostors and secure the ship's safety.\n\nGameplay revolves around a cycle of task completion, emergency meetings, and strategic deception. Crewmates use their observations to build a case against suspected Impostors during these meetings, while Impostors use clever lies and manipulation to avoid suspicion. The success of each side depends on their ability to outwit their opponents, whether through skillful performance of tasks or through masterful manipulation of others. The game's simplicity allows for a quick learning curve, while its depth arises from player interactions, leading to countless unique scenarios and moments of unexpected betrayal.\n\nCommunication is a key element, and the game encourages players to share information, express their opinions, and debate the evidence. Players can discuss their observations, point fingers, and try to persuade others to their side of the argument. However, communication is not always straightforward, as Impostors can strategically misinform or spread doubt to confuse the crewmates. The game also supports local and online multiplayer, and allows cross-platform play. A game can accommodate from 4 to 15 players, which contributes to varied experiences, from intimate deception to large-scale chaos.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch, Android, iOS",
            "genre": "Social Deduction",
            "developer": "InnerSloth",
            "publisher": "InnerSloth",
            "releaseDate": "June 15, 2018",
            "rating": "Everyone 10+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548877/24_tioutw.jpg",
        "price": "₹2999"
    },
    {
        "id": 25,
        "title": "Hades",
        "description": "Roguelike dungeon crawler with Greek mythology.",
        "About": "Hades is a thrilling rogue-like dungeon crawler that draws inspiration from Greek mythology. Players take on the role of Zagreus, the rebellious son of Hades, as he embarks on a series of daring escape attempts from the Underworld. Each run presents a fresh experience with procedurally generated rooms and a diverse array of enemies, ensuring that no two playthroughs are ever identical. The game masterfully combines fast-paced action combat with strategic choices, as players collect boons from Olympian gods, granting them unique abilities and weapon enhancements.\n\nThe combat system emphasizes fluid movement and skillful use of weapons and abilities. Players can choose from a selection of weapons, each with distinct attack patterns and special moves, and customize their builds with a wide range of boons. The game also offers a compelling narrative, as Zagreus interacts with a cast of memorable characters, including the gods and other denizens of the Underworld. The story unfolds gradually, revealing more about Zagreus's past, his family, and his motivation to escape.\n\nHades's success is measured by more than just escape, which is extremely difficult. Each run provides opportunities for player progression, through earned resources which allow for permanent upgrades to Zagreus. This meta-progression enhances the feeling of accomplishment as you become better, allowing you to last longer and gain more insight into the story. The compelling gameplay, coupled with stunning art and audio design, and a captivating storyline, makes Hades one of the most acclaimed rogue-like games in recent memory.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch",
            "genre": "Roguelike, Dungeon Crawler",
            "developer": "Supergiant Games",
            "publisher": "Supergiant Games",
            "releaseDate": "September 17, 2020",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548878/25_pxhcbe.jpg",
        "price": "₹2999"
    },
    {
        "id": 26,
        "title": "The Last of Us Part II",
        "description": "Emotional post-apocalyptic survival journey.",
        "About": "The Last of Us Part II presents a gripping narrative set in a post-apocalyptic world ravaged by a fungal plague. Players embody Ellie, five years after the events of the first game, as she is drawn into a relentless cycle of revenge that pushes her to the limits of her humanity. The game masterfully explores themes of loss, trauma, and the consequences of violence, delivering a deeply emotional and thought-provoking experience. Naughty Dog's meticulous attention to detail is evident in the game's stunning visuals, realistic character animations, and immersive environmental storytelling.\n\nGameplay blends stealth, exploration, and intense combat encounters. Players must scavenge for resources, craft essential items, and navigate treacherous environments while facing both infected creatures and hostile human factions. The combat system is brutal and unforgiving, requiring players to make strategic use of cover, utilize stealth tactics, and manage their limited resources. The game also features a compelling cast of characters, each with their own motivations and complex relationships, adding depth and complexity to the narrative.\n\nThe Last of Us Part II pushes narrative boundaries. The story tackles difficult themes and offers no easy answers, challenging the player to confront the complexities of human nature and the cost of vengeance. With an engaging story, engaging gameplay, and cutting-edge visuals, the game is a landmark title in the action-adventure genre and a must-play for fans of the original and those seeking a powerful and unforgettable gaming experience.",
        "productspecification": {
            "platform": "PlayStation 4",
            "genre": "Action-Adventure",
            "developer": "Naughty Dog",
            "publisher": "Sony Interactive Entertainment",
            "releaseDate": "June 19, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548878/26_czw8f9.jpg",
        "price": "₹2999"
    },
    {
        "id": 27,
        "title": "Doom Eternal",
        "description": "Fast-paced demon-slaying first-person shooter.",
        "About": "Doom Eternal is a high-octane first-person shooter that delivers an adrenaline-fueled experience of demon-slaying. Players take on the role of the Doom Slayer, a powerful warrior armed with an arsenal of devastating weapons, as they battle hordes of demons and other enemies across diverse and visually stunning environments. The game emphasizes fast-paced, aggressive combat, encouraging players to constantly move, dash, and strategically utilize their weapons and abilities to stay alive.\n\nThe combat system is refined, emphasizing resource management. Players can replenish health, armor, and ammo by performing glory kills on weakened enemies, chainsawing them to pieces, or using the flame belch to set them on fire. This system encourages constant engagement and strategic decision-making, as players must balance offense with defense. The game features a compelling single-player campaign, with intense boss battles, and a challenging multiplayer mode that lets players compete against each other in chaotic and fast-paced matches.\n\nDoom Eternal provides stunning graphics, with detailed environments, and brutal animations. The game's heavy metal soundtrack amplifies the energy of combat, creating an immersive and exhilarating experience. The diverse enemy types, each with unique attack patterns and weaknesses, demand that players adapt their strategies to survive. Doom Eternal delivers an intense, rewarding, and incredibly fun experience. The innovative combat design, coupled with a compelling story, makes it a defining title in the first-person shooter genre and a must-play for fans of action games.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, Xbox One, PC, Nintendo Switch, Stadia",
            "genre": "First-Person Shooter",
            "developer": "id Software",
            "publisher": "Bethesda Softworks",
            "releaseDate": "March 20, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739545002/2754384_bhem32.jpg",
        "price": "₹2999"
    },
    {
        "id": 28,
        "title": "Final Fantasy VII Remake",
        "description": "Reimagined classic RPG with modern visuals.",
        "About": "Final Fantasy VII Remake is a reimagining of a classic RPG, offering a fresh take on a beloved story with modern visuals and gameplay mechanics. The game revisits the iconic world of Midgar, meticulously recreating its environments and characters with stunning detail. Players control Cloud Strife and his allies as they join the anti-Shinra organization, Avalanche, and fight against the oppressive corporation that controls the city's energy supply. The game blends a thrilling narrative with engaging gameplay that stays true to the spirit of the original.\n\nThe combat system combines real-time action with strategic command-based elements. Players can seamlessly switch between different characters, each with their unique abilities and playstyles, while using the command menu to execute special attacks and spells. The game also features a deep character progression system, allowing players to customize their characters with a wide variety of weapons, armor, and Materia, which grants them powerful abilities and upgrades. The story is expanded, adding new layers of depth to characters and events.\n\nFinal Fantasy VII Remake delivers a truly unforgettable gaming experience with stunning visuals and an engaging story. The game's enhanced combat system and modernized gameplay mechanics are a perfect blend of classic RPG elements and modern action. The game features a compelling soundtrack, and a cast of memorable characters, enhancing the immersive experience. The Final Fantasy VII Remake is a must-play for both veterans and newcomers alike, with its engaging story, compelling gameplay, and stunning visuals, delivering a truly unforgettable gaming experience.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, PC",
            "genre": "Action RPG",
            "developer": "Square Enix",
            "publisher": "Square Enix",
            "releaseDate": "April 10, 2020",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548879/28_pzuyij.jpg",
        "price": "₹2999"
    },
    {
        "id": 29,
        "title": "Demon's Souls",
        "description": "Challenging action RPG remake with stunning graphics.",
        "About": "Demon's Souls is a challenging action RPG remake that brings the dark fantasy world to life with stunning graphics and enhanced gameplay. The game is set in the kingdom of Boletaria, a once-prosperous land now overrun by demons. Players take on the role of a hero who must venture into the treacherous areas and face the terrible threats. The game challenges you from beginning to end.\n\nThe core gameplay is known for its punishing difficulty, demanding careful strategy, and skillful execution. Players must navigate labyrinthine environments, facing fearsome enemies, and overcome challenging boss battles. The combat system relies on precision, timing, and resource management, encouraging players to learn enemy attack patterns, master parrying and dodging, and use their weapons and abilities effectively. The game retains a familiar Souls-like formula, including the return of a central hub known as the Nexus.\n\nThe remake features upgraded visuals, which are breathtaking. The enhanced graphics bring the desolate world of Boletaria to life, creating an immersive and unforgettable gaming experience. Demon's Souls offers a deeply rewarding gameplay experience, with its satisfying combat, challenging difficulty, and immersive world-building, Demon's Souls is a must-play title for fans of the action RPG genre and those seeking a true test of skill and patience.",
        "productspecification": {
            "platform": "PlayStation 5",
            "genre": "Action RPG",
            "developer": "Bluepoint Games, SIE Japan Studio",
            "publisher": "Sony Interactive Entertainment",
            "releaseDate": "November 12, 2020",
            "rating": "Mature 17+"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548880/29_fqxhit.jpg",
        "price": "₹2999"
    },
    {
        "id": 30,
        "title": "Street Fighter 6",
        "description": "Iconic fighting game with new mechanics.",
        "About": "Street Fighter 6 reignites the passion for the iconic fighting game franchise, offering a perfect blend of classic gameplay and innovative new mechanics. The game features a diverse roster of characters, each with unique fighting styles and signature moves. The game introduces a new Drive System, which provides players with new offensive and defensive options, adding depth to the combat and encouraging strategic decision-making during matches. Street Fighter 6 offers a wealth of content for players of all skill levels.\n\nThe combat system is enhanced, making the fighting experience more engaging and dynamic. The Drive System includes the ability to perform parries, drive impacts, and drive rushes, adding complexity and strategic depth to the gameplay. Players can choose from a variety of gameplay modes, including classic versus battles, a single-player World Tour mode, and a new Battle Hub, where players can interact with each other, participate in tournaments, and customize their avatars. The game offers stunning visuals, with detailed character models, and vibrant environments, enhancing the immersive fighting experience.\n\nStreet Fighter 6 features a robust online multiplayer system, allowing players to compete against each other in ranked and casual matches, across platforms. The game features a unique and exciting combat system, and diverse content. With its accessible yet deep gameplay, stunning visuals, and engaging content, Street Fighter 6 offers an unforgettable experience for both newcomers and long-time fans of the fighting game genre.",
        "productspecification": {
            "platform": "PlayStation 5, PlayStation 4, Xbox Series X/S, PC",
            "genre": "Fighting",
            "developer": "Capcom",
            "publisher": "Capcom",
            "releaseDate": "June 2, 2023",
            "rating": "Teen"
        },
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739548882/30_uarvyg.jpg",
        "price": "₹3999"
    }
];

// Main component
const UploadFeatured = () => {
    // Clear existing documents in Firestore
    const clearExistingData = async () => {
        const collectionRef = collection(db, 'Featured');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'Featured', docSnapshot.id));
        });
    };

    // Upload new JSON data to Firestore
    const uploadData = async () => {
        try {
            await clearExistingData(); // Clear old data first
            const collectionRef = collection(db, 'Featured');

            for (const bundle of Featured) {
                await addDoc(collectionRef, bundle);
            }

            console.log('Data uploaded successfully!');
        } catch (error) {
            console.error('Error uploading data:', error);
        }
    };

    // Automatically run once when the component is mounted
    // useEffect(() => {
    //     uploadData();
    // }, []);

    // return null;
};

export default UploadFeatured;
