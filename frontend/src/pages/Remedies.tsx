import React, { useState } from "react";
import Navbar from "../components/navbar";
import Footer from "../components/footer";
import RemedyPaspanguwa from "../assets/images/remedy-paspanguwa.png";
import RemedyAloeVera from "../assets/images/remedy-aloe-vera.png";
import RemedyNeem from "../assets/images/remedy-neem.png";
import RemedyHero from "../assets/images/remedies-hero.png";
import SingleRemedyModal from "../components/SingleRemedyModal";

type Remedy = {
  remedy_id: number;
  name: string;
  subtitle: string;
  category?: string;
  remedy_uses: string[];
  ingredients: string[];
  steps: string[];
  cautions?: string[];
  image_url: string;
};

const remedies: Remedy[] = [
  {
    remedy_id: 1,
    name: "Paspanguwa",
    subtitle: "Supports urinary tract health and kidney stone prevention",
    image_url: RemedyPaspanguwa,
   
    remedy_uses: [
      "Purifies blood",
      "Treats skin conditions (acne, eczema)",
      "Antibacterial and antifungal"
    ],
    ingredients: ["Paspanguwa leaves", "Water", "Honey"],
    steps: [
      "Wash a handful of Paspanguwa leaves thoroughly.",
      "Boil the leaves in a pot with 2 cups of water for 10-15 minutes.",
      "Strain the mixture to remove the leaves.",
      "Add honey to taste and mix well.",
    ],
    cautions: ["Consult a healthcare professional before using Paspanguwa, especially if you have underlying health conditions."],
    // subtitle: "",
  },
  {
    remedy_id: 2,
    name: "Aloe Vera Drink",
    subtitle: "Improves digestion, controls blood sugar, promotes hair growth.",
    // image: RemedyAloeVera,
    image_url: RemedyAloeVera,
 
    remedy_uses: [
      "Aloe Vera drink aids digestion",
      "Helps control blood sugar",
      "Promotes hair growth"
    ],
    ingredients: ["Aloe Vera gel", "Water", "Honey or lemon juice"],
    steps: [
      "Extract fresh Aloe Vera gel from the leaf.",
      "Blend the gel with water and add honey or lemon juice for taste.",
      "Strain and serve chilled."
    ],
    cautions: ["Consult a healthcare professional before consuming Aloe Vera, especially if pregnant or on medication."],
    // subtitle: "",
  },
  {
    remedy_id: 3,
    name: "Neem Paste",
    subtitle: "Purifies blood, treats skin conditions (acne, eczema).",
    // image: RemedyNeem,
    image_url: RemedyNeem,
    remedy_uses: [
      "Neem paste is used to purify blood",
      "Treats various skin conditions such as acne and eczema"
    ],
    ingredients: ["Fresh Neem leaves", "Water"],
    steps: [
      "Wash and grind Neem leaves with a little water to make a paste.",
      "Apply the paste to affected skin areas and leave for 15-20 minutes.",
      "Rinse off with lukewarm water."
    ],
    cautions: ["Do a patch test before applying Neem paste to skin; avoid contact with eyes."],
    // subtitle: "",
  },
];

const Remedies: React.FC = () => {
  const [selectedRemedy, setSelectedRemedy] = useState<null | typeof remedies[0]>(null);

  return (
    <div className="min-h-screen bg-white font-[Poppins,sans-serif]">
      <Navbar />

      {/* Hero Section */}
      <div className="flex flex-col justify-center items-center  h-[630px] w-full " style={{fontFamily: 'Poppins, sans-serif', marginTop: '10vh', backgroundImage: `url(${RemedyHero})`, backgroundSize: 'cover', backgroundPosition: 'center', backgroundRepeat: 'no-repeat'}}>
        <div className="flex flex-col justify-center items-center bg-white bg-opacity-10 p-8 " style={{ opacity: 0.8, backdropFilter: 'blur(10px)', padding:'16vh', borderRadius:'25px' }}>
          <h1 className="text-3xl">🌿 </h1>
          <h1 className="text-black text-3xl font-bold-500 mb-4" style={{paddingBottom: '1rem'}}>Remedies</h1>
          <p className="text-black font-400 text-[16px] text-center max-w-lg">Discover trusted Ayurvedic remedies, connect with experienced doctors, and explore the healing power of Sri Lanka’s indigenous herbal knowledge – all in one place.
          </p>
        </div>
      </div>

      {/* Quote */}
      <section className="py-8 flex flex-col items-center">
        <h2 className="text-green-600 text-2xl md:text-3xl font-bold text-center mb-2">
          “Experience the Healing Power of Ayurveda”
        </h2>
        <p className="text-[#183153] text-base md:text-lg text-center">
          Bring balance and wellness into your life today
        </p>
      </section>

      {/* Remedies Section */}
      <section className="flex flex-col items-center py-4" style={{fontFamily: 'Poppins, sans-serif'}}>
        <h3 className="text-[#56B280] text-2xl font-semibold mb-2">Ayurvedic Remedies</h3>
        <p className="text-gray-500 text-center mb-8">
          Browse through the ayurvedic remedy collection crafted for balance and wellness
        </p>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8 w-full max-w-6xl px-4">
          {remedies.concat(remedies).map((remedy, idx) => (
            <div
              key={idx}
              className="bg-white rounded-xl shadow-md flex flex-col items-center p-6 transition-transform hover:scale-105"
            >
              <img
                src={remedy.image_url}
                alt={remedy.name}
                className="w-45 h-30 object-cover rounded-lg mb-4"
              />
              <h4 className="text-[#183153] text-lg font-bold mb-2 text-center">{remedy.name}</h4>
              <p className="text-gray-600 text-sm mt-2 line-clamp-3 text-center tracking-wider mb-5" style={{marginTop:'2rem', paddingLeft:'3rem',paddingRight:'3rem'}}>{remedy.subtitle}</p>
              <button
                className="bg-[#E6F4EA] text-[#183153] rounded-lg px-5 py-2 font-semibold flex items-center gap-2 hover:bg-[#d0ebdb] transition"
                onClick={() => setSelectedRemedy(remedy)}
              >
                See more <span className="text-xl">&#8594;</span>
              </button>
            </div>
          ))}
        </div>
        {selectedRemedy && (
          <SingleRemedyModal remedy={selectedRemedy} onClose={() => setSelectedRemedy(null)} />
        )}
      </section>

      {/* Pagination */}
      <div className="flex justify-center items-center gap-4 mb-16">
        <button className="bg-[#5B7F5C] text-white rounded px-4 py-2 text-xl font-bold">&lt;</button>
        <button className="bg-[#5B7F5C] text-white rounded px-4 py-2 font-bold">1</button>
        <button className="bg-[#DFF5E3] text-[#183153] rounded px-4 py-2 font-bold">2</button>
        <button className="bg-[#DFF5E3] text-[#183153] rounded px-4 py-2 font-bold">3</button>
        <button className="bg-[#5B7F5C] text-white rounded px-4 py-2 text-xl font-bold">&gt;</button>
      </div>

      <Footer />
    </div>
  );
};

export default Remedies;