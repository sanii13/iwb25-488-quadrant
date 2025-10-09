import React from "react";

type ArticleModalProps = {
  article: {
    id: number;
    title: string;
    category: string;
    date: string;
    description: string;
    image: string;
    content?: string;
    author?: string;
  };
  onClose: () => void;
};

const defaultContent = `
Ayurvedic chaas, also known as takra, is a traditional fermented drink that has been cherished in Indian households for centuries. This refreshing beverage is not just a cooling summer drink but a powerhouse of nutritional and medicinal benefits.

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

Regular consumption of chaas can significantly improve digestive health, boost immunity, and provide essential nutrients that support overall wellness. As we rediscover ancient wisdom, chaas stands as a testament to the timeless knowledge of Ayurveda.
`;

const ArticleModal: React.FC<ArticleModalProps> = ({ article, onClose }) => {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4">
      <div 
        className="bg-white rounded-2xl shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto relative"
        style={{ fontFamily: 'Poppins, sans-serif' }}
      >
        {/* Header */}
        <div className="relative">
          <img 
            src={article.image} 
            alt={article.title} 
            className="w-full h-64 object-cover rounded-t-2xl" 
          />
          <button 
            onClick={onClose} 
            className="absolute top-4 right-4 bg-white/80 hover:bg-white text-gray-700 rounded-full p-2 transition-colors duration-200"
          >
            <svg 
              xmlns="http://www.w3.org/2000/svg" 
              className="h-6 w-6" 
              fill="none" 
              viewBox="0 0 24 24" 
              stroke="currentColor"
            >
              <path 
                strokeLinecap="round" 
                strokeLinejoin="round" 
                strokeWidth={2} 
                d="M6 18L18 6M6 6l12 12" 
              />
            </svg>
          </button>
        </div>

        {/* Content */}
        <div className="p-8">
          {/* Article Meta */}
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-4">
              <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-sm font-medium">
                {article.category}
              </span>
              <span className="text-gray-500 text-sm">{article.date}</span>
            </div>
            {article.author && (
              <span className="text-gray-600 text-sm">By {article.author}</span>
            )}
          </div>

          {/* Title */}
          <h1 className="text-3xl font-bold text-gray-900 mb-4 leading-tight">
            {article.title}
          </h1>

          {/* Description */}
          <p className="text-gray-700 text-lg mb-6 leading-relaxed">
            {article.description}
          </p>

          {/* Content */}
          <div className="prose prose-gray max-w-none">
            <div className="text-gray-700 leading-relaxed whitespace-pre-line">
              {article.content || defaultContent}
            </div>
          </div>

          {/* Back Button */}
          <div className="mt-8 pt-6 border-t border-gray-200">
            <button 
              onClick={onClose}
              className="bg-green-100 hover:bg-green-200 text-green-700 font-medium py-3 px-6 rounded-lg transition-colors duration-200 flex items-center gap-2"
            >
              <svg 
                xmlns="http://www.w3.org/2000/svg" 
                className="h-4 w-4" 
                fill="none" 
                viewBox="0 0 24 24" 
                stroke="currentColor"
              >
                <path 
                  strokeLinecap="round" 
                  strokeLinejoin="round" 
                  strokeWidth={2} 
                  d="M15 19l-7-7 7-7" 
                />
              </svg>
              Back to Articles
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ArticleModal;
