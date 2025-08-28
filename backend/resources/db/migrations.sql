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

-- Insert sample data for testing (optional)
INSERT INTO remedies (name, description, uses, ingredients, steps, cautions, image_url) VALUES
(
    'Honey Ginger Tea',
    'A soothing herbal tea made with fresh ginger and honey, perfect for cold and flu symptoms.',
    'Helps with cold symptoms, sore throat, nausea, and digestive issues.',
    ARRAY['2 inches fresh ginger root', '2 tablespoons honey', '2 cups water', '1 lemon (optional)'],
    ARRAY[
        'Peel and slice the fresh ginger root',
        'Boil water in a pot and add ginger slices',
        'Simmer for 10-15 minutes',
        'Strain the tea into a cup',
        'Add honey to taste',
        'Add lemon juice if desired',
        'Serve hot'
    ],
    ARRAY[
        'Not recommended for children under 1 year due to honey',
        'Consult doctor if pregnant or nursing',
        'May interact with blood thinning medications',
        'Start with small amounts to test tolerance'
    ],
    'https://example.com/images/honey-ginger-tea.jpg'
),
(
    'Turmeric Golden Milk',
    'A warm, comforting drink made with turmeric and milk, known for its anti-inflammatory properties.',
    'Reduces inflammation, supports immune system, aids sleep, and helps with joint pain.',
    ARRAY['1 cup milk (dairy or plant-based)', '1 teaspoon turmeric powder', '1/2 teaspoon cinnamon', '1/4 teaspoon ginger powder', '1 tablespoon honey', 'Pinch of black pepper'],
    ARRAY[
        'Heat milk in a saucepan over medium heat',
        'Add turmeric, cinnamon, and ginger powder',
        'Whisk well to combine and avoid lumps',
        'Simmer for 5 minutes, stirring occasionally',
        'Remove from heat and add honey',
        'Add a pinch of black pepper to enhance turmeric absorption',
        'Strain if desired and serve warm'
    ],
    ARRAY[
        'May stain clothing and surfaces',
        'Can increase bleeding risk if taking blood thinners',
        'May cause stomach upset in large quantities',
        'Consult doctor if taking medications'
    ],
    'https://example.com/images/turmeric-golden-milk.jpg'
),
(
    'Aloe Vera Gel for Burns',
    'Fresh aloe vera gel applied topically for minor burns, cuts, and skin irritations.',
    'Treats minor burns, cuts, sunburn, and various skin irritations.',
    ARRAY['Fresh aloe vera leaf', 'Clean knife', 'Clean cloth or cotton pad'],
    ARRAY[
        'Wash hands thoroughly',
        'Cut a fresh aloe vera leaf',
        'Slice the leaf lengthwise to expose the gel',
        'Scoop out the clear gel with a clean spoon',
        'Apply directly to the affected area',
        'Let it absorb into the skin',
        'Reapply 2-3 times daily as needed'
    ],
    ARRAY[
        'Do not use on deep or severe burns',
        'Test on small skin area first to check for allergies',
        'Do not ingest unless specified as food-grade',
        'Seek medical attention for serious burns'
    ],
    'https://example.com/images/aloe-vera-gel.jpg'
)
ON CONFLICT DO NOTHING;

-- Insert sample herbal plants data for testing (optional)
INSERT INTO herbal_plants (botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url) VALUES
(
    'Azadirachta indica',
    'Neem',
    'Neem is a evergreen tree native to the Indian subcontinent. Every part of the neem tree has medicinal properties and has been used in traditional Ayurvedic medicine for thousands of years.',
    'Antibacterial, antifungal, antiviral properties. Used for skin conditions, dental care, immune system support, blood purification, and diabetes management.',
    'Plant in well-draining soil with full sunlight. Water regularly during the first year, then reduce as the tree establishes. Neem is drought-tolerant once mature. Prune regularly to maintain shape. Harvest leaves throughout the year, bark during cooler months.',
    'https://example.com/images/neem-tree.jpg'
),
(
    'Ocimum tenuiflorum',
    'Holy Basil (Tulsi)',
    'Holy Basil, known as Tulsi in Hindi, is a sacred plant in Hindu tradition and a powerful adaptogenic herb. It is native to India and widely cultivated throughout Southeast Asia.',
    'Stress reduction, respiratory support, immune system booster, blood sugar regulation, anti-inflammatory, and antimicrobial properties. Used for coughs, colds, fever, and digestive issues.',
    'Grow in well-draining soil with partial to full sunlight. Sow seeds in spring or propagate from cuttings. Water regularly but avoid waterlogging. Pinch flowers to encourage leaf growth. Harvest leaves regularly for continuous growth. Protect from frost.',
    'https://example.com/images/holy-basil-tulsi.jpg'
),
(
    'Curcuma longa',
    'Turmeric (Haldi)',
    'Turmeric is a flowering plant of the ginger family. Its rhizome is used as a spice and medicine. It is native to Southeast Asia and is widely cultivated in India, which is the largest producer.',
    'Anti-inflammatory, antioxidant, antimicrobial properties. Used for joint pain, digestive issues, wound healing, skin conditions, and immune support. Contains curcumin, a powerful anti-inflammatory compound.',
    'Plant rhizomes in well-draining, fertile soil rich in organic matter. Requires warm, humid climate with temperatures between 20-30°C. Provide partial shade and regular watering. Harvest rhizomes after 8-12 months when leaves turn yellow.',
    'https://example.com/images/turmeric-plant.jpg'
),
(
    'Aloe barbadensis miller',
    'Aloe Vera',
    'Aloe Vera is a succulent plant species that grows in arid climates worldwide. It has been used medicinally for thousands of years and is known for its gel-filled leaves.',
    'Skin healing, burn treatment, wound care, digestive support, anti-inflammatory properties. The gel is used topically for burns, cuts, and skin irritations, while the latex has laxative properties.',
    'Plant in well-draining, sandy soil with full to partial sunlight. Water deeply but infrequently, allowing soil to dry between waterings. Avoid overwatering as it can cause root rot. Harvest mature outer leaves as needed. Protect from frost.',
    'https://example.com/images/aloe-vera.jpg'
),
(
    'Withania somnifera',
    'Ashwagandha (Winter Cherry)',
    'Ashwagandha is a small shrub with yellow flowers native to India and North Africa. It is one of the most important herbs in Ayurveda and is classified as an adaptogen.',
    'Stress reduction, anxiety relief, improved sleep, enhanced physical performance, immune support, and cognitive function improvement. Helps the body manage stress and maintain energy levels.',
    'Grow in well-draining soil with full sunlight. Sow seeds in spring or summer. Water moderately and avoid waterlogging. The plant is drought-tolerant once established. Harvest roots after 6-12 months for maximum potency. Dry roots properly for storage.',
    'https://example.com/images/ashwagandha-plant.jpg'
)
ON CONFLICT DO NOTHING;

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
