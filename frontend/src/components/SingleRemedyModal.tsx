import React from "react";

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

type SingleRemedyModalProps = {
  remedy: Remedy;
  onClose: () => void;
};

const SingleRemedyModal: React.FC<SingleRemedyModalProps> = ({ remedy, onClose }) => (
  <div className="fixed inset-0 z-50 flex items-center justify-center bg-white/40 backdrop-blur-md">
    <div className="bg-white rounded-2xl shadow-lg max-w-5xl w-full p-8 relative  max-h-[95vh] overflow-y-auto" style={{fontFamily: 'Poppins, sans-serif'}}>
      <button onClick={onClose} className="absolute top-3 right-3 text-gray-400 hover:text-gray-700 text-2xl font-bold">&times;</button>
      <div className="flex flex-col items-center bg-green-50 rounded-xl -m-10 mb-6">
        <img src={remedy.image_url} alt={remedy.name} className="w-xl h-50 object-cover rounded-xl mb-4 mt-4" />
        <h2 className="text-3xl font-bold text-[#183153] mt-2 mb-1">{remedy.name}</h2>
        {remedy.subtitle && <p className="text-gray-600 text-lg mb-2">{remedy.subtitle}</p>}
      </div>
      <div className="mb-4">
        <h3 className="text-green-700 text-2xl font-semibold mb-2">Uses</h3>
        <ul className="list-disc text-gray-800 bg-[#DFF5E3] pl-10 p-5 rounded">
          {remedy.remedy_uses.map((item, idx) => (
            <li key={idx}>{item}</li>
          ))}
        </ul>
      </div>
      <div className="mb-4">
        <h3 className="text-green-700 text-2xl font-semibold mb-2">Ingredients</h3>
        <ul className="list-disc text-gray-800 bg-[#DFF5E3] pl-10 p-5 rounded">
          {remedy.ingredients.map((item, idx) => (
            <li key={idx}>{item}</li>
          ))}
        </ul>
      </div>
      <div className="mb-4">
        <h3 className="text-green-700 text-2xl font-semibold mb-2">Steps</h3>
        <ol className="list-decimal pl-10 text-gray-800 bg-[#DFF5E3] p-5 rounded">
          {remedy.steps.map((step, idx) => (
            <li key={idx}>{step}</li>
          ))}
        </ol>
      </div>
      {remedy.cautions && remedy.cautions.length > 0 && (
        <div className="mb-6">
          <h3 className="text-green-700 text-2xl font-semibold mb-2">Cautions</h3>
          <ul className="list-disc text-gray-800 bg-[#DFF5E3] pl-10 p-5 rounded">
            {remedy.cautions.map((item, idx) => (
              <li key={idx}>{item}</li>
            ))}
          </ul>
        </div>
      )}
      <button onClick={onClose} className="w-full bg-[#DFF5E3] text-[#183153] rounded-lg py-2 font-semibold hover:bg-[#c7e7d0] transition">&larr; Back to Remedies</button>
    </div>
  </div>
);

export default SingleRemedyModal;