import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../firebase';

const xboxfeaturedgames = [
  {
    id: 1,
    title: "Halo Infinite",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/1_yi33wt.jpg",
    genre: "First-Person Shooter",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Explore the expansive rings of Halo as Master Chief in a gripping campaign and engage in exhilarating multiplayer battles.",
    price: "₹1599",
    About: "Halo Infinite is the latest installment in the iconic saga of Master Chief. This first-person shooter allows players to navigate through an open-world environment, engage in thrilling combat with advanced enemy AI, and experience epic battles across vast landscapes. The multiplayer mode emphasizes player choice, tactical gameplay, and offers a variety of modes and maps.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "First-Person Shooter",
      developer: "343 Industries",
      publisher: "Xbox Game Studios",
      releaseDate: "December 8, 2021",
      rating: "Mature"
    }
  },
  {
    id: 2,
    title: "Forza Horizon 5",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/2_zzwo6z.jpg",
    genre: "Racing",
    platform: "Xbox Series X|S, Xbox One, PC",
    exclusive: true,
    description: "Experience the vibrant landscapes of Mexico in this open-world racing game, featuring a diverse car roster and dynamic seasons.",
    price: "₹1699",
    About: "Forza Horizon 5 is an open-world racing game that showcases the beauty of Mexico. With stunning visuals and a realistic weather system, players can race in varied terrains including deserts, jungles, and cities. The game features a multitude of vehicles, allowing for exciting customization and upgrades, with online multiplayer modes that magnify the racing experience.",
    productspecification: {
      platform: "Xbox Series X|S, Xbox One, PC",
      genre: "Racing",
      developer: "Playground Games",
      publisher: "Xbox Game Studios",
      releaseDate: "November 9, 2021",
      rating: "For Everyone"
    }
  },
  {
    id: 3,
    title: "Starfield",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/3_fsdvup.jpg",
    genre: "Action RPG",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Embark on an epic space exploration journey in this role-playing game set in a vast universe filled with unique worlds and factions.",
    price: "₹1699",
    About: "Starfield is Bethesda's first new IP in 25 years, inviting players to explore deep space. As a space explorer, players can customize their ships, discover new planets, and engage with various factions. The game combines traditional RPG elements with a rich narrative and open-world exploration set against a cosmic backdrop.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action RPG",
      developer: "Bethesda Game Studios",
      publisher: "Bethesda Softworks",
      releaseDate: "September 6, 2023",
      rating: "Mature"
    }
  },
  {
    id: 4,
    title: "Fable",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/4_soyiab.jpg",
    genre: "Action RPG",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Rediscover the magical world of Albion in this reimagined RPG, where your choices shape your character and the fate of the land.",
    price: "₹1599",
    About: "The new Fable reimagines the beloved RPG series with a modern twist on storytelling and gameplay mechanics. Set in the enchanting world of Albion, players will embark on quests, interact with quirky characters, and face moral choices that affect their journey. The game promises a blend of humor, adventure, and exploration.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action RPG",
      developer: "Playground Games",
      publisher: "Xbox Game Studios",
      releaseDate: "To Be Announced",
      rating: "To Be Announced"
    }
  },
  {
    id: 5,
    title: "Perfect Dark",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/5_y1ftyl.jpg",
    genre: "Action Adventure",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Take on the role of agent Joanna Dark in this stealth-driven shooter, blending thrilling espionage with futuristic technology.",
    price: "₹1699",
    About: "Perfect Dark presents a thrilling espionage experience as players navigate through covert missions as Joanna Dark. With a focus on stealth and strategy, the game introduces advanced gadgets and futuristic weaponry, enhancing the gameplay. The narrative-driven design captivates players as they unravel a deeper conspiracy.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action Adventure",
      developer: "The Initiative",
      publisher: "Xbox Game Studios",
      releaseDate: "To Be Announced",
      rating: "To Be Announced"
    }
  },
  {
    id: 6,
    title: "Microsoft Flight Simulator",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/6_firpwj.jpg",
    genre: "Simulation",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Experience the most realistic flying simulation ever, featuring real-world mapping and weather for an unparalleled pilot experience.",
    price: "₹699",
    About: "Microsoft Flight Simulator offers an unmatched aviation experience, allowing players to fly some of the world's most iconic aircraft. With realistic environments and real-time weather conditions, simulate flying across the globe with stunning attention to detail. The game is designed for enthusiasts and newcomers alike, providing numerous flight missions and tutorials.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Simulation",
      developer: "Asobo Studio",
      publisher: "Xbox Game Studios",
      releaseDate: "July 27, 2021",
      rating: "For Everyone"
    }
  },
  {
    id: 7,
    title: "Gears 5",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/7_rsa4b9.png",
    genre: "Third-Person Shooter",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Join the fight against a deadly new enemy in this cooperative shooter, featuring rich storytelling and intense multiplayer action.",
    price: "₹1399",
    About: "Gears 5 steps into the forefront of the Gears franchise with enhanced gameplay mechanics and a gripping narrative. Players can engage in single-player mode or cooperate with friends in a thrilling multiplayer experience. The game emphasizes character development and story depth with a mixture of intense combat and strategic cover mechanics.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Third-Person Shooter",
      developer: "The Coalition",
      publisher: "Xbox Game Studios",
      releaseDate: "September 10, 2019",
      rating: "Mature"
    }
  },
  {
    id: 8,
    title: "Sea of Thieves",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/8_wfgany.jpg",
    genre: "Action-Adventure",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Become a pirate legend as you explore a shared world, engage in ship battles, and hunt for treasure with friends or alone.",
    price: "₹1599",
    About: "Sea of Thieves invites players to live the pirate life in a shared open world, exploring islands, battling other crews, and hunting for treasure. The game focuses on teamwork and invites players of all skill levels to join the adventure. Discovering new secrets and conquering legendary challenges are part of the fun!",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action-Adventure",
      developer: "Rare",
      publisher: "Xbox Game Studios",
      releaseDate: "March 20, 2018",
      rating: "For Teen"
    }
  },
  {
    id: 9,
    title: "Grounded",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/9_qsopfs.jpg",
    genre: "Survival",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Shrink down to the size of an ant and survive in a backyard filled with dangers, crafting tools and building bases with friends.",
    price: "₹2999",
    About: "Grounded explores survival mechanics in a backyard transformed into an adventure-filled world. Play solo or with friends, crafting items and building tiny hideouts while facing the dangers of insects. The game combines exploration with strategic challenges, offering a fun and imaginative survival experience.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Survival",
      developer: "Obsidian Entertainment",
      publisher: "Xbox Game Studios",
      releaseDate: "July 28, 2020",
      rating: "For Teen"
    }
  },
  {
    id: 10,
    title: "State of Decay 2",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/10_udjegv.jpg",
    genre: "Zombie Survival",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Build your community and survive against hordes of zombies in this strategic survival game, making tough decisions for your group's future.",
    price: "₹1,399",
    About: "State of Decay 2 puts players in the midst of a zombie apocalypse where strategic decision-making is crucial for survival. Build your community, manage resources, and engage in combat against the undead. The game offers an engaging narrative experience with RPG elements, allowing players to develop unique characters and alliances.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Zombie Survival",
      developer: "Undead Labs",
      publisher: "Xbox Game Studios",
      releaseDate: "May 22, 2018",
      rating: "Mature"
    }
  },
  {
    id: 11,
    title: "Ori and the Will of the Wisps",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/11_l4zlfc.jpg",
    genre: "Platformer",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Experience a visually stunning platformer that weaves an emotional tale of friendship and sacrifice through challenging puzzles and exploration.",
    price: "₹1299",
    About: "Ori and the Will of the Wisps enhances the experience set by its predecessor with beautiful visuals and an emotional narrative. Engage in complex puzzles and challenges while exploring a vast interconnected world filled with mysteries and new gameplay mechanics. The game combines platforming with profound storytelling, creating a moving experience.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Platformer",
      developer: "Moon Studios",
      publisher: "Xbox Game Studios",
      releaseDate: "March 11, 2020",
      rating: "For Everyone"
    }
  },
  {
    id: 12,
    title: "Psychonauts 2",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/12_k3zsox.jpg",
    genre: "Platformer",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Dive into the minds of unique characters in this whimsical platformer, unraveling mysteries while exploring imaginative worlds.",
    price: "₹1399",
    About: "Psychonauts 2 delivers an imaginative platforming adventure filled with humor and deep narrative. Players become Razputin, a budding psychic agent, navigating through the minds of various characters. Each level represents a unique world with distinct challenges, offering a rich experience that reflects on mental health themes.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Platformer",
      developer: "Double Fine Productions",
      publisher: "Xbox Game Studios",
      releaseDate: "August 25, 2021",
      rating: "For Everyone"
    }
  },
  {
    id: 13,
    title: "The Medium",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/13_ipxpst.jpg",
    genre: "Psychological Horror",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Explore a haunting dual-reality world as a medium with psychic abilities, uncovering dark secrets and confronting supernatural threats.",
    price: "₹1999",
    About: "The Medium is a psychological horror experience that creatively uses dual-reality gameplay. Players navigate between two worlds – the physical and the spirit realm – using psychic abilities to solve mysteries and confront dark forces. The chilling atmosphere and narrative depth immerse players in a haunting experience.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Psychological Horror",
      developer: "Bloober Team",
      publisher: "Xbox Game Studios",
      releaseDate: "January 28, 2021",
      rating: "Mature"
    }
  },
  {
    id: 14,
    title: "Elden Ring",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117415/14_rdgvpo.jpg",
    genre: "Action RPG",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Unravel the mysteries of the Elden Ring in this expansive open-world RPG, filled with rich lore, challenging foes, and deep exploration.",
    price: "₹1699",
    About: "Elden Ring presents a vast open world filled with interwoven narratives crafted by Hidetaka Miyazaki and George R. R. Martin. Players can explore diverse environments, engage in deep combat mechanics, and discover myriad secrets within the beautifully crafted landscapes. The game emphasizes exploration and player choice.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action RPG",
      developer: "FromSoftware",
      publisher: "Bandai Namco Entertainment",
      releaseDate: "February 25, 2022",
      rating: "Mature"
    }
  },
  {
    id: 15,
    title: "Cyberpunk 2077",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/15_iob4b8.jpg",
    genre: "Action RPG",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Step into the dystopian Night City where choices matter, customizing your character and facing treacherous challenges in a high-tech world.",
    price: "₹1599",
    About: "Cyberpunk 2077 offers an expansive open-world experience set in the neon-lit metropolis of Night City. Players customize their character with diverse skills and cybernetic enhancements while navigating complex relationships and choices affecting the narrative. The game is known for its rich lore and immersive world.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action RPG",
      developer: "CD Projekt Red",
      publisher: "CD Projekt",
      releaseDate: "December 10, 2020",
      rating: "Mature"
    }
  },
  {
    id: 16,
    title: "Assassin's Creed Valhalla",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/16_p8x9uf.jpg",
    genre: "Action RPG",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Become a legendary Viking raider, exploring medieval England while forging alliances and engaging in brutal battles to build your clan.",
    price: "₹999",
    About: "Assassin's Creed Valhalla immerses players in the Viking era, blending action, stealth, and immersive storytelling. Players assume the role of Eivor and explore a richly detailed world while establishing settlements and engaging in epic Norse battles. The game focuses on player choice and the consequences of decisions throughout the narrative.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Action RPG",
      developer: "Ubisoft Montreal",
      publisher: "Ubisoft",
      releaseDate: "November 10, 2020",
      rating: "Mature"
    }
  },
  {
    id: 17,
    title: "Doom Eternal",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117412/17_t8zbgf.jpg",
    genre: "First-Person Shooter",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Unleash your inner demon slayer in this fast-paced FPS, packed with adrenaline-pumping action and over-the-top combat mechanics.",
    price: "₹499",
    About: "Doom Eternal is a relentless FPS that follows the Doom Slayer on a quest to save humanity against demonic forces. With a combination of fluid movement, strategic combat, and an immersive arsenal of weapons, players experience a high-octane adventure filled with intense encounters and chaotic battles.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "First-Person Shooter",
      developer: "id Software",
      publisher: "Bethesda Softworks",
      releaseDate: "March 20, 2020",
      rating: "Mature"
    }
  },
  {
    id: 18,
    title: "Resident Evil Village",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117412/18_u9j8k5.jpg",
    genre: "Survival Horror",
    platform: "Xbox Series X|S, PC",
    exclusive: true,
    description: "Survive in a mysterious village filled with terrifying creatures as you unravel the story of Ethan Winters in this gripping horror experience.",
    price: "₹599",
    About: "Resident Evil Village immerses players in a chilling survival horror narrative, continuing the story of Ethan Winters as he confronts terrifying foes. The game blends action and horror, creating a gripping atmosphere with beautiful graphics and intense gameplay. Players navigate through mysterious environments filled with secrets and danger.",
    productspecification: {
      platform: "Xbox Series X|S, PC",
      genre: "Survival Horror",
      developer: "Capcom",
      publisher: "Capcom",
      releaseDate: "May 7, 2021",
      rating: "Mature"
    }
  },
  {
    id: 19,
    title: "Madden NFL 22",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/19_boyadn.jpg",
    genre: "Sports",
    platform: "Xbox Series X|S, Xbox One, PC",
    exclusive: true,
    description: "Experience the thrill of NFL football with realistic gameplay and new modes that bring you closer to being a football manager and player.",
    price: "₹599",
    About: "Madden NFL 22 brings the excitement of professional football to players, emphasizing realism and strategic gameplay. The game features enhanced mechanics, various modes including Franchise and Ultimate Team, and allows players to customize their teams and strategies, creating an immersive sports experience.",
    productspecification: {
      platform: "Xbox Series X|S, Xbox One, PC",
      genre: "Sports",
      developer: "EA Tiburon",
      publisher: "Electronic Arts",
      releaseDate: "August 20, 2021",
      rating: "For Everyone"
    }
  },
  {
    id: 20,
    title: "NBA 2K21",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/20_lkpbxv.webp",
    genre: "Sports",
    platform: "Xbox Series X|S, Xbox One, PC",
    exclusive: true,
    description: "Step onto the court in this highly acclaimed basketball simulation, featuring stunning graphics and deep roster management for fans and players.",
    price: "₹899",
    About: "NBA 2K21 delivers a highly realistic basketball simulation, complete with stunning graphics, deep gameplay mechanics, and various modes that cater to basketball fans. Players can enjoy online competitions, manage rosters, and experience the thrill of the court, all while experiencing high-quality storytelling in MyCareer mode.",
    productspecification: {
      platform: "Xbox Series X|S, Xbox One, PC",
      genre: "Sports",
      developer: "Visual Concepts",
      publisher: "2K Sports",
      releaseDate: "September 4, 2020",
      rating: "For Everyone"
    }
  }
];

// const xboxfeaturedgames = [
//   {
//     id: 1,
//     title: "Halo Infinite",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/1_yi33wt.jpg",
//     genre: "First-Person Shooter",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Explore the expansive rings of Halo as Master Chief in a gripping campaign and engage in exhilarating multiplayer battles.",
//     price: "₹1599"
//   },
//   {
//     id: 2,
//     title: "Forza Horizon 5",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/2_zzwo6z.jpg",
//     genre: "Racing",
//     platform: "Xbox Series X|S, Xbox One, PC",
//     exclusive: true,
//     description: "Experience the vibrant landscapes of Mexico in this open-world racing game, featuring a diverse car roster and dynamic seasons.",
//     price: "₹1699"
//   },
//   {
//     id: 3,
//     title: "Starfield",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/3_fsdvup.jpg",
//     genre: "Action RPG",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Embark on an epic space exploration journey in this role-playing game set in a vast universe filled with unique worlds and factions.",
//     price: "₹1699"
//   },
//   {
//     id: 4,
//     title: "Fable",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/4_soyiab.jpg",
//     genre: "Action RPG",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Rediscover the magical world of Albion in this reimagined RPG, where your choices shape your character and the fate of the land.",
//     price: "₹1599"
//   },
//   {
//     id: 5,
//     title: "Perfect Dark",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/5_y1ftyl.jpg",
//     genre: "Action Adventure",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Take on the role of agent Joanna Dark in this stealth-driven shooter, blending thrilling espionage with futuristic technology.",
//     price: "₹1699"
//   },
//   {
//     id: 6,
//     title: "Microsoft Flight Simulator",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/6_firpwj.jpg",
//     genre: "Simulation",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Experience the most realistic flying simulation ever, featuring real-world mapping and weather for an unparalleled pilot experience.",
//     price: "₹699"
//   },
//   {
//     id: 7,
//     title: "Gears 5",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/7_rsa4b9.png",
//     genre: "Third-Person Shooter",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Join the fight against a deadly new enemy in this cooperative shooter, featuring rich storytelling and intense multiplayer action.",
//     price: "₹1399"
//   },
//   {
//     id: 8,
//     title: "Sea of Thieves",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/8_wfgany.jpg",
//     genre: "Action-Adventure",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Become a pirate legend as you explore a shared world, engage in ship battles, and hunt for treasure with friends or alone.",
//     price: "₹1599"
//   },
//   {
//     id: 9,
//     title: "Grounded",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117410/9_qsopfs.jpg",
//     genre: "Survival",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Shrink down to the size of an ant and survive in a backyard filled with dangers, crafting tools and building bases with friends.",
//     price: "₹2999"
//   },
//   {
//     id: 10,
//     title: "State of Decay 2",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/10_udjegv.jpg",
//     genre: "Zombie Survival",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Build your community and survive against hordes of zombies in this strategic survival game, making tough decisions for your group's future.",
//     price: "₹1,399"
//   },
//   {
//     id: 11,
//     title: "Ori and the Will of the Wisps",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/11_l4zlfc.jpg",
//     genre: "Platformer",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Experience a visually stunning platformer that weaves an emotional tale of friendship and sacrifice through challenging puzzles and exploration.",
//     price: "₹1299"
//   },
//   {
//     id: 12,
//     title: "Psychonauts 2",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117408/12_k3zsox.jpg",
//     genre: "Platformer",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Dive into the minds of unique characters in this whimsical platformer, unraveling mysteries while exploring imaginative worlds.",
//     price: "₹1399"
//   },
//   {
//     id: 13,
//     title: "The Medium",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117409/13_ipxpst.jpg",
//     genre: "Psychological Horror",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Explore a haunting dual-reality world as a medium with psychic abilities, uncovering dark secrets and confronting supernatural threats.",
//     price: "₹1999"
//   },
//   {
//     id: 14,
//     title: "Elden Ring",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117415/14_rdgvpo.jpg",
//     genre: "Action RPG",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Unravel the mysteries of the Elden Ring in this expansive open-world RPG, filled with rich lore, challenging foes, and deep exploration.",
//     price: "₹1699"
//   },
//   {
//     id: 15,
//     title: "Cyberpunk 2077",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117411/15_iob4b8.jpg",
//     genre: "Action RPG",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Step into the dystopian Night City where choices matter, customizing your character and facing treacherous challenges in a high-tech world.",
//     price: "₹1599"
//   },
//   {
//     id: 16,
//     title: "Assassin's Creed Valhalla",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/16_p8x9uf.jpg",
//     genre: "Action RPG",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Become a legendary Viking raider, exploring medieval England while forging alliances and engaging in brutal battles to build your clan.",
//     price: "₹999"
//   },
//   {
//     id: 17,
//     title: "Doom Eternal",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117412/17_t8zbgf.jpg",
//     genre: "First-Person Shooter",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Unleash your inner demon slayer in this fast-paced FPS, packed with adrenaline-pumping action and over-the-top combat mechanics.",
//     price: "₹499"
//   },
//   {
//     id: 18,
//     title: "Resident Evil Village",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117412/18_u9j8k5.jpg",
//     genre: "Survival Horror",
//     platform: "Xbox Series X|S, PC",
//     exclusive: true,
//     description: "Survive in a mysterious village filled with terrifying creatures as you unravel the story of Ethan Winters in this gripping horror experience.",
//     price: "₹599"
//   },
//   {
//     id: 19,
//     title: "Madden NFL 22",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/19_boyadn.jpg",
//     genre: "Sports",
//     platform: "Xbox Series X|S, Xbox One, PC",
//     exclusive: true,
//     description: "Experience the thrill of NFL football with realistic gameplay and new modes that bring you closer to being a football manager and player.",
//     price: "₹599"
//   },
//   {
//     id: 20,
//     title: "NBA 2K21",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744117413/20_lkpbxv.webp",
//     genre: "Sports",
//     platform: "Xbox Series X|S, Xbox One, PC",
//     exclusive: true,
//     description: "Step onto the court in this highly acclaimed basketball simulation, featuring stunning graphics and deep roster management for fans and players.",
//     price: "₹899"
//   },
// ];

const Uploadxboxfeaturedgames = () => {
  
  const clearExistingData = async () => {
    const collectionRef = collection(db, 'xboxfeaturedgames');
    const querySnapshot = await getDocs(collectionRef);
    querySnapshot.forEach(async (docSnapshot) => {
      await deleteDoc(doc(db, 'xboxfeaturedgames', docSnapshot.id));
    });
  };


  const uploadData = async () => {
    try {
      await clearExistingData(); 
      const collectionRef = collection(db, 'xboxfeaturedgames');

      for (const bundle of xboxfeaturedgames) {
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

export default Uploadxboxfeaturedgames;
