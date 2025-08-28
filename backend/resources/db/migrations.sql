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
