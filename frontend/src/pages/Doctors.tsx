import React from "react";
import Navbar from "../components/navbar";
import Footer from "../components/footer";
import DoctorsHero from "../assets/images/doctors-hero.png";
import Doctor1 from "../assets/images/doctor1.png";
import Doctor2 from "../assets/images/doctor2.png";
import Doctor3 from "../assets/images/doctor3.png";

const doctors = [
  {
    img: Doctor1,
    name: "Dr. Sarath Ananda",
    title: "General Ayurveda Practitioner",
    rating: 4.5,
  },
  {
    img: Doctor2,
    name: "Dr. Manel Rathnayake",
    title: "Internal Medicine Specialist",
    rating: 4.5,
  },
  {
    img: Doctor3,
    name: "Dr. Pradeep Warnapura",
    title: "Surgery & Orthopedic Care",
    rating: 4.5,
  },
  {
    img: Doctor1,
    name: "Dr. Nimal Perera",
    title: "Pediatric Ayurveda",
    rating: 4.5,
  },
  {
    img: Doctor2,
    name: "Dr. Samanthi Jayasuriya",
    title: "Ayurveda Nutritionist",
    rating: 4.5,
  },
  {
    img: Doctor3,
    name: "Dr. Ruwan Gunasekara",
    title: "Ayurveda Dermatologist",
    rating: 4.5,
  },
];

const Doctors: React.FC = () => {
  return (
    <div className="min-h-screen bg-white font-[Poppins,sans-serif] flex flex-col">
      <Navbar />

      {/* Hero Section */}
      <div className="flex flex-col justify-center items-center  h-[630px] w-full " style={{fontFamily: 'Poppins, sans-serif', marginTop: '10vh', backgroundImage: `url(${DoctorsHero})`, backgroundSize: 'cover', backgroundPosition: 'center', backgroundRepeat: 'no-repeat'}}>
        <div className="flex flex-col justify-center items-center bg-white bg-opacity-10 p-8 " style={{ opacity: 0.8, backdropFilter: 'blur(10px)', padding:'16vh', borderRadius:'25px' }}>
          <h1 className="text-3xl"> 🩺 </h1>
          <h1 className="text-black text-3xl font-bold-500 mb-4" style={{paddingBottom: '1rem'}}>Doctor Search & Profiles</h1>
          <p className="text-black font-400 text-[16px] text-center max-w-lg">Find trusted Ayurvedic doctors near you. View their profiles, specializations, and book appointments with ease.
          </p>
        </div>
      </div>

      {/* Quote & Description */}
      <section className="py-8 flex flex-col items-center">
        <h2 className="text-green-600 text-2xl md:text-3xl font-bold text-center mb-2">
          “Guided by Experts in Ayurveda”
        </h2>
        <p className="text-[#183153] text-base md:text-lg text-center max-w-4xl">
          Discover a network of trusted Ayurvedic doctors ready to support your journey toward holistic wellness. With personalized care and deep knowledge of traditional healing, our practitioners help you restore balance, improve vitality, and embrace a healthier lifestyle.
        </p>
      </section>

      {/* Section Title */}
      <h3 className="text-[#56B280] text-2xl font-semibold mb-2 text-center">Ayurvedic Doctors</h3>
      <p className="text-gray-500 text-center mb-8">
        Connect with experienced practitioners across multiple specializations tailored to your unique needs.
      </p>

      {/* Search Bar */}
      <div className="flex justify-center mb-10">
        <div className="flex w-full max-w-xl items-center bg-green-100 rounded-full shadow">
          <input
            type="text"
            placeholder="Search by specialization"
            className="flex-1 px-4 py-2 bg-transparent outline-none text-gray-700"
            style={{ paddingLeft: "3rem" }}
          />
          <button className="bg-green-300 hover:bg-green-600 text-white p-2 rounded-full mx-2">
            <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 50 50">
              <path d="M 21 3 C 11.654545 3 4 10.654545 4 20 C 4 29.345455 11.654545 37 21 37 C 24.701287 37 28.127393 35.786719 30.927734 33.755859 L 44.085938 46.914062 L 46.914062 44.085938 L 33.875 31.046875 C 36.43682 28.068316 38 24.210207 38 20 C 38 10.654545 30.345455 3 21 3 z M 21 5 C 29.254545 5 36 11.745455 36 20 C 36 28.254545 29.254545 35 21 35 C 12.745455 35 6 28.254545 6 20 C 6 11.745455 12.745455 5 21 5 z"></path>
            </svg>
          </button>
        </div>
      </div>

      {/* Doctor Cards Grid */}
      <div className="flex justify-center mb-10">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 w-full max-w-5xl px-4">
          {doctors.map((doc, idx) => (
            <div
              key={idx}
              className="bg-white rounded-xl shadow-md flex flex-col items-center p-6 transition-transform hover:scale-105 border border-[#E6F4EA]"
            >
              <img
                src={doc.img}
                alt={doc.name}
                className="w-20 h-20 object-cover rounded-full mb-4 border-4 border-white shadow"
              />
              <div className="flex items-center mb-2">
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#9733;</span>
              <span className="text-[#56B280] text-2xl">&#11242;</span>
            </div>
              {/* <div className="flex items-center mb-2">
                {[...Array(4)].map((_, i) => (
                  <span key={i} className="text-[#56B280] text-xl">&#9733;</span>
                ))}
                <span className="text-[#56B280] text-xl">&#189;</span>
              </div> */}
              <h3 className="text-[#183153] text-[16px] font-bold mb-1 text-center">{doc.name}</h3>
              <p className="text-gray-500 text-center text-[13px] mb-4">{doc.title}</p>
              <button className="bg-[#E6F4EA] text-[#183153] rounded-lg px-5 py-2 font-semibold flex items-center gap-2 hover:bg-[#d0ebdb] transition text-sm">
                See profile <span className="text-xl">&#8594;</span>
              </button>
            </div>
          ))}
        </div>
      </div>

      <Footer />
    </div>
  );
};

export default Doctors;
