import React, { useState } from 'react';

const Login: React.FC = () => {
  const [isSignup, setIsSignup] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [showRoleSelection, setShowRoleSelection] = useState(false);
  const [showRoleForm, setShowRoleForm] = useState(false);
  const [selectedRole, setSelectedRole] = useState<'patient' | 'doctor' | null>(null);

  const handleToggleMode = () => {
    setIsSignup(!isSignup);
    setShowForm(false); // Reset form visibility when switching modes
    setShowRoleSelection(false);
    setShowRoleForm(false);
    setSelectedRole(null);
  };

  const handleButtonClick = () => {
    setShowForm(true);
  };

  const handleFormSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate successful signup
    if (isSignup) {
      setShowForm(false);
      setShowRoleSelection(true);
    } else {
      // Handle login logic here
      console.log('Login submitted');
      setShowForm(false);
    }
  };

  const handleRoleSelection = (role: 'patient' | 'doctor') => {
    setSelectedRole(role);
    setShowRoleSelection(false);
    setShowRoleForm(true);
  };

  const handleRoleFormSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Handle role-specific form submission
    console.log(`${selectedRole} form submitted`);
    setShowRoleForm(false);
    setSelectedRole(null);
  };

  return (
    <div className="h-screen w-screen flex flex-col overflow-hidden">
      {/* Hero Section with Background */}
      <div 
        className="h-[60vh] bg-cover bg-center flex items-center justify-center relative"
        style={{
          backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('/src/assets/images/loginBg.jpg')`
        }}
      >
        <div className="text-center z-20">
          <h1 className="text-5xl lg:text-6xl xl:text-8xl font-light text-emerald-400 drop-shadow-lg tracking-widest lg:tracking-wider xl:tracking-[4px] font-serif">
            AyurConnect
          </h1>
        </div>
      </div>

      {/* Login/Signup Section */}
      <div className="h-[40vh] bg-gray-50 !p-6 md:!p-8 flex items-center justify-center" style={{ padding: '1.5rem' }}>
        <div 
          className="bg-white !p-6 md:!p-8 xl:!p-10 rounded-xl shadow-lg w-full max-w-4xl xl:max-w-6xl !m-0" 
          style={{ 
            padding: '1.5rem 2.5rem', 
            margin: '0',
            boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)',
            backgroundColor: 'white'
          }}
        >
          <div className="text-center !m-0" style={{ margin: '0' }}>
            <div 
              className="flex flex-col md:flex-row gap-4 md:gap-6 xl:gap-8 !mb-4 items-center !mx-0" 
              style={{ marginBottom: '1rem', marginLeft: '0', marginRight: '0' }}
            >
              <button 
                className="flex-1 !bg-green-800 hover:!bg-green-600 !text-white !border-0 !py-4 !px-8 rounded-lg text-lg font-medium cursor-pointer transition-all duration-300 ease-in-out outline-none min-w-[220px] !m-0"
                style={{ 
                  backgroundColor: '#2d5016', 
                  color: 'white', 
                  border: 'none',
                  padding: '1rem 2rem',
                  margin: '0'
                }}
                onClick={handleButtonClick}
              >
                {isSignup ? 'Signup' : 'Login'}
              </button>
              
              <div className="w-full md:w-px h-px md:h-12 bg-gray-300 relative !mx-4">
                <span className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-white px-4 text-gray-500 text-sm">
                  or
                </span>
              </div>

              <button 
                className="flex-1 !bg-white !border-2 !border-gray-300 hover:!border-green-400 !py-4 !px-4 rounded-lg flex items-center justify-center gap-2 cursor-pointer transition-all duration-300 ease-in-out text-base !text-gray-700 outline-none min-w-[220px] !m-0"
                style={{ 
                  backgroundColor: 'white', 
                  color: '#374151', 
                  border: '2px solid #d1d5db',
                  padding: '1rem',
                  margin: '0'
                }}
              >
                <svg className="w-5 h-5" viewBox="0 0 24 24" width="20" height="20">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                Sign in with Google
              </button>
            </div>

            <div className="!mt-3 !mx-0" style={{ marginTop: '0.75rem', marginLeft: '0', marginRight: '0' }}>
              <span className="text-gray-500 text-sm mr-2">
                {isSignup ? "Already have an account?" : "Don't have an account?"}
              </span>
              <button 
                className="!bg-transparent !border-0 !text-green-800 hover:!text-green-600 cursor-pointer underline text-sm outline-none !m-0"
                style={{ backgroundColor: 'transparent', color: '#166534', border: 'none', margin: '0' }}
                onClick={handleToggleMode}
              >
                {isSignup ? "Login Here" : "Register Here"}
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Modal Overlay for Login Form */}
      {showForm && (
        <div 
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-[1000] backdrop-blur-sm"
          onClick={() => setShowForm(false)}
        >
          <div 
            className="bg-white/95 backdrop-blur-lg rounded-2xl !p-12 md:!p-16 w-[90%] max-w-lg shadow-2xl border border-white/20 relative !m-4"
            style={{ 
              padding: '3rem', 
              margin: '1rem',
              backgroundColor: 'rgba(255, 255, 255, 0.95)'
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <button 
              className="absolute top-4 right-4 !bg-transparent !border-0 text-2xl text-gray-500 hover:bg-gray-100 cursor-pointer !p-2 rounded-full transition-colors duration-300 outline-none !m-0"
              style={{ backgroundColor: 'transparent', border: 'none', padding: '0.5rem', margin: '0' }}
              onClick={() => setShowForm(false)}
            >
              ×
            </button>
            
            <h2 className="text-center text-gray-800 !mb-8 text-xl md:text-2xl font-medium !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
              {isSignup ? 'Sign up for AyurConnect' : 'Login to AyurConnect'}
            </h2>
            
            <form className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }} onSubmit={handleFormSubmit}>
              <div className="!mb-8 !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
                <label htmlFor="email" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Email</label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  placeholder="Enter your email"
                  className="w-full !p-4 !py-4 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 !h-14"
                  style={{ 
                    padding: '1rem', 
                    height: '3.5rem',
                    lineHeight: '1.5',
                    fontSize: '1rem'
                  }}
                  required
                />
              </div>

              <div className="!mb-8 !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
                <label htmlFor="password" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Password</label>
                <input
                  type="password"
                  id="password"
                  name="password"
                  placeholder="Enter your password"
                  className="w-full !p-4 !py-4 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 !h-14"
                  style={{ 
                    padding: '1rem', 
                    height: '3.5rem',
                    lineHeight: '1.5',
                    fontSize: '1rem'
                  }}
                  required
                />
              </div>

              {isSignup && (
                <div className="!mb-8 !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
                  <label htmlFor="confirmPassword" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Confirm Password</label>
                  <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Confirm your password"
                    className="w-full !p-4 !py-4 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 !h-14"
                    style={{ 
                      padding: '1rem', 
                      height: '3.5rem',
                      lineHeight: '1.5',
                      fontSize: '1rem'
                    }}
                    required
                  />
                </div>
              )}

              <button 
                type="submit" 
                className="w-full !bg-green-800 hover:!bg-green-600 !text-white !border-0 !p-4 !py-4 rounded-lg text-lg font-medium cursor-pointer transition-colors duration-300 outline-none !mt-6 !h-14"
                style={{ 
                  backgroundColor: '#2d5016', 
                  color: 'white', 
                  border: 'none',
                  padding: '1rem',
                  height: '3.5rem',
                  marginTop: '1.5rem'
                }}
              >
                {isSignup ? 'Sign Up' : 'Login'}
              </button>
            </form>

            <div className="text-center !mt-8 !mx-0" style={{ marginTop: '2rem', marginLeft: '0', marginRight: '0' }}>
              <span className="text-gray-500 text-sm mr-2">
                {isSignup ? "Already have an account?" : "Don't have an account?"}
              </span>
              <button 
                className="!bg-transparent !border-0 !text-green-800 hover:!text-green-600 cursor-pointer underline text-sm outline-none"
                style={{ backgroundColor: 'transparent', color: '#166534', border: 'none' }}
                onClick={handleToggleMode}
              >
                {isSignup ? "Login Here" : "Register Here"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Role Selection Modal */}
      {showRoleSelection && (
        <div 
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-[1000] backdrop-blur-sm"
        >
          <div 
            className="bg-white/95 backdrop-blur-lg rounded-2xl !p-12 md:!p-16 w-[90%] max-w-lg shadow-2xl border border-white/20 relative !m-4"
            style={{ 
              padding: '3rem', 
              margin: '1rem',
              backgroundColor: 'rgba(255, 255, 255, 0.95)'
            }}
          >
            <h2 className="text-center text-gray-800 !mb-8 text-xl md:text-2xl font-medium !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
              Select Your Role
            </h2>
            
            <p className="text-center text-gray-600 !mb-8 text-sm" style={{ marginBottom: '2rem' }}>
              Please select whether you are a patient or a doctor to complete your registration.
            </p>

            <div className="flex flex-col gap-4">
              <button 
                className="w-full !bg-blue-600 hover:!bg-blue-700 !text-white !border-0 !p-4 !py-4 rounded-lg text-lg font-medium cursor-pointer transition-colors duration-300 outline-none !h-14"
                style={{ 
                  backgroundColor: '#2563eb', 
                  color: 'white', 
                  border: 'none',
                  padding: '1rem',
                  height: '3.5rem'
                }}
                onClick={() => handleRoleSelection('patient')}
              >
                I am a Patient
              </button>

              <button 
                className="w-full !bg-green-600 hover:!bg-green-700 !text-white !border-0 !p-4 !py-4 rounded-lg text-lg font-medium cursor-pointer transition-colors duration-300 outline-none !h-14"
                style={{ 
                  backgroundColor: '#16a34a', 
                  color: 'white', 
                  border: 'none',
                  padding: '1rem',
                  height: '3.5rem'
                }}
                onClick={() => handleRoleSelection('doctor')}
              >
                I am a Doctor
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Role-specific Form Modal */}
      {showRoleForm && selectedRole && (
        <div 
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-[1000] backdrop-blur-sm"
          onClick={() => setShowRoleForm(false)}
        >
          <div 
            className="bg-white/95 backdrop-blur-lg rounded-2xl !p-12 md:!p-16 w-[90%] max-w-2xl shadow-2xl border border-white/20 relative !m-4 max-h-[80vh] overflow-y-auto"
            style={{ 
              padding: '3rem', 
              margin: '1rem',
              backgroundColor: 'rgba(255, 255, 255, 0.95)'
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <button 
              className="absolute top-4 right-4 !bg-transparent !border-0 text-2xl text-gray-500 hover:bg-gray-100 cursor-pointer !p-2 rounded-full transition-colors duration-300 outline-none !m-0"
              style={{ backgroundColor: 'transparent', border: 'none', padding: '0.5rem', margin: '0' }}
              onClick={() => setShowRoleForm(false)}
            >
              ×
            </button>
            
            <h2 className="text-center text-gray-800 !mb-8 text-xl md:text-2xl font-medium !mx-0" style={{ marginBottom: '2rem', marginLeft: '0', marginRight: '0' }}>
              Complete Your {selectedRole === 'patient' ? 'Patient' : 'Doctor'} Profile
            </h2>
            
            <form className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }} onSubmit={handleRoleFormSubmit}>
              {/* Common Fields */}
              <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                <label htmlFor="name" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Name *</label>
                <input
                  type="text"
                  id="name"
                  name="name"
                  placeholder="Enter your full name"
                  className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                  style={{ 
                    padding: '0.75rem 1rem', 
                    lineHeight: '1.5',
                    fontSize: '1rem'
                  }}
                  required
                />
              </div>

              <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                <label htmlFor="contact" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Contact Number *</label>
                <input
                  type="tel"
                  id="contact"
                  name="contact"
                  placeholder="Enter your contact number"
                  className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                  style={{ 
                    padding: '0.75rem 1rem', 
                    lineHeight: '1.5',
                    fontSize: '1rem'
                  }}
                  required
                />
              </div>

              {selectedRole === 'patient' && (
                <>
                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="address" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Address *</label>
                    <textarea
                      id="address"
                      name="address"
                      placeholder="Enter your address"
                      rows={3}
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 resize-vertical"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="dob" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Date of Birth *</label>
                    <input
                      type="date"
                      id="dob"
                      name="dob"
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="medicalNotes" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Medical Notes (Optional)</label>
                    <textarea
                      id="medicalNotes"
                      name="medicalNotes"
                      placeholder="Any relevant medical information or notes"
                      rows={4}
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 resize-vertical"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                    />
                  </div>
                </>
              )}

              {selectedRole === 'doctor' && (
                <>
                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="location" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Location *</label>
                    <input
                      type="text"
                      id="location"
                      name="location"
                      placeholder="Enter your practice location"
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="specialty" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Specialty *</label>
                    <input
                      type="text"
                      id="specialty"
                      name="specialty"
                      placeholder="Enter your medical specialty"
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="qualifications" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Qualifications *</label>
                    <textarea
                      id="qualifications"
                      name="qualifications"
                      placeholder="Enter your medical qualifications and degrees"
                      rows={3}
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0 resize-vertical"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="experience" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Experience *</label>
                    <input
                      type="text"
                      id="experience"
                      name="experience"
                      placeholder="Years of experience (e.g., 5 years)"
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>

                  <div className="!mb-6 !mx-0" style={{ marginBottom: '1.5rem', marginLeft: '0', marginRight: '0' }}>
                    <label htmlFor="languages" className="block !mb-3 text-gray-700 font-medium text-sm" style={{ marginBottom: '0.75rem' }}>Languages *</label>
                    <input
                      type="text"
                      id="languages"
                      name="languages"
                      placeholder="Languages spoken (e.g., English, Sinhala, Tamil)"
                      className="w-full !p-4 !py-3 border-2 border-gray-300/80 rounded-lg text-base transition-colors duration-300 bg-white/90 focus:outline-none focus:border-green-400 focus:ring-0"
                      style={{ 
                        padding: '0.75rem 1rem', 
                        lineHeight: '1.5',
                        fontSize: '1rem'
                      }}
                      required
                    />
                  </div>
                </>
              )}

              <button 
                type="submit" 
                className="w-full !bg-green-800 hover:!bg-green-600 !text-white !border-0 !p-4 !py-4 rounded-lg text-lg font-medium cursor-pointer transition-colors duration-300 outline-none !mt-6 !h-14"
                style={{ 
                  backgroundColor: '#2d5016', 
                  color: 'white', 
                  border: 'none',
                  padding: '1rem',
                  height: '3.5rem',
                  marginTop: '1.5rem'
                }}
              >
                Complete Registration
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Login;
