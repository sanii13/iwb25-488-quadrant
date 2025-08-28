import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Home from "./pages/Home";
import PatientProfile from "./pages/PatientProfile";
import DoctorProfile from "./pages/DoctorProfile";
import HerbalPlants from "./pages/HerbalPlants";
import Remedies from "./pages/Remedies";

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
          <Route path="/herbalPlants" element={<HerbalPlants />} />
          <Route path="/remedies" element={<Remedies />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
