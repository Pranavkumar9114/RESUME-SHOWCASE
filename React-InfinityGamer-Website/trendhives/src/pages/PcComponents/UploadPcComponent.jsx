// UploadPcComponentCategories.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../firebase';

const PcComponentCategories = [
  {
    id: 1,
    name: "CPUs",
    icon: "⚡",
    products: [
      {
        id: 1,
        name: "Quantum Core i9-13900K",
        price: "₹59999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/1_cyyflp.jpg",
        specs: "16 cores, 5.8GHz, 36MB Cache",
        description: "High-performance CPU for gaming and multitasking.",
        About: "The Quantum Core i9-13900K is designed for elite gamers and content creators seeking unmatched performance. With 16 cores and clock speeds of up to 5.8GHz, it delivers remarkable multi-threading capabilities, making it perfect for demanding applications. The CPU excels in intensive tasks such as gaming, streaming, and content production.",
        productspecification: {
          baseClock: "3.0GHz",
          turboBoost: "5.8GHz",
          cores: "16",
          threads: "24",
          cache: "36MB",
          TDP: "125W",
          architecture: "Intel 7",
          warranty: "3 Years"
        }
      },
      {
        id: 2,
        name: "Ryzen 9 7950X",
        price: "₹54999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/2_nevt44.jpg",
        specs: "16 cores, 5.7GHz, 64MB Cache",
        description: "Powerful processor with excellent gaming capabilities.",
        About: "The Ryzen 9 7950X is AMD's flagship processor, offering exceptional gaming performance along with superior multitasking abilities. With 16 cores and a boost clock of 5.7GHz, it appeals to gamers, creators, and professionals looking for uncompromising power in every task.",
        productspecification: {
          baseClock: "4.5GHz",
          turboBoost: "5.7GHz",
          cores: "16",
          threads: "32",
          cache: "64MB",
          TDP: "170W",
          architecture: "Zen 4",
          warranty: "3 Years"
        }
      },
      {
        id: 3,
        name: "Quantum Core i7-13700K",
        price: "₹40999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/3_xh0yvq.jpg",
        specs: "16 cores, 5.4GHz, 30MB Cache",
        description: "Ideal for gamers and content creators.",
        About: "The Quantum Core i7-13700K delivers stellar performance for gaming and content creation. With 16 cores and impressive clock speeds, it handles both light and intensive tasks effortlessly. It provides excellent value for gamers who also undertake demanding workloads.",
        productspecification: {
          baseClock: "3.4GHz",
          turboBoost: "5.4GHz",
          cores: "16",
          threads: "24",
          cache: "30MB",
          TDP: "125W",
          architecture: "Intel 7",
          warranty: "3 Years"
        }
      },
      {
        id: 4,
        name: "Ryzen 7 5800X",
        price: "₹29999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/4_expbgf.jpg",
        specs: "8 cores, 4.7GHz, 32MB Cache",
        description: "Excellent performance for most applications.",
        About: "The Ryzen 7 5800X is a versatile processor designed for gamers and professionals alike. With 8 cores, a 4.7GHz boost clock, and strong multi-threading capabilities, it meets the demands of both gaming and productivity seamlessly.",
        productspecification: {
          baseClock: "3.8GHz",
          turboBoost: "4.7GHz",
          cores: "8",
          threads: "16",
          cache: "32MB",
          TDP: "105W",
          architecture: "Zen 3",
          warranty: "3 Years"
        }
      },
      {
        id: 5,
        name: "Intel Core i5-12600K",
        price: "₹28999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134590/5_v381pv.jpg",
        specs: "10 cores, 4.9GHz, 20MB Cache",
        description: "Great value for mid-range gaming builds.",
        About: "The Intel Core i5-12600K offers an excellent balance of performance and price for gamers looking to build mid-range systems. With 10 cores and a turbo boost of 4.9GHz, it excels in gaming while also being capable of handling multitasking and productivity tasks.",
        productspecification: {
          baseClock: "3.7GHz",
          turboBoost: "4.9GHz",
          cores: "10",
          threads: "16",
          cache: "20MB",
          TDP: "125W",
          architecture: "Intel 7",
          warranty: "3 Years"
        }
      },
      {
        id: 6,
        name: "Ryzen 5 5600X",
        price: "₹19999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134591/6_jcun7u.jpg",
        specs: "6 cores, 4.6GHz, 32MB Cache",
        description: "Outstanding performance for budget-friendly setups.",
        About: "The Ryzen 5 5600X is a remarkable CPU for budget setups, offering 6 cores and a maximum boost of 4.6GHz. It provides strong performance for both gaming and everyday tasks, making it an ideal choice for cost-conscious gamers.",
        productspecification: {
          baseClock: "3.7GHz",
          turboBoost: "4.6GHz",
          cores: "6",
          threads: "12",
          cache: "32MB",
          TDP: "65W",
          architecture: "Zen 3",
          warranty: "3 Years"
        }
      },
      {
        id: 7,
        name: "Intel Core i3-12100F",
        price: "₹13999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134592/7_wtrsu6.webp",
        specs: "4 cores, 4.3GHz, 12MB Cache",
        description: "Entry-level CPU suitable for basic tasks.",
        About: "The Intel Core i3-12100F is an excellent entry-level processor ideal for basic computing tasks and light gaming. With 4 cores and solid clock speeds, it delivers sufficient power for casual users and budget builds.",
        productspecification: {
          baseClock: "3.3GHz",
          turboBoost: "4.3GHz",
          cores: "4",
          threads: "8",
          cache: "12MB",
          TDP: "60W",
          architecture: "Intel 7",
          warranty: "3 Years"
        }
      },
      {
        id: 8,
        name: "Xeon W-1290P",
        price: "₹79999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134592/8_hf3oue.webp",
        specs: "10 cores, 5.3GHz, 20MB Cache",
        description: "Designed for workstations and professional use.",
        About: "The Xeon W-1290P is built for workstation use, offering 10 high-performance cores and excellent clock speeds for demanding applications. It is ideal for professionals requiring strong multi-threading performance and high reliability.",
        productspecification: {
          baseClock: "3.3GHz",
          turboBoost: "5.3GHz",
          cores: "10",
          threads: "20",
          cache: "20MB",
          TDP: "125W",
          architecture: "Ice Lake",
          warranty: "3 Years"
        }
      },
      {
        id: 9,
        name: "AMD Athlon 3000G",
        price: "₹4999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134593/9_ua7j8g.jpg",
        specs: "2 cores, 3.5GHz, 192KB Cache",
        description: "Affordable option for basic computing needs.",
        About: "The AMD Athlon 3000G is an excellent choice for budget builds, providing reliable performance for basic tasks with its dual-core design. It’s suitable for everyday computing, such as web browsing and document editing.",
        productspecification: {
          baseClock: "3.5GHz",
          cores: "2",
          threads: "4",
          cache: "192KB",
          TDP: "35W",
          architecture: "Zen",
          warranty: "3 Years"
        }
      },
      {
        id: 10,
        name: "Intel Pentium Gold G5600",
        price: "₹7999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134594/10_vd5cfa.jpg",
        specs: "2 cores, 4.0GHz, 4MB Cache",
        description: "Reliable performance for everyday tasks.",
        About: "The Intel Pentium Gold G5600 offers solid performance for basic tasks and light computing. With dual cores and a maximum clock speed of 4.0GHz, it ensures smooth operation for everyday applications.",
        productspecification: {
          baseClock: "3.9GHz",
          cores: "2",
          threads: "4",
          cache: "4MB",
          TDP: "54W",
          architecture: "Coffee Lake",
          warranty: "3 Years"
        }
      },
    ],
  },
  {
    id: 2,
    name: "GPUs",
    icon: "🎮",
    products: [
      {
        id: 11,
        name: "RTX 4090 Ti Supernova",
        price: "₹199999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134595/11_kzmfpq.webp",
        specs: "24GB GDDR6X, 2.6GHz, 16384 CUDA",
        description: "Ultimate graphics card for gaming at 4K.",
        About: "The RTX 4090 Ti Supernova is NVIDIA’s flagship graphics card, designed for the absolute best in gaming performance. With 24GB of GDDR6X memory and advanced ray tracing capabilities, it guarantees stunning visuals and seamless gameplay even at 4K resolutions.",
        productspecification: {
          memory: "24GB GDDR6X",
          coreClock: "2.6GHz",
          CUDA_Cores: "16384",
          TDP: "450W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 12,
        name: "RX 7900 XTX Phantom",
        price: "₹119999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134596/12_gfkrfx.jpg",
        specs: "24GB GDDR6, 2.5GHz, Ray Tracing",
        description: "High-performance GPU for immersive gaming experience.",
        About: "The RX 7900 XTX Phantom offers incredible performance for high-end gaming. With 24GB of GDDR6 memory and hardware-accelerated ray tracing, it provides breathtaking graphics and smooth framerates for immersive gameplay.",
        productspecification: {
          memory: "24GB GDDR6",
          coreClock: "2.5GHz",
          rayTracing: "Yes",
          TDP: "350W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 13,
        name: "RTX 4080 Ultra",
        price: "₹129999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134596/13_edwkdp.jpg",
        specs: "16GB GDDR6X, 2.5GHz, 9728 CUDA",
        description: "Premium GPU with excellent performance for gamers.",
        About: "The RTX 4080 Ultra delivers exceptional performance for gaming enthusiasts. Featuring 16GB of GDDR6X memory and ray tracing technology, it allows for high-quality rendering and immersive gaming experiences.",
        productspecification: {
          memory: "16GB GDDR6X",
          coreClock: "2.5GHz",
          CUDA_Cores: "9728",
          TDP: "320W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 14,
        name: "RX 6800 XT Beast",
        price: "₹89999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134608/14_cojbay.jpg",
        specs: "16GB GDDR6, 2.5GHz, Ray Tracing",
        description: "Exceptional graphics card for high-end gaming.",
        About: "The RX 6800 XT Beast is designed for performance seekers, featuring 16GB GDDR6 memory and support for ray tracing. It excels in high-resolution gaming and is optimized for smooth gameplay in the latest titles.",
        productspecification: {
          memory: "16GB GDDR6",
          coreClock: "2.5GHz",
          rayTracing: "Yes",
          TDP: "300W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 15,
        name: "RTX 3070 Ti Blaster",
        price: "₹69999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134607/18_i8fkaq.png",
        specs: "8GB GDDR6, 1.6GHz, 6144 CUDA",
        description: "Strong performance for both 1440p and 1080p.",
        About: "The RTX 3070 Ti Blaster offers flexibility for gamers with its strong performance in both 1440p and 1080p resolutions. Equipped with 8GB of GDDR6 memory, it handles demanding games smoothly for a fantastic gaming experience.",
        productspecification: {
          memory: "8GB GDDR6",
          coreClock: "1.6GHz",
          CUDA_Cores: "6144",
          TDP: "290W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 16,
        name: "RX 6700 XT Shadow",
        price: "₹47999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134613/16_gpmwjs.jpg",
        specs: "12GB GDDR6, 2.5GHz, Ray Tracing",
        description: "Great mid-range card for gaming at high settings.",
        About: "The RX 6700 XT Shadow is a powerful mid-range graphics card that excels in high settings for most games. With 12GB of GDDR6 memory and ray tracing capabilities, it delivers incredible visuals and performance for a varied gaming experience.",
        productspecification: {
          memory: "12GB GDDR6",
          coreClock: "2.5GHz",
          rayTracing: "Yes",
          TDP: "230W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
      {
        id: 17,
        name: "GTX 1660 Super",
        price: "₹24999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134601/17_liwvuu.jpg",
        specs: "6GB GDDR6, 1.8GHz, 1408 CUDA",
        description: "Excellent budget-friendly GPU for casual gamers.",
        About: "The GTX 1660 Super provides solid gaming performance without breaking the bank. With 6GB of GDDR6 memory and decent clock speeds, it's suitable for casual gamers who play less demanding titles.",
        productspecification: {
          memory: "6GB GDDR6",
          coreClock: "1.8GHz",
          CUDA_Cores: "1408",
          TDP: "125W",
          connectivity: "PCIe 3.0",
          warranty: "3 Years"
        }
      },
      {
        id: 18,
        name: "GTX 1650 Ti",
        price: "₹17999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134607/18_i8fkaq.png",
        specs: "4GB GDDR6, 1.5GHz, 896 CUDA",
        description: "Affordable GPU suitable for eSports titles.",
        About: "The GTX 1650 Ti is an affordable option for gamers interested in eSports titles. Providing decent performance with 4GB of GDDR6 memory, it ensures smooth gameplay in competitive games.",
        productspecification: {
          memory: "4GB GDDR6",
          coreClock: "1.5GHz",
          CUDA_Cores: "896",
          TDP: "75W",
          connectivity: "PCIe 3.0",
          warranty: "3 Years"
        }
      },
      {
        id: 19,
        name: "GTX 1050 Ti",
        price: "₹14999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134604/19_fe42n8.jpg",
        specs: "4GB GDDR5, 1.4GHz, 768 CUDA",
        description: "Entry-level GPU perfect for budget builds.",
        About: "The GTX 1050 Ti is a great entry-level GPU for budget-friendly builds. With 4GB of GDDR5 memory, it allows gamers to enjoy a variety of titles at lower settings.",
        productspecification: {
          memory: "4GB GDDR5",
          coreClock: "1.4GHz",
          CUDA_Cores: "768",
          TDP: "75W",
          connectivity: "PCIe 3.0",
          warranty: "3 Years"
        }
      },
      {
        id: 20,
        name: "RTX 3060",
        price: "₹35999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134631/20_ijihq5.jpg",
        specs: "12GB GDDR6, 1.7GHz, 3584 CUDA",
        description: "Great choice for 1080p gaming at high settings.",
        About: "The RTX 3060 is designed for 1080p gaming at high settings, equipped with 12GB of GDDR6 memory and competent ray tracing capabilities which provide a great gaming experience in modern titles.",
        productspecification: {
          memory: "12GB GDDR6",
          coreClock: "1.7GHz",
          CUDA_Cores: "3584",
          TDP: "170W",
          connectivity: "PCIe 4.0",
          warranty: "3 Years"
        }
      },
    ],
  },
  {
    id: 3,
    name: "RAM",
    icon: "💾",
    products: [
      {
        id: 21,
        name: "HyperX Fury DDR5-6000",
        price: "₹18999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134612/21_raqewo.jpg",
        specs: "32GB (2x16GB), CL36, RGB",
        description: "Fast RAM perfect for gaming and multitasking.",
        About: "HyperX Fury DDR5-6000 offers gamers and creators high-speed performance with RGB lighting. This DDR5 memory kit ensures optimal gaming experiences with its low latency and efficient bandwidth, making multitasking a breeze.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR5",
          speed: "6000MT/s",
          latency: "CL36",
          warranty: "Lifetime"
        }
      },
      {
        id: 22,
        name: "Corsair Dominator DDR5-7200",
        price: "₹24999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/22_qnhfgb.png",
        specs: "32GB (2x16GB), CL34, RGB",
        description: "High-speed memory for extreme performance.",
        About: "Corsair Dominator DDR5-7200 is engineered for extreme performance, featuring aggressive speeds and stunning RGB lighting. It’s perfect for gamers seeking unparalleled responsiveness in their systems.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR5",
          speed: "7200MT/s",
          latency: "CL34",
          warranty: "Lifetime"
        }
      },
      {
        id: 23,
        name: "G.Skill Trident Z5 DDR5-6400",
        price: "₹21999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/23_exsqm6.jpg",
        specs: "32GB (2x16GB), CL32, RGB",
        description: "Designed for overclocking enthusiasts and gamers.",
        About: "G.Skill Trident Z5 DDR5-6400 is crafted for overclocking enthusiasts, providing outstanding speeds and stunning aesthetics. If you're looking to push your performance limits, this RAM delivers exceptional reliability.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR5",
          speed: "6400MT/s",
          latency: "CL32",
          warranty: "Lifetime"
        }
      },
      {
        id: 24,
        name: "Corsair Vengeance LPX 16GB DDR4-3200",
        price: "₹8999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134613/24_c3tam2.jpg",
        specs: "16GB (1x16GB), CL16",
        description: "Solid choice for gaming and general use.",
        About: "Corsair Vengeance LPX is designed for high performance in both gaming and general use. This 16GB DDR4 RAM provides excellent value while maintaining stability and reliability.",
        productspecification: {
          capacity: "16GB (1x16GB)",
          type: "DDR4",
          speed: "3200MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
      {
        id: 25,
        name: "G.Skill Ripjaws V 16GB DDR4-3600",
        price: "₹9999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134614/25_ft4x1t.jpg",
        specs: "16GB (1x16GB), CL16",
        description: "Reliable performance for demanding applications.",
        About: "G.Skill Ripjaws V series offers robust performance for demanding applications, ensuring stability even under heavy loads. This 16GB DDR4-3600 memory can help you stay competitive in fast-paced gaming.",
        productspecification: {
          capacity: "16GB (1x16GB)",
          type: "DDR4",
          speed: "3600MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
      {
        id: 26,
        name: "Crucial Ballistix 32GB DDR4-3200",
        price: "₹12999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/26_aywh5a.jpg",
        specs: "32GB (2x16GB), CL16",
        description: "Great for multitasking and gaming needs.",
        About: "Crucial Ballistix memory provides great multitasking capabilities and is well-suited for gaming setups. The 32GB capacity ensures smoother performance across demanding applications.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR4",
          speed: "3200MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
      {
        id: 27,
        name: "Patriot Viper Steel 16GB DDR4-3600",
        price: "₹7999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134621/27_imgrmp.jpg",
        specs: "16GB (1x16GB), CL17",
        description: "Affordable RAM with great performance.",
        About: "Patriot Viper Steel offers an affordable price tag without compromising quality. This 16GB DDR4-3600 memory is perfect for gamers looking for reliable performance on a budget.",
        productspecification: {
          capacity: "16GB (1x16GB)",
          type: "DDR4",
          speed: "3600MT/s",
          latency: "CL17",
          warranty: "Lifetime"
        }
      },
      {
        id: 28,
        name: "Corsair Vengeance 32GB DDR4-2933",
        price: "₹10999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/28_q1vijt.jpg",
        specs: "32GB (2x16GB), CL16",
        description: "High capacity memory for heavy workloads.",
        About: "The Corsair Vengeance 32GB DDR4-2933 is geared towards heavy workloads and multitasking. It provides ample memory capacity to handle demanding applications and games effortlessly.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR4",
          speed: "2933MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
      {
        id: 29,
        name: "Kingston Fury Beast 16GB DDR4-3200",
        price: "₹8999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134622/29_wxoyih.jpg",
        specs: "16GB (2x8GB), CL16",
        description: "Good performance for gaming and productivity.",
        About: "Kingston Fury Beast memory is optimized for both gaming and productivity, offering solid performance at an attractive price. This 16GB kit is perfect for users wanting to build a balanced system.",
        productspecification: {
          capacity: "16GB (2x8GB)",
          type: "DDR4",
          speed: "3200MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
      {
        id: 30,
        name: "Team T-Force Vulcan Z 32GB DDR4-3200",
        price: "₹11999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134625/30_v8ejiv.jpg",
        specs: "32GB (2x16GB), CL16",
        description: "Excellent performance for high-demand tasks.",
        About: "Team T-Force Vulcan Z RAM is designed for high-demand tasks, offering a reliable and fast experience. The 32GB capacity makes it suitable for gamers, content creators, and power users alike.",
        productspecification: {
          capacity: "32GB (2x16GB)",
          type: "DDR4",
          speed: "3200MT/s",
          latency: "CL16",
          warranty: "Lifetime"
        }
      },
    ],
  },
  {
    id: 4,
    name: "Storage",
    icon: "💿",
    products: [
      {
        id: 31,
        name: "Samsung 990 PRO",
        price: "₹22999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134622/31_dbavte.jpg",
        specs: "2TB, PCIe 4.0, 7000MB/s Read",
        description: "High-speed NVMe SSD for demanding users.",
        About: "Samsung 990 PRO is a leading NVMe SSD, providing top-tier speeds and reliability. With 2TB capacity and extremely fast read/write speeds, it’s perfect for gamers and professionals needing fast data access.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "7000MB/s",
          writeSpeed: "5000MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 32,
        name: "WD Black SN850X",
        price: "19999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134629/32_c96ksa.png",
        specs: "2TB, PCIe 4.0, 7300MB/s Read",
        description: "Top-tier gaming SSD with blazing speeds.",
        About: "WD Black SN850X offers exceptional performance for gaming enthusiasts. With read speeds up to 7300MB/s and a 2TB capacity, it gives you the advantage you need in high-demand gaming environments.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "7300MB/s",
          writeSpeed: "5300MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 33,
        name: "Crucial P5 Plus",
        price: "₹17999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134632/33_noe8qn.png",
        specs: "2TB, PCIe 4.0, 6600MB/s Read",
        description: "Affordable NVMe SSD with excellent performance.",
        About: "The Crucial P5 Plus is an affordable NVMe SSD, balancing performance and price. With read speeds reaching up to 6600MB/s, it’s a reliable choice for gamers and everyday users.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "6600MB/s",
          writeSpeed: "5000MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 34,
        name: "Seagate FireCuda 530",
        price: "₹24999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134625/34_jnu2uv.jpg",
        specs: "2TB, PCIe 4.0, 7300MB/s Read",
        description: "Designed for gamers with high-speed data needs.",
        About: "The Seagate FireCuda 530 is engineered specifically for gamers, offering highest speeds for gaming and content creation. With its robust build and 2TB capacity, it ensures you never run out of space during critical plays.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "7300MB/s",
          writeSpeed: "6900MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 35,
        name: "ADATA XPG Gammix S70",
        price: "₹19999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134624/35_hf2ruz.jpg",
        specs: "2TB, PCIe 4.0, 7400MB/s Read",
        description: "Excellent performance for gaming and storage.",
        About: "ADATA XPG Gammix S70 SSD guarantees speedy performance and adept handling of large files, making it ideal for gaming and data-heavy applications where performance is critical.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "7400MB/s",
          writeSpeed: "6400MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 36,
        name: "Kingston KC3000",
        price: "₹28999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134626/36_vrednh.jpg",
        specs: "2TB, PCIe 4.0, 7000MB/s Read",
        description: "High-capacity SSD for demanding professionals.",
        About: "Kingston KC3000 is designed for professionals who need high-capacity storage with blazing fast speeds. It is capable of handling heavy workloads and delivering top-tier performance in creative tasks.",
        productspecification: {
          capacity: "2TB",
          interface: "PCIe 4.0",
          readSpeed: "7000MB/s",
          writeSpeed: "5000MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 37,
        name: "Crucial MX500",
        price: "₹10999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/37_wijybi.webp",
        specs: "1TB, SATA III, 560MB/s Read",
        description: "Reliable SATA SSD for performance upgrades.",
        About: "Crucial MX500 delivers solid performance for SATA III SSDs, providing a reliable upgrade for traditional hard drives or aging SSDs. The 1TB capacity ensures ample space for various data.",
        productspecification: {
          capacity: "1TB",
          interface: "SATA III",
          readSpeed: "560MB/s",
          writeSpeed: "510MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 38,
        name: "Samsung 860 EVO",
        price: "₹12999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/38_l2rwyn.jpg",
        specs: "1TB, SATA III, 550MB/s Read",
        description: "Proven performer for SSD upgrades.",
        About: "The Samsung 860 EVO is a proven and reliable SSD that provides seamless performance for upgrades, ensuring fast data access and durability for your gaming or work needs.",
        productspecification: {
          capacity: "1TB",
          interface: "SATA III",
          readSpeed: "550MB/s",
          writeSpeed: "520MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 39,
        name: "Western Digital Blue SN570",
        price: "₹8999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134627/39_bw6zwc.jpg",
        specs: "1TB, M.2 NVMe, 3000MB/s Read",
        description: "Budget-friendly NVMe SSD with solid performance.",
        About: "Western Digital Blue SN570 offers users an affordable NVMe SSD that doesn't compromise on speed. A great choice for cost-conscious users who want to improve their system's performance.",
        productspecification: {
          capacity: "1TB",
          interface: "M.2 NVMe",
          readSpeed: "3000MB/s",
          writeSpeed: "2100MB/s",
          warranty: "5 Years"
        }
      },
      {
        id: 40,
        name: "SanDisk Ultra 3D SSD",
        price: "₹10999",
        image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/40_q4odic.webp",
        specs: "1TB, SATA III, 560MB/s Read",
        description: "Affordable SSD for enhanced storage speed.",
        About: "SanDisk Ultra 3D SSD provides fantastic performance enhancements for storage at an accessible price point. Ideal for daily tasks and gaming, it combines reliability with solid speed.",
        productspecification: {
          capacity: "1TB",
          interface: "SATA III",
          readSpeed: "560MB/s",
          writeSpeed: "530MB/s",
          warranty: "3 Years"
        }
      },
    ],
  },
];

// const PcComponentCategories = [
//   {
//     id: 1,
//     name: "CPUs",
//     icon: "⚡",
//     products: [
//       {
//         id: 1,
//         name: "Quantum Core i9-13900K",
//         price: "₹59999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/1_cyyflp.jpg",
//         specs: "16 cores, 5.8GHz, 36MB Cache",
//         description: "High-performance CPU for gaming and multitasking."
//       },
//       {
//         id: 2,
//         name: "Ryzen 9 7950X",
//         price: "₹54999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/2_nevt44.jpg",
//         specs: "16 cores, 5.7GHz, 64MB Cache",
//         description: "Powerful processor with excellent gaming capabilities."
//       },
//       {
//         id: 3,
//         name: "Quantum Core i7-13700K",
//         price: "₹40999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/3_xh0yvq.jpg",
//         specs: "16 cores, 5.4GHz, 30MB Cache",
//         description: "Ideal for gamers and content creators."
//       },
//       {
//         id: 4,
//         name: "Ryzen 7 5800X",
//         price: "₹29999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134589/4_expbgf.jpg",
//         specs: "8 cores, 4.7GHz, 32MB Cache",
//         description: "Excellent performance for most applications."
//       },
//       {
//         id: 5,
//         name: "Intel Core i5-12600K",
//         price: "₹28999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134590/5_v381pv.jpg",
//         specs: "10 cores, 4.9GHz, 20MB Cache",
//         description: "Great value for mid-range gaming builds."
//       },
//       {
//         id: 6,
//         name: "Ryzen 5 5600X",
//         price: "₹19999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134591/6_jcun7u.jpg",
//         specs: "6 cores, 4.6GHz, 32MB Cache",
//         description: "Outstanding performance for budget-friendly setups."
//       },
//       {
//         id: 7,
//         name: "Intel Core i3-12100F",
//         price: "₹13999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134592/7_wtrsu6.webp",
//         specs: "4 cores, 4.3GHz, 12MB Cache",
//         description: "Entry-level CPU suitable for basic tasks."
//       },
//       {
//         id: 8,
//         name: "Xeon W-1290P",
//         price: "₹79999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134592/8_hf3oue.webp",
//         specs: "10 cores, 5.3GHz, 20MB Cache",
//         description: "Designed for workstations and professional use."
//       },
//       {
//         id: 9,
//         name: "AMD Athlon 3000G",
//         price: "₹4999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134593/9_ua7j8g.jpg",
//         specs: "2 cores, 3.5GHz, 192KB Cache",
//         description: "Affordable option for basic computing needs."
//       },
//       {
//         id: 10,
//         name: "Intel Pentium Gold G5600",
//         price: "₹7999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134594/10_vd5cfa.jpg",
//         specs: "2 cores, 4.0GHz, 4MB Cache",
//         description: "Reliable performance for everyday tasks."
//       },
//     ],
//   },
//   {
//     id: 2,
//     name: "GPUs",
//     icon: "🎮",
//     products: [
//       {
//         id: 11,
//         name: "RTX 4090 Ti Supernova",
//         price: "₹199999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134595/11_kzmfpq.webp",
//         specs: "24GB GDDR6X, 2.6GHz, 16384 CUDA",
//         description: "Ultimate graphics card for gaming at 4K."
//       },
//       {
//         id: 12,
//         name: "RX 7900 XTX Phantom",
//         price: "₹119999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134596/12_gfkrfx.jpg",
//         specs: "24GB GDDR6, 2.5GHz, Ray Tracing",
//         description: "High-performance GPU for immersive gaming experience."
//       },
//       {
//         id: 13,
//         name: "RTX 4080 Ultra",
//         price: "₹129999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134596/13_edwkdp.jpg",
//         specs: "16GB GDDR6X, 2.5GHz, 9728 CUDA",
//         description: "Premium GPU with excellent performance for gamers."
//       },
//       {
//         id: 14,
//         name: "RX 6800 XT Beast",
//         price: "₹89999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134608/14_cojbay.jpg",
//         specs: "16GB GDDR6, 2.5GHz, Ray Tracing",
//         description: "Exceptional graphics card for high-end gaming."
//       },
//       {
//         id: 15,
//         name: "RTX 3070 Ti Blaster",
//         price: "₹69999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134607/18_i8fkaq.png",
//         specs: "8GB GDDR6, 1.6GHz, 6144 CUDA",
//         description: "Strong performance for both 1440p and 1080p."
//       },
//       {
//         id: 16,
//         name: "RX 6700 XT Shadow",
//         price: "₹47999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134613/16_gpmwjs.jpg",
//         specs: "12GB GDDR6, 2.5GHz, Ray Tracing",
//         description: "Great mid-range card for gaming at high settings."
//       },
//       {
//         id: 17,
//         name: "GTX 1660 Super",
//         price: "₹24999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134601/17_liwvuu.jpg",
//         specs: "6GB GDDR6, 1.8GHz, 1408 CUDA",
//         description: "Excellent budget-friendly GPU for casual gamers."
//       },
//       {
//         id: 18,
//         name: "GTX 1650 Ti",
//         price: "₹17999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134607/18_i8fkaq.png",
//         specs: "4GB GDDR6, 1.5GHz, 896 CUDA",
//         description: "Affordable GPU suitable for eSports titles."
//       },
//       {
//         id: 19,
//         name: "GTX 1050 Ti",
//         price: "₹14999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134604/19_fe42n8.jpg",
//         specs: "4GB GDDR5, 1.4GHz, 768 CUDA",
//         description: "Entry-level GPU perfect for budget builds."
//       },
//       {
//         id: 20,
//         name: "RTX 3060",
//         price: "₹35999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134631/20_ijihq5.jpg",
//         specs: "12GB GDDR6, 1.7GHz, 3584 CUDA",
//         description: "Great choice for 1080p gaming at high settings."
//       },
//     ],
//   },
//   {
//     id: 3,
//     name: "RAM",
//     icon: "💾",
//     products: [
//       {
//         id: 21,
//         name: "HyperX Fury DDR5-6000",
//         price: "₹18999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134612/21_raqewo.jpg",
//         specs: "32GB (2x16GB), CL36, RGB",
//         description: "Fast RAM perfect for gaming and multitasking."
//       },
//       {
//         id: 22,
//         name: "Corsair Dominator DDR5-7200",
//         price: "₹24999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/22_qnhfgb.png",
//         specs: "32GB (2x16GB), CL34, RGB",
//         description: "High-speed memory for extreme performance."
//       },
//       {
//         id: 23,
//         name: "G.Skill Trident Z5 DDR5-6400",
//         price: "₹21999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/23_exsqm6.jpg",
//         specs: "32GB (2x16GB), CL32, RGB",
//         description: "Designed for overclocking enthusiasts and gamers."
//       },
//       {
//         id: 24,
//         name: "Corsair Vengeance LPX 16GB DDR4-3200",
//         price: "₹8999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134613/24_c3tam2.jpg",
//         specs: "16GB (1x16GB), CL16",
//         description: "Solid choice for gaming and general use."
//       },
//       {
//         id: 25,
//         name: "G.Skill Ripjaws V 16GB DDR4-3600",
//         price: "₹9999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134614/25_ft4x1t.jpg",
//         specs: "16GB (1x16GB), CL16",
//         description: "Reliable performance for demanding applications."
//       },
//       {
//         id: 26,
//         name: "Crucial Ballistix 32GB DDR4-3200",
//         price: "₹12999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/26_aywh5a.jpg",
//         specs: "32GB (2x16GB), CL16",
//         description: "Great for multitasking and gaming needs."
//       },
//       {
//         id: 27,
//         name: "Patriot Viper Steel 16GB DDR4-3600",
//         price: "₹7999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134621/27_imgrmp.jpg",
//         specs: "16GB (1x16GB), CL17",
//         description: "Affordable RAM with great performance."
//       },
//       {
//         id: 28,
//         name: "Corsair Vengeance 32GB DDR4-2933",
//         price: "₹10999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134615/28_q1vijt.jpg",
//         specs: "32GB (2x16GB), CL16",
//         description: "High capacity memory for heavy workloads."
//       },
//       {
//         id: 29,
//         name: "Kingston Fury Beast 16GB DDR4-3200",
//         price: "₹8999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134622/29_wxoyih.jpg",
//         specs: "16GB (2x8GB), CL16",
//         description: "Good performance for gaming and productivity."
//       },
//       {
//         id: 30,
//         name: "Team T-Force Vulcan Z 32GB DDR4-3200",
//         price: "₹11999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134625/30_v8ejiv.jpg",
//         specs: "32GB (2x16GB), CL16",
//         description: "Excellent performance for high-demand tasks."
//       },
//     ],
//   },
//   {
//     id: 4,
//     name: "Storage",
//     icon: "💿",
//     products: [
//       {
//         id: 31,
//         name: "Samsung 990 PRO",
//         price: "₹22999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134622/31_dbavte.jpg",
//         specs: "2TB, PCIe 4.0, 7000MB/s Read",
//         description: "High-speed NVMe SSD for demanding users."
//       },
//       {
//         id: 32,
//         name: "WD Black SN850X",
//         price: "₹19999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134629/32_c96ksa.png",
//         specs: "2TB, PCIe 4.0, 7300MB/s Read",
//         description: "Top-tier gaming SSD with blazing speeds."
//       },
//       {
//         id: 33,
//         name: "Crucial P5 Plus",
//         price: "₹17999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134632/33_noe8qn.png",
//         specs: "2TB, PCIe 4.0, 6600MB/s Read",
//         description: "Affordable NVMe SSD with excellent performance."
//       },
//       {
//         id: 34,
//         name: "Seagate FireCuda 530",
//         price: "₹24999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134625/34_jnu2uv.jpg",
//         specs: "2TB, PCIe 4.0, 7300MB/s Read",
//         description: "Designed for gamers with high-speed data needs."
//       },
//       {
//         id: 35,
//         name: "ADATA XPG Gammix S70",
//         price: "₹19999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134624/35_hf2ruz.jpg",
//         specs: "2TB, PCIe 4.0, 7400MB/s Read",
//         description: "Excellent performance for gaming and storage."
//       },
//       {
//         id: 36,
//         name: "Kingston KC3000",
//         price: "₹28999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134626/36_vrednh.jpg",
//         specs: "2TB, PCIe 4.0, 7000MB/s Read",
//         description: "High-capacity SSD for demanding professionals."
//       },
//       {
//         id: 37,
//         name: "Crucial MX500",
//         price: "₹10999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/37_wijybi.webp",
//         specs: "1TB, SATA III, 560MB/s Read",
//         description: "Reliable SATA SSD for performance upgrades."
//       },
//       {
//         id: 38,
//         name: "Samsung 860 EVO",
//         price: "₹12999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/38_l2rwyn.jpg",
//         specs: "1TB, SATA III, 550MB/s Read",
//         description: "Proven performer for SSD upgrades."
//       },
//       {
//         id: 39,
//         name: "Western Digital Blue SN570",
//         price: "₹8999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134627/39_bw6zwc.jpg",
//         specs: "1TB, M.2 NVMe, 3000MB/s Read",
//         description: "Budget-friendly NVMe SSD with solid performance."
//       },
//       {
//         id: 40,
//         name: "SanDisk Ultra 3D SSD",
//         price: "₹10999",
//         image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744134628/40_q4odic.webp",
//         specs: "1TB, SATA III, 560MB/s Read",
//         description: "Affordable SSD for enhanced storage speed."
//       },
//     ],
//   },
// ];
  

const UploadPcComponentCategories = () => {

  const clearExistingData = async () => {
    const collectionRef = collection(db, 'PcComponentCategories');
    const querySnapshot = await getDocs(collectionRef);
    querySnapshot.forEach(async (docSnapshot) => {
      await deleteDoc(doc(db, 'PcComponentCategories', docSnapshot.id));
    });
  };


  const uploadData = async () => {
    try {
      await clearExistingData(); 
      const collectionRef = collection(db, 'PcComponentCategories');

      for (const bundle of PcComponentCategories) {
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

export default UploadPcComponentCategories;
