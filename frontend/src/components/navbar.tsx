import React from "react";
import logo from "../assets/images/logo.png";

const Navbar = () => (
  <nav className="navbar-bg navbar shadow-md fixed top-0 left-0 w-full z-50" style={{fontFamily: 'Sahitya, serif', boxShadow: '0 2px 8px rgba(0,0,0,0.04)'}}>
  <div className="flex justify-between items-center px-20 h-18">
      <div className="flex items-center gap-3 mly-4">
        <img src={logo} alt="Logo" className="w-8 h-8" />
        <span className="text-[28px] font-bold" style={{color: '#56B280', fontFamily: 'Sahitya, serif'}}>
          AyurConnect
        </span>
      </div>
      <div className="flex gap-10">
        <a href="#" className="text-[20px] text-gray-500 font-medium hover:text-[#56B280] transition-colors">Remedies</a>
        <a href="#" className="text-[20px] text-gray-500 font-medium hover:text-[#56B280] transition-colors">Herbal Plants</a>
        <a href="#" className="text-[20px] text-gray-500 font-medium hover:text-[#56B280] transition-colors">Doctors</a>
        <a href="#" className="text-[20px] text-gray-500 font-medium hover:text-[#56B280] transition-colors">Articles</a>
      </div>
      <div className="flex gap-4">
  <button className="px-7 py-2 navbar-btn-bg text-white rounded-[20px] font-semibold shadow-sm hover:bg-[#44966a] transition-all min-w-[20]">Login</button>
  <button className="px-7 py-2 navbar-btn-bg text-white rounded-[20px] font-semibold shadow-sm hover:bg-[#44966a] transition-all min-w-[20]">Sign Up</button>
      </div>
    </div>
  </nav>
);
export default Navbar;
