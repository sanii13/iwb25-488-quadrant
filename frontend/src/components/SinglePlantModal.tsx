import React from "react";

type Plant = {
  plant_id: number;
  botanical_name: string;
  local_name: string;
  plant_description: string;
  medicinal_uses: string[];
  cultivation_steps: string[];
  image_url: string;
};

type SinglePlantModalProps = {
  plant: Plant;
  onClose: () => void;
};

const SinglePlantModal: React.FC<SinglePlantModalProps> = ({ plant, onClose }) => {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-white/40 backdrop-blur-md">
      <div className="bg-white rounded-2xl shadow-lg max-w-2xl w-full p-8 relative" style={{fontFamily: 'Poppins, sans-serif'}}>
        <button onClick={onClose} className="absolute top-3 right-3 text-gray-400 hover:text-gray-700 text-2xl font-bold">&times;</button>
        <div className="flex flex-col items-center">
          <img src={plant.image_url} alt={plant.botanical_name} className="w-full h-36 object-cover rounded-xl mb-4" />
          <div className="bg-[#F3F8F3] rounded-lg px-8 py-4 -mt-12 mb-4 shadow text-center">
            <h2 className="text-2xl font-bold text-[#183153]">{plant.botanical_name}</h2>
            <p className="text-gray-700 font-semibold text-base italic">{plant.local_name}</p>
          </div>
        </div>
        <div className="mb-4">
          <h3 className="font-semibold text-[#232323] mb-1">Plant Description</h3>
          <p className="text-gray-700 text-sm leading-relaxed">{plant.plant_description}</p>
        </div>
        {/* <div className="mb-4">
          <h3 className="font-semibold text-[#232323] mb-1">Medicinal Uses</h3>
          <ul className="list-disc pl-6 space-y-1">
            {plant.medicinal_uses.map((use, idx) => (
              <li key={idx} className="text-sm">{use}</li>
            ))}
          </ul>
        </div>
        <div className="mb-6">
          <h3 className="font-semibold text-[#232323] mb-1">Cultivation Steps</h3>
          <ol className="list-decimal pl-6 space-y-1">
            {plant.cultivation_steps.map((step, idx) => (
              <li key={idx} className="text-sm">{step}</li>
            ))}
          </ol>
        </div> */}
        <div className="mb-4">
          <h3 className="font-semibold text-[#232323] mb-1">Medicinal Uses</h3>
          <ul className="list-none space-y-1">
            {(plant.medicinal_uses).map((use, idx) => (
              <li key={idx} className="flex items-center text-sm">
                <span className="inline-block w-4 h-4 bg-[#56B280] rounded-full mr-2 flex-shrink-0"></span>
                {use}
              </li>
            ))}
          </ul>
        </div>
        <div className="mb-6">
          <h3 className="font-semibold text-[#232323] mb-1">Cultivation Steps</h3>
          <ul className="list-none space-y-1">
            {(plant.cultivation_steps).map((step, idx) => (
              <li key={idx} className="flex items-center text-sm">
                <span className="inline-block w-6 h-6 bg-[#E6F4EA] text-[#56B280] rounded-full mr-2 flex items-center justify-center font-bold text-xs">{idx + 1}</span>
                {step}
              </li>
            ))}
          </ul>
        </div>
        <button onClick={onClose} className="w-full bg-[#DFF5E3] text-[#183153] rounded-lg py-2 font-semibold hover:bg-[#c7e7d0] transition">&larr; Back to Library</button>
      </div>
    </div>
  );
};

export default SinglePlantModal;
