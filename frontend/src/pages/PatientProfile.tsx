import React, { useState } from 'react';
import Navbar from '../components/navbar';
import Footer from '../components/footer';
import ProfileImage from '../components/ui/ProfileImage';

const PatientProfile: React.FC = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [patientData, setPatientData] = useState({
    fullName: 'Sarath Ananda',
    contactNumber: '077 325 6748',
    address: 'No.17, Katubedda, Moratuwa.',
    dateOfBirth: '16/06/1993',
    medicalNotes: 'If you have any medical notes, please share them here.'
  });

  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  });

  const handleEdit = () => {
    setIsEditing(!isEditing);
  };

  const handleSave = () => {
    setIsEditing(false);
    // Add API call to save patient data here
    console.log('Saving patient data:', patientData);
  };

  const handleInputChange = (field: string, value: string) => {
    setPatientData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handlePasswordChange = (field: string, value: string) => {
    setPasswordData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handlePasswordSubmit = () => {
    if (passwordData.newPassword !== passwordData.confirmPassword) {
      alert('New password and confirm password do not match');
      return;
    }
    // Add API call to change password here
    console.log('Changing password');
    setShowPasswordModal(false);
    setPasswordData({
      currentPassword: '',
      newPassword: '',
      confirmPassword: ''
    });
  };

  return (
    <div className="min-h-screen bg-gray-50" style={{ fontFamily: 'Poppins, sans-serif' }}>
      <Navbar />
      
      <div className="container mx-auto px-6 py-12 max-w-6xl" style={{ marginTop: '8vh' }}>
        {/* Welcome Message */}
        <h2 className="text-2xl font-bold text-gray-800 mb-8">Welcome, Mr. Sarath!</h2>

        {/* Profile Card */}
        <div className="bg-white rounded-lg shadow-lg overflow-hidden max-w-5xl mx-auto">
          {/* Green Header Bar */}
          <div className="h-24" style={{ background: 'linear-gradient(to right, #56B280, #4A9B6E)' }}></div>

          {/* Profile Content */}
          <div className="px-8 py-10">
            {/* Profile Header */}
            <div className="flex items-center justify-between mb-10">
              <div className="flex items-center gap-6">
                <ProfileImage size={80} />
                <div>
                  <h3 className="text-2xl font-semibold text-gray-800">{patientData.fullName}</h3>
                  <p className="text-gray-600 text-lg">Patient</p>
                </div>
              </div>
              <button
                onClick={isEditing ? handleSave : handleEdit}
                className="px-8 py-3 text-white rounded-lg transition-colors font-medium"
                style={{ 
                  backgroundColor: '#56B280',
                  border: 'none'
                }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#4A9B6E'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#56B280'}
              >
                {isEditing ? 'Save' : 'Edit'}
              </button>
            </div>

            {/* Profile Fields */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-10">
              {/* Full Name */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Full Name
                </label>
                {isEditing ? (
                  <input
                    type="text"
                    value={patientData.fullName}
                    onChange={(e) => handleInputChange('fullName', e.target.value)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                  />
                ) : (
                  <div className="w-full px-4 py-3 bg-gray-50 rounded-lg text-gray-700 text-base">
                    {patientData.fullName}
                  </div>
                )}
              </div>

              {/* Contact Number */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Contact Number
                </label>
                {isEditing ? (
                  <input
                    type="text"
                    value={patientData.contactNumber}
                    onChange={(e) => handleInputChange('contactNumber', e.target.value)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                  />
                ) : (
                  <div className="w-full px-4 py-3 bg-gray-50 rounded-lg text-gray-700 text-base">
                    {patientData.contactNumber}
                  </div>
                )}
              </div>

              {/* Address */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Address
                </label>
                {isEditing ? (
                  <input
                    type="text"
                    value={patientData.address}
                    onChange={(e) => handleInputChange('address', e.target.value)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                  />
                ) : (
                  <div className="w-full px-4 py-3 bg-gray-50 rounded-lg text-gray-700 text-base">
                    {patientData.address}
                  </div>
                )}
              </div>

              {/* Date of Birth */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Date of Birth
                </label>
                {isEditing ? (
                  <input
                    type="text"
                    value={patientData.dateOfBirth}
                    onChange={(e) => handleInputChange('dateOfBirth', e.target.value)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                  />
                ) : (
                  <div className="w-full px-4 py-3 bg-gray-50 rounded-lg text-gray-700 text-base">
                    {patientData.dateOfBirth}
                  </div>
                )}
              </div>
            </div>

            {/* Medical Notes */}
            <div className="mb-10">
              <label className="block text-sm font-medium text-gray-700 mb-3">
                Medical Notes
              </label>
              {isEditing ? (
                <textarea
                  value={patientData.medicalNotes}
                  onChange={(e) => handleInputChange('medicalNotes', e.target.value)}
                  rows={4}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                />
              ) : (
                <div className="w-full px-4 py-3 bg-gray-50 rounded-lg text-gray-700 min-h-[120px] text-base">
                  {patientData.medicalNotes}
                </div>
              )}
            </div>

            {/* Change Password Button */}
            <button
              onClick={() => setShowPasswordModal(true)}
              className="w-full py-4 text-white rounded-lg transition-colors font-medium text-lg"
              style={{ 
                backgroundColor: '#e65b5bff',
                border: 'none'
              }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#d03939ff'}
              onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#e43838ff'}
            >
              Change Password
            </button>
          </div>
        </div>
      </div>

      {/* Password Change Modal */}
      {showPasswordModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4">
          <div className="bg-white rounded-lg p-8 w-full max-w-lg mx-4">
            <h3 className="text-2xl font-semibold text-gray-800 mb-6">Change Password</h3>
            
            <div className="space-y-6">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Current Password
                </label>
                <input
                  type="password"
                  value={passwordData.currentPassword}
                  onChange={(e) => handlePasswordChange('currentPassword', e.target.value)}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  New Password
                </label>
                <input
                  type="password"
                  value={passwordData.newPassword}
                  onChange={(e) => handlePasswordChange('newPassword', e.target.value)}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Confirm Password
                </label>
                <input
                  type="password"
                  value={passwordData.confirmPassword}
                  onChange={(e) => handlePasswordChange('confirmPassword', e.target.value)}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 text-base"
                />
              </div>
            </div>
            
            <div className="flex gap-4 mt-8">
              <button
                onClick={() => setShowPasswordModal(false)}
                className="flex-1 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium"
              >
                Cancel
              </button>
              <button
                onClick={handlePasswordSubmit}
                className="flex-1 py-3 text-white rounded-lg transition-colors font-medium"
                style={{ 
                  backgroundColor: '#56B280',
                  border: 'none'
                }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#4A9B6E'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#56B280'}
              >
                Change Password
              </button>
            </div>
          </div>
        </div>
      )}

      <Footer />
    </div>
  );
};

export default PatientProfile;
