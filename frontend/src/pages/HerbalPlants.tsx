import React, { useState } from "react";
import Navbar from "../components/navbar";
import Footer from "../components/footer";
import PlantCard from "../components/plantCard";
import SinglePlantModal from "../components/SinglePlantModal";
import herbalbg from "../assets/images/herbalplantbg.png";
import Mock from "../assets/images/mock.png";

type Plant = {
  plant_id: number;
  botanical_name: string;
  local_name: string;
  plant_description: string;
  medicinal_uses: string[];
  cultivation_steps: string[];
  image_url: string;
};

const HerbalPlants: React.FC = () => {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Plant[]>([]);
  const [selectedPlant, setSelectedPlant] = useState<Plant | null>(null);

  const handleSearch = () => {
    if (!query.trim()) return;
    if (!query.trim()) return;

    // 🔹 Later: replace with your Ballerina backend endpoint
    // Example: http://localhost:8080/api/plants?search=${query}
    console.log("Searching for:", query);

    // fetch(`http://localhost:8080/api/plants?search=${query}`)
    //   .then((res) => res.json())
    //   .then((data) => {
    //     console.log(data);
    //   })
    //   .catch((err) => console.error(err));

    // 🔹 Mock results (later replace with backend API)
    const mockResults: Plant[] = [
      {
        plant_id: 1,
        botanical_name: "Aerva Lanata",
        local_name: "Polpala",
        plant_description:
          "Supports urinary tract health, kidney stone prevention, diuretic properties.",
        medicinal_uses: ["Urinary tract health", "Kidney stone prevention", "Diuretic"],
        cultivation_steps: ["Sow seeds in well-drained soil", "Water regularly", "Harvest after flowering"],
        image_url: Mock,
      },
      {
        plant_id: 2,
        botanical_name: "Curry Leaves",
        local_name: "Karapincha",
        plant_description:
          "Improves digestion, controls blood sugar, promotes hair growth.",
        medicinal_uses: ["Improves digestion", "Controls blood sugar", "Promotes hair growth"],
        cultivation_steps: ["Plant stem cuttings", "Keep in sunny location", "Water moderately"],
        image_url: Mock,
      },
      {
        plant_id: 3,
        botanical_name: "Neem",
        local_name: "Kohomba",
        plant_description:
          "Purifies blood, treats skin conditions (acne, eczema), boosts immunity.",
        medicinal_uses: ["Purifies blood", "Treats skin conditions", "Boosts immunity"],
        cultivation_steps: ["Plant seeds or saplings", "Water occasionally", "Prune regularly"],
        image_url: Mock,
      },
      {
        plant_id: 1,
        botanical_name: "Aerva Lanata",
        local_name: "Polpala",
        plant_description:
          "Supports urinary tract health, kidney stone prevention, diuretic properties.",
        medicinal_uses: ["Urinary tract health", "Kidney stone prevention", "Diuretic"],
        cultivation_steps: ["Sow seeds in well-drained soil", "Water regularly", "Harvest after flowering"],
        image_url: Mock,
      },
      {
        plant_id: 2,
        botanical_name: "Curry Leaves",
        local_name: "Karapincha",
        plant_description:
          "Improves digestion, controls blood sugar, promotes hair growth.",
        medicinal_uses: ["Improves digestion", "Controls blood sugar", "Promotes hair growth"],
        cultivation_steps: ["Plant stem cuttings", "Keep in sunny location", "Water moderately"],
        image_url: Mock,
      },
      {
        plant_id: 3,
        botanical_name: "Neem",
        local_name: "Kohomba",
        plant_description:
          "Purifies blood, treats skin conditions (acne, eczema), boosts immunity.",
        medicinal_uses: ["Purifies blood", "Treats skin conditions", "Boosts immunity"],
        cultivation_steps: ["Plant seeds or saplings", "Water occasionally", "Prune regularly"],
        image_url: Mock,
      },
    ];

    setResults(mockResults);
  };

  return (
    <div className="min-h-screen bg-gray-50 ">
      <Navbar />

      {/* Content */}
      <div
        className="flex flex-col justify-center items-center h-[630px] w-full"
        style={{
          fontFamily: "Poppins, sans-serif",
          marginTop: "10vh",
          backgroundImage: `url(${herbalbg})`,
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
          <h1 className="text-3xl">🌿 </h1>
          <h1
            className="text-black text-3xl font-bold-500 mb-4"
            style={{ paddingBottom: "1rem" }}
          >
            Herbal Plants Library
          </h1>
          <p className="text-black text-[16px] text-center max-w-lg">
            Learn about Sri Lanka’s indigenous herbal plants with detailed
            profiles including uses, preparation methods, and cultivation
            insights.
          </p>
        </div>
      </div>

      {/* Search Bar */}
      <div className="flex justify-center mt-6" style={{ marginTop: '3rem'}}>
        <div className="flex w-full max-w-xl items-center bg-green-100 rounded-full shadow ">
          <input
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && handleSearch()}
            placeholder="Search by plant name or medicinal use"
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

      {/* Search Results */}
    <div className="max-w-6xl mx-auto px-6 py-8" style={{margin:'auto', paddingTop:'4rem', paddingBottom:'4rem'}}>
    {results.length > 0 ? (
        <div className="grid gap-6 grid-cols-1 sm:grid-cols-2 md:grid-cols-3">
    {results.map((plant) => (
      <PlantCard key={plant.plant_id} plant={plant} onSeeMore={() => setSelectedPlant(plant)} />
    ))}
    {/* Single Plant Modal */}
    {selectedPlant && (
      <SinglePlantModal plant={selectedPlant} onClose={() => setSelectedPlant(null)} />
    )}
        </div>
    ) : (
        <p className="text-gray-500 text-center">
        Results will appear here...
        </p>
    )}
    </div>


      <Footer />
    </div>
  );
};

export default HerbalPlants;
