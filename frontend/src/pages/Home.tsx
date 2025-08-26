import Navbar from "../components/navbar";
import Footer from "../components/footer";
import homebg from "../assets/images/home-bg-image.png";
import RemedyPaspanguwa from "../assets/images/remedy-paspanguwa.png";
import RemedyAloeVera from "../assets/images/remedy-aloe-vera.png";
import RemedyNeem from "../assets/images/remedy-neem.png";
import HerbalPlantPot from "../assets/images/herbal-plant-pot.png";
import Doctor1 from "../assets/images/doctor1.png";
import Doctor2 from "../assets/images/doctor2.png";
import Doctor3 from "../assets/images/doctor3.png";
import Article1 from "../assets/images/article1.png";
import Article2 from "../assets/images/article2.png";
import Article3 from "../assets/images/article3.png";



const Home: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 ">
      <Navbar />



      {/* Content  */}
      <div className="flex flex-col justify-center items-center  h-[630px] w-full " style={{fontFamily: 'Poppins, sans-serif', marginTop: '10vh', backgroundImage: `url(${homebg})`, backgroundSize: 'cover', backgroundPosition: 'center', backgroundRepeat: 'no-repeat'}}>
        <div className="flex flex-col justify-center items-center bg-white bg-opacity-10 p-8 " style={{ opacity: 0.8, backdropFilter: 'blur(10px)', padding:'16vh', borderRadius:'25px' }}>
          <h1 className="text-3xl">🌿 </h1>
          <h1 className="text-black text-3xl font-bold-500 mb-4" style={{paddingBottom: '1rem'}}>Healing Naturally</h1>
          <p className="text-black font-400 text-[16px] text-center max-w-lg">Discover trusted Ayurvedic remedies, connect with experienced doctors, and explore the healing power of Sri Lanka’s indigenous herbal knowledge – all in one place.
          </p>
        </div>
      </div>
      {/* Remedies Section */}
      <section className="w-full bg-white py-12 flex flex-col items-center" style={{paddingTop:'3rem', fontFamily: 'Poppins, sans-serif'}}>
        <h2 className="text-3xl md:text-4xl font-bold-500 text-[#183153] mb-4 text-center" style={{fontFamily: 'Poppins, sans-serif', marginBottom: '1rem'}}>Remedies</h2>
        <p className="text-justify tracking-wider text-gray-600 text-center max-w-7xl mb-2 px-2 text-[16px]" style={{marginBottom: '1rem', padding: '1rem', borderRadius: '8px'}}>
          Explore a rich collection of traditional remedies passed down through generations, reflecting the wisdom of Sri Lanka’s indigenous healing practices. Each remedy is carefully documented with its ingredients, preparation methods, and recommended uses, making it easier for you to understand and apply age-old treatments in a safe and informed way.
        </p>
        <p className="text-justify tracking-wider text-gray-600 text-center max-w-7xl mb-8 px-2 text-[16px]" style={{marginBottom: '3rem', padding: '1rem'}}>
          Whether you are curious about natural alternatives for common ailments or seeking to reconnect with authentic Ayurvedic knowledge, this section offers a reliable source of guidance that bridges heritage with modern accessibility.
        </p>
        <div className="flex flex-col md:flex-row gap-8 justify-center items-stretch w-full max-w-5xl mb-8 px-4 ">
          {/* Remedy Card 1 */}
          <div className="rounded-xl shadow-md flex flex-col items-center p-6 w-full md:w-1/3 min-w-[300px] max-w-xs transition-transform hover:scale-105 bg-green-100" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={RemedyPaspanguwa} alt="Paspanguwa" className="w-60 h-40 object-cover rounded-lg mb-4" />
            <h3 className="text-[#183153] text-xl font-bold mb-2 text-center" style={{marginTop: '1rem', fontFamily: 'Poppins, sans-serif'}}>Paspanguwa</h3>
            <p className="tracking-wider text400 text-center text-base" style={{marginTop: '1rem', marginLeft: '3rem', marginRight: '3rem'}}>Supports urinary tract health, kidney stone prevention, diuretic properties.</p>
          </div>
          {/* Remedy Card 2 */}
          <div className="rounded-xl shadow-md flex flex-col items-center p-6 w-full md:w-1/3 min-w-[300px] max-w-xs transition-transform hover:scale-105 bg-green-100" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={RemedyAloeVera} alt="Aloe Vera Drink" className="w-60 h-40 object-cover rounded-lg mb-4" />
            <h3 className="text-[#183153] text-xl font-bold mb-2 text-center" style={{marginTop: '1rem', fontFamily: 'Poppins, sans-serif'}}>Aloe Vera Drink</h3>
            <p className="tracking-wider text-400 text-center text-base" style={{marginTop: '1rem', marginLeft: '3rem', marginRight: '3rem'}}>Improves digestion, controls blood sugar, promotes hair growth.</p>
          </div>
          {/* Remedy Card 3 */}
          <div className="rounded-xl shadow-md flex flex-col items-center p-6 w-full md:w-1/3 min-w-[300px] max-w-xs transition-transform hover:scale-105 bg-green-100" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={RemedyNeem} alt="Neem Paste" className="w-60 h-40 object-cover rounded-lg mb-4" />
            <h3 className="text-[#183153] text-xl font-bold mb-2 text-center" style={{marginTop: '1rem', fontFamily: 'Poppins, sans-serif'}}>Neem Paste</h3>
            <p className="tracking-wider text-400 text-center text-base" style={{marginTop: '1rem', marginLeft: '3rem', marginRight: '3rem'}}>Purifies blood, treats skin conditions (acne, eczema), boosts immunity.</p>
          </div>
        </div>
        <button className="tracking-widest px-8 py-3 bg-[#56B280] text-white rounded-[12px] font-semibold shadow hover:bg-[#44966a] transition-all flex items-center gap-2 text-lg" style={{fontFamily: 'Poppins, sans-serif', marginTop: '3rem', marginBottom: '1rem'}}>
          <a href="">Discover Remedies</a>
          <span className="text-2xl">&#8594;</span>
        </button>
      </section>


      {/* Herbal Plants Library Section */}
      <section className="w-full bg-[#f7f8fa] py-16 flex flex-col items-center" style={{fontFamily: 'Poppins, sans-serif'}}>
        <div className=" max-w-7xl w-full flex flex-col md:flex-row items-center justify-between gap-12 px-4 md:px-8 lg:px-16" style={{fontFamily: 'Poppins, sans-serif', marginBottom: '1rem', paddingTop:'3rem', paddingBottom:'3rem'}}>
          {/* Text Content */}
          <div className="flex-1 flex flex-col items-start justify-center max-w-xl">
            <h2 className="text-3xl md:text-4xl font-bold-500 text-[#232323] mb-6" style={{marginBottom: '2rem'}}>Herbal Plants Library</h2>
            <p className="tracking-wider text-400 text-base md:text-[16px] mb-4" style={{marginBottom: '2rem'}}>Discover the healing power of Sri Lanka’s indigenous herbal plants, treasured for centuries for their medicinal value and cultural significance. Each plant profile highlights its local and botanical names, traditional uses, preparation methods, and cultivation details, offering a comprehensive guide to understanding their role in natural healthcare.</p>
            <p className="tracking-wider text-400 text-base md:text-[16px] mb-8"style={{marginBottom: '5rem'}}>This library not only preserves valuable knowledge but also helps you appreciate the deep connection between nature and wellness.</p>
            <button className="tracking-widest px-8 py-3 bg-[#56B280] text-white rounded-[12px] font-semibold shadow hover:bg-[#44966a] transition-all flex items-center gap-2 text-lg" style={{fontFamily: 'Poppins, sans-serif'}}>
              <a href="">Explore Herbal Plants</a>
              <span className="text-2xl">&#8594;</span>
            </button>
          </div>
          {/* Image Content */}
          <div className="flex-1 flex justify-center items-center relative w-full md:w-auto">
            <div className="hidden md:block absolute left-1/2 -translate-x-1/2 md:static md:translate-x-0">
              <div className="w-[400px] h-[400px] bg-black rounded-full absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-0"></div>
              <img src={HerbalPlantPot} alt="Herbal Plant" className=" w-[500px] h-[500px] object-contain relative z-10 mx-auto" />
            </div>
            <img src={HerbalPlantPot} alt="Herbal Plant" className="w-[500px] h-[500px] object-contain md:hidden mx-auto" />
          </div>
        </div>
      </section>

      {/* Doctor Search & Profiles Section */}
      <section className="w-full bg-[#eaf6f2] py-16 flex flex-col items-center" style={{fontFamily: 'Poppins, sans-serif', paddingTop:'3rem', paddingBottom:'3rem'}}>
        <h2 className="text-3xl md:text-4xl font-bold-500 text-[#183153] mb-4 text-center" style={{marginBottom: '3rem'}}>Doctor Search & Profiles</h2>
        <p className="text-justify tracking-wider text-gray-700 text-[16px] text-center max-w-5xl mb-10 px-2 " style={{marginBottom: '4rem'}}>
          Discover and connect with trusted Ayurvedic doctors tailored to your needs. Explore detailed profiles highlighting their qualifications, specializations, and experience. Easily compare practitioners and book appointments seamlessly to begin your wellness journey with confidence.
        </p>
        <div className="flex flex-col md:flex-row gap-8 justify-center items-stretch w-full max-w-5xl mb-10 px-4">
          {/* Doctor Card 1 */}
          <div className="bg-white rounded-xl shadow-md flex flex-col items-center p-8 w-full md:w-1/3 min-w-[0px] max-w-xs transition-transform hover:scale-105" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={Doctor1} alt="Dr. Sarath Ananda" className="w-24 h-24 object-cover rounded-full mb-4 border-4 border-white shadow" />
            <div className="flex items-center mb-2">
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#11242;</span>
            </div>
            <h3 className="text-[#183153] text-[18px] font-bold mb-1 text-center" style={{marginTop: '2rem'}}>Dr. Sarath Ananda</h3>
            <p className="text-gray-500 text-center text-[14px]">General Ayurveda Practitioner</p>
          </div>
          {/* Doctor Card 2 */}
          <div className="bg-white rounded-xl shadow-md flex flex-col items-center p-6 w-full md:w-1/3 min-w-[300px] max-w-xs transition-transform hover:scale-105" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={Doctor2} alt="Dr. Manel Rathnayake" className="w-24 h-24 object-cover rounded-full mb-4 border-4 border-white shadow" />
            <div className="flex items-center mb-2">
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#11242;</span>
            </div>
            <h3 className="text-[#183153] text-[18px] font-bold mb-1 text-center"  style={{marginTop: '2rem'}}>Dr. Manel Rathnayake</h3>
            <p className="text-gray-500 text-center text-[14px]">Internal Medicine Specialist</p>
          </div>
          {/* Doctor Card 3 */}
          <div className="bg-white rounded-xl shadow-md flex flex-col items-center p-8 w-full md:w-1/3 min-w-[300px] max-w-xs transition-transform hover:scale-105" style={{paddingTop:'1.5rem', paddingBottom:'2rem'}}>
            <img src={Doctor3} alt="Dr. Pradeep Warnapura" className="w-24 h-24 object-cover rounded-full mb-4 border-4 border-white shadow" />
            <div className="flex items-center mb-2">
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#11242;</span>
            </div>
            <h3 className="text-[#183153] text-[18px] font-bold mb-1 text-center" style={{marginTop: '2rem'}}>Dr. Pradeep Warnapura</h3>
            <p className="text-gray-500 text-center text-[14px]">Surgery & Orthopedic Care</p>
          </div>
        </div>
        <button className="tracking-widest px-8 py-3 bg-[#56B280] text-white rounded-[12px] font-semibold shadow hover:bg-[#44966a] transition-all flex items-center gap-2 text-lg" style={{fontFamily: 'Poppins, sans-serif', marginTop: '5rem', marginBottom: '1rem', paddingLeft: '2rem', paddingRight: '2rem'}}>
          <a href="">Find Doctors</a>
          <span className="text-2xl">&#8594;</span>
        </button>
      </section>
      {/* Articles Section */}
      <section className="w-full bg-[#f7f8fa] py-16 flex flex-col items-center" style={{fontFamily: 'Poppins, sans-serif', paddingTop:'3rem', paddingBottom:'0rem'}}>
        <h2 className="text-3xl md:text-4xl font-bold-500 text-[#183153] mb-4 text-center" style={{marginBottom: '2rem'}}>Articles</h2>
        <p className="tracking-wider text-justify text-gray-700 text-center max-w-5xl mb-10 px-2 text-base md:text-[16px]" style={{paddingBottom: '4rem'}}>
          Stay informed and inspired with articles focused on Ayurveda, holistic wellness, and healthy lifestyle practices. From practical tips on nutrition and stress management to insights into traditional healing philosophies, this section provides reliable knowledge for everyday wellbeing.
        </p>
        <div className="bg-green-100 flex flex-col md:flex-row gap-8 justify-center items-stretch w-full max-w mb-10 px-4" style={{ paddingBottom: '4rem'}}>
          {/* Article Card 1 */}
          <div className="bg-transparent flex flex-col items-center p-4 w-full md:w-1/3 min-w-[220px] max-w-xs transition-transform hover:scale-105 md:-translate-y-8">
            <img src={Article1} alt="Top 5 Sri Lankan Herbs for Stress Relief and Better Sleep" className="w-full h-100 object-cover rounded-lg mb-4" />
            <p className="article-p text-[#232323] text-base text-[14px] font-semibold text-center">Top 5 Sri Lankan Herbs for Stress Relief and Better Sleep</p>
          </div>
          {/* Article Card 2 */}
          <div className="bg-transparent flex flex-col items-center p-4 w-full md:w-1/3 min-w-[220px] max-w-xs transition-transform hover:scale-105" >
            <img src={Article2} alt="Ayurvedic Plants: Growing Right for Your Living Place" className="w-full h-100 object-cover rounded-lg mb-4" />
            <p className="article-p text-[#232323] text-base text-[14px] font-semibold text-center">Ayurvedic Plants: Growing Right for Your Living Place</p>
          </div>
          {/* Article Card 3 */}
          <div className="bg-transparent flex flex-col items-center p-4 w-full md:w-1/3 min-w-[220px] max-w-xs transition-transform hover:scale-105 md:-translate-y-8" >
            <img src={Article3} alt="Boosting Immunity the Ayurvedic Way" className="w-full h-100 object-cover rounded-lg mb-4" />
            <p className="article-p text-[#232323] text-base text-[14px] font-semibold text-center" >Boosting Immunity the Ayurvedic Way</p>
          </div>
        </div>

        <div className=" flex  gap-8 justify-center items-stretch w-full max-w px-4" style={{paddingBottom:'4rem'}} >
          <button className="tracking-widest px-8 py-3 bg-[#56B280] text-white rounded-[12px] font-semibold shadow hover:bg-[#44966a] transition-all flex items-center gap-2 text-lg" style={{fontFamily: 'Poppins, sans-serif'}}>
          <a href="" className="tracking-widest">Explore Articles</a> 
          <span className="text-2xl">&#8594;</span>
        </button>
        
        </div>
        
      </section>


      <Footer />
    </div>
  );
};

export default Home;