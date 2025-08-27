import React, { useState } from "react";
import Navbar from "../components/navbar";
import Footer from "../components/footer";
import ArticleCard from "../components/ArticleCard";
import ArticleModal from "../components/ArticleModal";
import articleBg from "../assets/images/articleBg.jpg";
import articleImage1 from "../assets/images/articleImage1.png";

type Article = {
  id: number;
  title: string;
  category: string;
  date: string;
  description: string;
  image: string;
  content?: string;
  author?: string;
};

const Articles: React.FC = () => {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Article[]>([]);
  const [selectedArticle, setSelectedArticle] = useState<Article | null>(null);

  const handleSearch = () => {
    if (!query.trim()) return;

    // 🔹 Later: replace with your Ballerina backend endpoint
    // Example: http://localhost:8080/api/articles?search=${query}
    console.log("Searching for articles:", query);

    // fetch(`http://localhost:8080/api/articles?search=${query}`)
    //   .then((res) => res.json())
    //   .then((data) => {
    //     console.log(data);
    //     setResults(data);
    //   })
    //   .catch((err) => console.error(err));

    // 🔹 Mock results (later replace with backend API)
    const mockResults: Article[] = [
      {
        id: 1,
        title: "Ayurvedic Benefits of Chaas",
        category: "Food Category",
        date: "Aug 07, 2025",
        description: "Ayurvedic chaas (also known as Takra) Ayurvedic chaas (also known as Takra) is a sattvic and refreshing drink. It's highly recommended in classical texts for its digestive and cooling properties.",
        image: articleImage1,
        author: "Dr. Ayurveda Specialist",
        content: `Ayurvedic chaas, also known as takra, is a traditional fermented drink that has been cherished in Indian households for centuries. This refreshing beverage is not just a cooling summer drink but a powerhouse of nutritional and medicinal benefits.

**What is Chaas?**

Chaas is essentially buttermilk prepared by churning curd (yogurt) with water and various spices. The fermentation process creates beneficial probiotics that support digestive health and overall well-being.

**Health Benefits:**

• **Digestive Aid**: The probiotics in chaas help maintain healthy gut flora and improve digestion
• **Cooling Properties**: Perfect for hot weather, helps regulate body temperature  
• **Nutrient Rich**: Contains essential vitamins, minerals, and proteins
• **Hydration**: Excellent source of hydration with added electrolytes
• **Weight Management**: Low in calories but high in nutrients, supports healthy weight management

**Traditional Preparation:**

The traditional method involves churning fresh curd with a wooden churner (madhani) along with water, salt, and spices like cumin, ginger, and mint. This process not only creates the perfect texture but also enhances the probiotic content.

**Modern Relevance:**

In today's fast-paced world, chaas serves as a natural energy drink without artificial additives. It's an excellent alternative to processed beverages and provides sustained energy throughout the day.

Regular consumption of chaas can significantly improve digestive health, boost immunity, and provide essential nutrients that support overall wellness. As we rediscover ancient wisdom, chaas stands as a testament to the timeless knowledge of Ayurveda.`
      },
      {
        id: 2,
        title: "Traditional Sri Lankan Herbal Remedies for Common Ailments",
        category: "Health Category",
        date: "Aug 05, 2025",
        description: "Discover the ancient wisdom of Sri Lankan traditional medicine and learn about powerful herbal remedies that have been used for generations to treat common health issues naturally.",
        image: articleImage1,
        author: "Traditional Medicine Expert",
        content: `Sri Lanka's rich biodiversity has blessed the island with an abundance of medicinal plants that form the backbone of traditional healing practices. For centuries, local healers have used these natural remedies to treat various ailments effectively.

**Common Herbal Remedies:**

**For Digestive Issues:**
• **Ginger (Inguru)**: Fresh ginger tea helps with nausea and indigestion
• **Curry Leaves (Karapincha)**: Improves digestion and metabolism
• **Coriander (Kottamalli)**: Seeds boiled in water aid digestion

**For Respiratory Problems:**
• **Tulsi (Maduruthala)**: Natural expectorant and immune booster
• **Gotu Kola (Gotukola)**: Helps with respiratory inflammation
• **Pepper (Gammiris)**: Natural decongestant

**For Skin Conditions:**
• **Neem (Kohomba)**: Powerful antimicrobial properties
• **Turmeric (Kaha)**: Anti-inflammatory and healing properties
• **Aloe Vera (Komarika)**: Soothes and heals skin irritations

**Preparation Methods:**

Most remedies are prepared as decoctions, herbal teas, or pastes. The key is using fresh, high-quality herbs and following traditional preparation methods that preserve the active compounds.

**Safety Considerations:**

While these remedies are generally safe, it's important to consult with qualified practitioners, especially when dealing with serious health conditions or when taking other medications.

The wisdom embedded in these traditional practices offers valuable insights for modern wellness approaches, bridging ancient knowledge with contemporary health needs.`
      }
    ];

    setResults(mockResults);
  };

  // Load initial articles on component mount
  React.useEffect(() => {
    // Mock initial articles - replace with API call later
    const initialArticles: Article[] = [
      {
        id: 1,
        title: "Ayurvedic Benefits of Chaas",
        category: "Food Category",
        date: "Aug 07, 2025",
        description: "Ayurvedic chaas (also known as Takra) Ayurvedic chaas (also known as Takra) is a sattvic and refreshing drink. It's highly recommended in classical texts for its digestive and cooling properties.",
        image: articleImage1,
        author: "Dr. Ayurveda Specialist"
      },
      {
        id: 2,
        title: "Traditional Sri Lankan Herbal Remedies for Common Ailments",
        category: "Health Category", 
        date: "Aug 05, 2025",
        description: "Discover the ancient wisdom of Sri Lankan traditional medicine and learn about powerful herbal remedies that have been used for generations to treat common health issues naturally.",
        image: articleImage1,
        author: "Traditional Medicine Expert"
      }
    ];
    setResults(initialArticles);
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />

      {/* Hero Section */}
      <div
        className="flex flex-col justify-center items-center h-[630px] w-full"
        style={{
          fontFamily: "Poppins, sans-serif",
          marginTop: "10vh",
          backgroundImage: `url(${articleBg})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
          backgroundRepeat: "no-repeat",
        }}
      >
        <div
          className="flex flex-col justify-center items-center bg-white bg-opacity-10 p-8"
          style={{
            opacity: 0.8,
            backdropFilter: "blur(10px)",
            padding: "16vh",
            borderRadius: "25px",
          }}
        >
          <h1 className="text-3xl">📄</h1>
          <h1
            className="text-black text-3xl font-bold-500 mb-4"
            style={{ paddingBottom: "1rem" }}
          >
            Articles
          </h1>
          <p className="text-black text-[16px] text-center max-w-lg">
            Discover expert tips, ancient wisdom, and modern insights to live a
            healthier, balanced life with Ayurveda.
          </p>
        </div>
      </div>

      {/* Search Bar */}
      <div className="flex justify-center mt-6" style={{ marginTop: '3rem' }}>
        <div className="flex w-full max-w-xl items-center bg-green-100 rounded-full shadow">
          <input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && handleSearch()}
            placeholder="Search by category"
            className="flex-1 px-4 py-2 bg-transparent outline-none text-gray-700"
            style={{ paddingLeft: "7rem" }}
          />
          <button
            onClick={handleSearch}
            className="bg-green-300 hover:bg-green-600 text-white p-2 rounded-full"
          >
            <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="25" height="25" viewBox="0 0 50 50">
              <path d="M 21 3 C 11.654545 3 4 10.654545 4 20 C 4 29.345455 11.654545 37 21 37 C 24.701287 37 28.127393 35.786719 30.927734 33.755859 L 44.085938 46.914062 L 46.914062 44.085938 L 33.875 31.046875 C 36.43682 28.068316 38 24.210207 38 20 C 38 10.654545 30.345455 3 21 3 z M 21 5 C 29.254545 5 36 11.745455 36 20 C 36 28.254545 29.254545 35 21 35 C 12.745455 35 6 28.254545 6 20 C 6 11.745455 12.745455 5 21 5 z"></path>
            </svg>
          </button>
        </div>
      </div>

      {/* Articles Grid */}
      <div className="max-w-6xl mx-auto px-6 py-8" style={{ margin: 'auto', paddingTop: '4rem', paddingBottom: '4rem' }}>
        {results.length > 0 ? (
          <div className="grid gap-6 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
            {results.map((article) => (
              <ArticleCard 
                key={article.id} 
                article={article} 
                onReadMore={() => setSelectedArticle(article)} 
              />
            ))}
          </div>
        ) : (
          <p className="text-gray-500 text-center">
            Loading articles...
          </p>
        )}
      </div>

      {/* Article Modal */}
      {selectedArticle && (
        <ArticleModal 
          article={selectedArticle} 
          onClose={() => setSelectedArticle(null)} 
        />
      )}

      <Footer />
    </div>
  );
};

export default Articles;
