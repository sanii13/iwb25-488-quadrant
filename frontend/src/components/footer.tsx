import React from "react";
import logo from "../assets/images/logo.png";

const Footer = () => (
  <footer className="footer bg-[#232323] text-white pt-10">
    {/* Top Section */}
    <div className="footer-div1 mx-auto px-6 md:px-12 lg:px-16">
      {/* Border line */}
      <div className=" border-t border-white border-t-[2px] mb-8"></div>

      <div className="footer-dev flex flex-col md:flex-row md:justify-between gap-12">
        {/* Left Logo + Text */}
        <div className="flex flex-col gap-4 max-w-xs">
          <div className="flex items-center gap-2">
            <img src={logo} alt="Logo" className="w-8 h-8" />
            <span className="text-xl font-bold text-[#56B280]">AyurConnect</span>
          </div>
          <p className="text-gray-300 text-[16px] leading-relaxed">
            Your natural medicine made for you & your loved ones' wellness.
          </p>
        </div>

        {/* Right Links */}
        <div className="flex flex-col md:flex-row gap-12 md:gap-45">
          <div>
            <h4 className="text-base font-semibold mb-3 text-[#56B280]">Discovery</h4>
            <ul className="footer-links text-gray-300 text-[16px] space-y-2">
              <li className="hover:text-white cursor-pointer"><a href="#">New season</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Most searched</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Most selled</a></li>
            </ul>
          </div>
          <div>
            <h4 className="text-base font-semibold mb-3 text-[#56B280]">About</h4>
            <ul className="footer-links text-gray-300 text-[16px] space-y-2">
              <li className="hover:text-white cursor-pointer"><a href="#">Help</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Shipping</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Affiliate</a></li>
            </ul>
          </div>
          <div>
            <h4 className="text-base font-semibold mb-3 text-[#56B280]">Info</h4>
            <ul className="footer-links text-gray-300 text-[16px] space-y-2 ">
              <li className="hover:text-white cursor-pointer"><a href="#">Contact us</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Privacy Policies</a></li>
              <li className="hover:text-white cursor-pointer"><a href="#">Terms & Conditions</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    {/* Bottom Bar */}
    <div className="bg-white" style={{ padding: "0.5rem" }}>
      <p className="text-center text-xs text-gray-600">
        &copy; AyurConnect All Rights Reserved.
      </p>
    </div>
  </footer>
);

export default Footer;
