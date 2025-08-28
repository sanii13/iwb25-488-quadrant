-- SQL migrations for Neon PostgreSQL
-- Remedy Management System Database Schema

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
