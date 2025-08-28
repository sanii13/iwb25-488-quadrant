import React from "react";

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

type ArticleCardProps = {
  article: Article;
  onReadMore?: () => void;
};

const ArticleCard: React.FC<ArticleCardProps> = ({ article, onReadMore }) => {
  return (
    <div 
      className="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300 flex flex-col md:flex-row w-full"
      style={{ fontFamily: 'Poppins, sans-serif' }}
    >
      <img
        src={article.image}
        alt={article.title}
        className="w-full md:w-1/3 h-48 md:h-auto object-cover"
      />
      <div className="p-6 flex-1 flex flex-col justify-between">
        <div>
          <div className="flex items-center justify-between mb-3">
            <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-sm font-medium">
              {article.category}
            </span>
            <span className="text-gray-500 text-sm">{article.date}</span>
          </div>
          <h3 className="text-xl font-bold text-gray-900 mb-3 line-clamp-2">
            {article.title}
          </h3>
          <p className="text-gray-600 text-sm leading-relaxed mb-4 line-clamp-3">
            {article.description}
          </p>
        </div>
        <button 
          onClick={onReadMore}
          className="bg-green-400 hover:bg-green-500 text-white font-medium py-2 px-6 rounded-lg transition-colors duration-200 flex items-center gap-2 self-start"
        >
          Read More
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
              d="M9 5l7 7-7 7" 
            />
          </svg>
        </button>
      </div>
    </div>
  );
};

export default ArticleCard;
