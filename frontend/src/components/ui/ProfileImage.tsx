import React from 'react';

interface ProfileImageProps {
  src?: string;
  alt?: string;
  size?: number;
  className?: string;
}

const ProfileImage: React.FC<ProfileImageProps> = ({ 
  src, 
  alt = "Profile", 
  size = 80, 
  className = "" 
}) => {
  const defaultImage = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Crect width='80' height='80' fill='%23e5e7eb'/%3E%3Cg fill='%23374151'%3E%3Ccircle cx='40' cy='30' r='12'/%3E%3Cpath d='M20 65c0-11 9-20 20-20s20 9 20 20v5H20v-5z'/%3E%3C/g%3E%3C/svg%3E";

  return (
    <div 
      className={`overflow-hidden rounded-full ${className}`}
      style={{ width: size, height: size }}
    >
      <img 
        src={src || defaultImage}
        alt={alt}
        className="w-full h-full object-cover"
        onError={(e) => {
          (e.target as HTMLImageElement).src = defaultImage;
        }}
      />
    </div>
  );
};

export default ProfileImage;
