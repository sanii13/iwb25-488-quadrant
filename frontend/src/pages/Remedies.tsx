import React from "react";
import Navbar from "../components/navbar";
import Footer from "../components/footer";
import RemedyPaspanguwa from "../assets/images/remedy-paspanguwa.png";
import RemedyAloeVera from "../assets/images/remedy-aloe-vera.png";
import RemedyNeem from "../assets/images/remedy-neem.png";
import RemedyHero from "../assets/images/remedies-hero.png";

const remedies = [
  {
    name: "Paspanguwa",
    description: "Supports urinary tract health, kidney stone prevention, diuretic properties.",
    image: RemedyPaspanguwa,
  },
  {
    name: "Aloe Vera Drink",
    description: "Improves digestion, controls blood sugar, promotes hair growth.",
    image: RemedyAloeVera,
  },
  {
    name: "Neem Paste",
    description: "Purifies blood, treats skin conditions (acne, eczema).",
    image: RemedyNeem,
  },
];

const Remedies: React.FC = () => {
  return (
    <div className="min-h-screen bg-white font-[Poppins,sans-serif]">
      <Navbar />

      {/* Hero Section */}
      {/* <section className="relative w-full h-[340px] flex items-center justify-center">
        <img
          src={RemedyHero}
          alt="Remedies Hero"
          className="absolute inset-0 w-full h-full object-cover"
        />
        <div className="relative z-10 bg-white/80 rounded-xl shadow-lg px-8 py-10 flex flex-col items-center max-w-xl mx-auto">
          <span className="text-3xl mb-2">
            <span role="img" aria-label="plant">🌱</span>
          </span>
          <h1 className="text-2xl md:text-3xl font-bold text-[#183153] mb-2">Remedies</h1>
          <p className="text-center text-gray-700 text-base md:text-lg">
            Discover trusted Ayurvedic remedies, connect with experienced doctors, and explore the healing power of Sri Lanka's indigenous herbal knowledge – all in one place.
          </p>
        </div>
      </section> */}
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
      <section className="flex flex-col items-center py-4">
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
                src={remedy.image}
                alt={remedy.name}
                className="w-36 h-28 object-cover rounded-lg mb-4"
              />
              <h4 className="text-[#183153] text-lg font-bold mb-2 text-center">{remedy.name}</h4>
              <p className="text-gray-700 text-center text-base mb-4">{remedy.description}</p>
              <button className="bg-[#E6F4EA] text-[#183153] rounded-lg px-6 py-2 font-semibold flex items-center gap-2 hover:bg-[#d0ebdb] transition">
                See more <span className="text-xl">&#8594;</span>
              </button>
            </div>
          ))}
        </div>
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