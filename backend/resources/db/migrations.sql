-- SQL migrations for Neon PostgreSQL
-- Remedy Management System Database Schema

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'DOCTOR', 'PATIENT')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for users table
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Create remedies table
CREATE TABLE IF NOT EXISTS remedies (
    remedy_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    uses TEXT NOT NULL,
    ingredients TEXT[] NOT NULL,
    steps TEXT[] NOT NULL,
    cautions TEXT[] NOT NULL,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on name for faster searching
CREATE INDEX IF NOT EXISTS idx_remedies_name ON remedies(name);

-- Create index on created_at for sorting
CREATE INDEX IF NOT EXISTS idx_remedies_created_at ON remedies(created_at);

-- Create herbal_plants table
CREATE TABLE IF NOT EXISTS herbal_plants (
    plant_id SERIAL PRIMARY KEY,
    botanical_name VARCHAR(255) NOT NULL,
    local_name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    medicinal_uses TEXT NOT NULL,
    cultivation_steps TEXT NOT NULL,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for herbal_plants table
CREATE INDEX IF NOT EXISTS idx_herbal_plants_botanical_name ON herbal_plants(botanical_name);
CREATE INDEX IF NOT EXISTS idx_herbal_plants_local_name ON herbal_plants(local_name);
CREATE INDEX IF NOT EXISTS idx_herbal_plants_created_at ON herbal_plants(created_at);

-- Create articles table
CREATE TABLE IF NOT EXISTS articles (
    article_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for articles table
CREATE INDEX IF NOT EXISTS idx_articles_title ON articles(title);
CREATE INDEX IF NOT EXISTS idx_articles_category ON articles(category);
CREATE INDEX IF NOT EXISTS idx_articles_created_at ON articles(created_at);

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    medical_notes TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)  -- One patient record per user
);

-- Create indexes for patients table
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON patients(user_id);
CREATE INDEX IF NOT EXISTS idx_patients_name ON patients(name);
CREATE INDEX IF NOT EXISTS idx_patients_phone_number ON patients(phone_number);
CREATE INDEX IF NOT EXISTS idx_patients_created_at ON patients(created_at);

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    qualifications TEXT NOT NULL,
    experience INTEGER NOT NULL DEFAULT 0,
    contact_number VARCHAR(20) NOT NULL,
    languages TEXT[] NOT NULL,
    image_url VARCHAR(500),
    rating DECIMAL(3,2) DEFAULT 0.0 CHECK (rating >= 0.0 AND rating <= 5.0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)  -- One doctor record per user
);

-- Create indexes for doctors table
CREATE INDEX IF NOT EXISTS idx_doctors_user_id ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_doctors_name ON doctors(name);
CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON doctors(specialization);
CREATE INDEX IF NOT EXISTS idx_doctors_location ON doctors(location);
CREATE INDEX IF NOT EXISTS idx_doctors_rating ON doctors(rating);
CREATE INDEX IF NOT EXISTS idx_doctors_experience ON doctors(experience);
CREATE INDEX IF NOT EXISTS idx_doctors_created_at ON doctors(created_at);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    booking_id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')) DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for bookings table
CREATE INDEX IF NOT EXISTS idx_bookings_doctor_id ON bookings(doctor_id);
CREATE INDEX IF NOT EXISTS idx_bookings_patient_id ON bookings(patient_id);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(date);
CREATE INDEX IF NOT EXISTS idx_bookings_time ON bookings(time);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_bookings_doctor_date_time ON bookings(doctor_id, date, time);

-- Create unique constraint to prevent double bookings for the same doctor at the same time
CREATE UNIQUE INDEX IF NOT EXISTS idx_bookings_doctor_datetime_active 
ON bookings(doctor_id, date, time) 
WHERE status IN ('PENDING', 'CONFIRMED');

-- Insert sample articles data for testing (optional)
INSERT INTO articles (title, category, content, image_url) VALUES
(
    'The Complete Guide to Ayurvedic Medicine',
    'Traditional Medicine',
    'Ayurveda, the ancient Indian system of medicine, has been practiced for over 5,000 years. This comprehensive guide explores the fundamental principles of Ayurveda, including the three doshas (Vata, Pitta, and Kapha), and how understanding your unique constitution can lead to better health and wellness. Learn about the importance of balance in Ayurvedic philosophy and discover how this holistic approach to health considers not just physical symptoms, but also mental, emotional, and spiritual well-being. We''ll cover the basic principles of Ayurvedic diagnosis, the role of diet and lifestyle in maintaining health, and introduce you to some of the most commonly used herbs and treatments in Ayurvedic practice.',
    'https://example.com/images/ayurveda-guide.jpg'
),
(
    'Top 10 Medicinal Plants Every Home Should Have',
    'Herbal Medicine',
    'Growing your own medicinal plants is one of the most rewarding ways to take charge of your health naturally. This article explores ten essential medicinal plants that are easy to grow and maintain in your home garden or even in pots. From the immune-boosting properties of Echinacea to the digestive benefits of Mint, we''ll cover each plant''s medicinal uses, growing requirements, and harvesting tips. You''ll learn about Aloe Vera for skin care, Lavender for relaxation, Chamomile for better sleep, Calendula for wound healing, and more. Each plant entry includes detailed care instructions, optimal growing conditions, and simple preparation methods for making your own herbal remedies at home.',
    'https://example.com/images/medicinal-plants.jpg'
),
(
    'Turmeric: The Golden Spice with Amazing Health Benefits',
    'Herbal Medicine',
    'Turmeric, known as the "golden spice," has been treasured in traditional medicine for thousands of years, and modern science is now validating many of its remarkable health benefits. This in-depth article explores the active compound curcumin and its powerful anti-inflammatory and antioxidant properties. Learn about turmeric''s role in supporting joint health, boosting immune function, promoting digestive wellness, and potentially protecting against various chronic diseases. We''ll also cover the best ways to consume turmeric for maximum absorption, including recipes for golden milk, turmeric tea, and incorporating fresh turmeric into your daily meals. Discover why this humble root deserves a place in every health-conscious kitchen.',
    'https://example.com/images/turmeric-benefits.jpg'
),
(
    'Understanding Herbal Interactions: Safety First',
    'Safety & Guidelines',
    'While herbal medicines offer many benefits, it''s crucial to understand that natural doesn''t always mean harmless. This essential safety guide covers important considerations when using herbal remedies, including potential interactions with prescription medications, appropriate dosages, and contraindications for certain health conditions. Learn how to research herbs thoroughly before use, when to consult with healthcare professionals, and how to source high-quality herbal products. We''ll discuss common herbs that may interact with blood thinners, diabetes medications, and heart medications. This article also covers special considerations for pregnant and nursing women, children, and elderly individuals. Knowledge is power when it comes to using herbs safely and effectively.',
    'https://example.com/images/herbal-safety.jpg'
),
(
    'Seasonal Cleansing with Ayurvedic Herbs',
    'Seasonal Wellness',
    'Ayurveda teaches us that our bodies need different support throughout the changing seasons. This comprehensive guide explores the concept of seasonal cleansing using traditional Ayurvedic herbs and practices. Learn about the gentle detoxification methods recommended for spring cleaning, summer cooling practices, autumn preparation techniques, and winter strengthening approaches. We''ll cover specific herbs like Triphala for digestive cleansing, Manjistha for blood purification, and Trikatu for metabolic support. The article includes seasonal meal plans, daily routines (dinacharya), and simple home remedies that align with nature''s rhythms. Discover how to support your body''s natural detoxification processes while maintaining energy and vitality throughout the year.',
    'https://example.com/images/seasonal-cleansing.jpg'
),
(
    'Building Your First Herbal Medicine Cabinet',
    'Getting Started',
    'Starting your journey into herbal medicine can feel overwhelming with so many plants and preparations to choose from. This beginner-friendly guide helps you build a well-rounded herbal medicine cabinet with essential herbs that address common health concerns. Learn about versatile herbs like Ginger for digestion and nausea, Elderberry for immune support, Valerian for sleep, and Arnica for bruises and injuries. We''ll cover different forms of herbal preparations including teas, tinctures, salves, and capsules, and when to use each type. The article includes storage tips to maintain potency, labeling suggestions for organization, and a shopping list of must-have herbs for beginners. Start your herbal journey with confidence and the right tools.',
    'https://example.com/images/herbal-medicine-cabinet.jpg'
)
ON CONFLICT DO NOTHING;

-- Insert sample patient data for testing (optional)
INSERT INTO patients (user_id, name, phone_number, address, date_of_birth, medical_notes, image_url) VALUES
(
    3, -- Assuming patient@ayurconnect.com has user_id 3
    'John Doe',
    '+1-555-0123',
    '123 Main Street, Anytown, State 12345',
    '1985-06-15',
    'No known allergies. Regular checkups recommended.',
    'https://example.com/images/patient-john-doe.jpg'
)
ON CONFLICT (user_id) DO NOTHING;

-- Insert sample doctor data for testing (optional)
INSERT INTO doctors (user_id, name, specialization, location, qualifications, experience, contact_number, languages, image_url, rating) VALUES
(
    2, -- Assuming doctor@ayurconnect.com has user_id 2
    'Dr. Priya Sharma',
    'Ayurvedic Medicine',
    'Mumbai, Maharashtra',
    'BAMS (Bachelor of Ayurvedic Medicine and Surgery), MD Ayurveda, Certified Panchakarma Specialist',
    12,
    '+91-98765-43210',
    ARRAY['Hindi', 'English', 'Marathi'],
    'https://example.com/images/dr-priya-sharma.jpg',
    4.8
),
(
    4, -- Additional sample doctor
    'Dr. Rajesh Kumar',
    'Herbal Medicine',
    'Delhi, NCR',
    'BAMS, PhD in Medicinal Plants, Certified Herbalist',
    8,
    '+91-98765-43211',
    ARRAY['Hindi', 'English', 'Punjabi'],
    'https://example.com/images/dr-rajesh-kumar.jpg',
    4.6
),
(
    5, -- Additional sample doctor
    'Dr. Anita Patel',
    'Yoga Therapy',
    'Ahmedabad, Gujarat',
    'BNYS (Bachelor of Naturopathy and Yogic Sciences), Certified Yoga Therapist',
    15,
    '+91-98765-43212',
    ARRAY['Hindi', 'English', 'Gujarati'],
    'https://example.com/images/dr-anita-patel.jpg',
    4.9
)
ON CONFLICT (user_id) DO NOTHING;

-- Insert additional sample users for doctors
INSERT INTO users (email, password_hash, role) VALUES
(
    'dr.rajesh@ayurconnect.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- Hash of 'admin123'
    'DOCTOR'
),
(
    'dr.anita@ayurconnect.com', 
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- Hash of 'admin123'
    'DOCTOR'
)
ON CONFLICT DO NOTHING;

-- Insert sample admin user for testing (password: admin123)
-- Note: In production, use proper password hashing
INSERT INTO users (email, password_hash, role) VALUES
(
    'admin@ayurconnect.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- Hash of 'admin123'
    'ADMIN'
),
(
    'doctor@ayurconnect.com', 
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- Hash of 'admin123'
    'DOCTOR'
),
(
    'patient@ayurconnect.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- Hash of 'admin123'
    'PATIENT'
)
ON CONFLICT DO NOTHING;
