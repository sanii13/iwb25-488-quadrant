import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Home from "./pages/Home";
import PatientProfile from "./pages/PatientProfile";
import DoctorProfile from "./pages/DoctorProfile";
import PatientBookings from "./pages/PatientBookings";
import DoctorBookings from "./pages/DoctorBookings";
import HerbalPlants from "./pages/HerbalPlants";
import Articles from "./pages/Articles";
import Remedies from "./pages/Remedies";
import Doctors from "./pages/Doctors";

import "./App.css";

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/patientProfile" element={<PatientProfile />} />
          <Route path="/doctorProfile" element={<DoctorProfile />} />
          <Route path="/patientBookings" element={<PatientBookings />} />
          <Route path="/doctorBookings" element={<DoctorBookings />} />
          <Route path="/herbalPlants" element={<HerbalPlants />} />
          <Route path="/articles" element={<Articles />} />
          <Route path="/remedies" element={<Remedies />} />
          <Route path="/doctors" element={<Doctors />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
