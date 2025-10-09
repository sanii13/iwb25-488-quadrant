
type Plant = {
  // id: number;
  // name: string;
  // localName: string;
  // description: string;
  // image: string;

  plant_id: number;
  botanical_name: string;
  local_name: string;
  plant_description: string;
  // medicinal_uses: string[];
  // cultivation_steps: string[];
  image_url: string;};

type PlantCardProps = {
  plant: Plant;
  onSeeMore?: () => void;
};

const PlantCard: React.FC<PlantCardProps> = ({ plant, onSeeMore }) => {
  return (
    <div className="bg-white rounded-xl shadow-md p-4 max-w-sm flex flex-col">
      <img
        src={plant.image_url}
        alt={plant.botanical_name}
        className="w-full h-60 object-cover rounded-lg"
        style={{padding:'1rem', paddingTop:'1rem'}}
      />
      <div className="flex flex-col items-center mt-4" style={{fontFamily:'Poppins, sans-serif', margin:'auto', paddingTop:'0rem', paddingBottom:'2rem'}}>
          <h2 className="text-lg font-bold mt-2">{plant.botanical_name}</h2>
          <p className="italic text-gray-500" style={{marginTop:'1rem'}}>{plant.local_name}</p>
          <p className="text-gray-600 text-sm mt-2 line-clamp-3 text-justify tracking-wider" style={{marginTop:'2rem', paddingLeft:'3rem',paddingRight:'3rem'}}>{plant.plant_description}</p>
          <button className="mt-4 bg-green-100 text-green-700 font-medium py-2 px-4 rounded-lg hover:bg-green-200" style={{marginTop:'2rem'}} onClick={onSeeMore}>
            See more <span className="text-2xl">&#8594;</span>
          </button>
      </div>
    </div>
  );
};

export default PlantCard;