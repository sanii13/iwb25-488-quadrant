import React, { useState, useEffect } from 'react';
import Navbar from '../components/navbar';
import Footer from '../components/footer';

interface Booking {
  id: string;
  doctorName: string;
  date: string;
  time: string;
  status: 'upcoming' | 'completed' | 'cancelled';
  speciality: string;
  location: string;
}

const PatientBookings: React.FC = () => {
  const [upcomingBookings, setUpcomingBookings] = useState<Booking[]>([]);
  const [pastBookings, setPastBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);

  // Mock data - In real implementation, this would come from the Ballerina backend
  useEffect(() => {
    const fetchBookings = async () => {
      // Simulate API call
      setTimeout(() => {
        const mockUpcomingBookings: Booking[] = [
          {
            id: '1',
            doctorName: 'Dr. Ajith Perera',
            date: '2025-09-15',
            time: '10:00 AM',
            status: 'upcoming',
            speciality: 'Neurology',
            location: 'Colombo'
          },
          {
            id: '2',
            doctorName: 'Dr. Saman Silva',
            date: '2025-09-20',
            time: '2:30 PM',
            status: 'upcoming',
            speciality: 'Cardiology',
            location: 'Kandy'
          },
          {
            id: '3',
            doctorName: 'Dr. Nimal Fernando',
            date: '2025-09-25',
            time: '9:15 AM',
            status: 'upcoming',
            speciality: 'Ayurvedic Medicine',
            location: 'Galle'
          }
        ];

        const mockPastBookings: Booking[] = [
          {
            id: '4',
            doctorName: 'Dr. Kamala Jayasinghe',
            date: '2025-08-15',
            time: '11:00 AM',
            status: 'completed',
            speciality: 'General Medicine',
            location: 'Colombo'
          },
          {
            id: '5',
            doctorName: 'Dr. Rajith Wickrama',
            date: '2025-08-10',
            time: '3:00 PM',
            status: 'completed',
            speciality: 'Dermatology',
            location: 'Negombo'
          },
          {
            id: '6',
            doctorName: 'Dr. Sunil Rajapaksa',
            date: '2025-07-28',
            time: '4:15 PM',
            status: 'cancelled',
            speciality: 'Orthopedics',
            location: 'Matara'
          },
          {
            id: '7',
            doctorName: 'Dr. Priya Gunasekara',
            date: '2025-07-20',
            time: '1:30 PM',
            status: 'completed',
            speciality: 'Pediatrics',
            location: 'Kandy'
          }
        ];

        setUpcomingBookings(mockUpcomingBookings);
        setPastBookings(mockPastBookings);
        setLoading(false);
      }, 1000);
    };

    fetchBookings();
  }, []);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'upcoming':
        return (
          <span className="px-3 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded-full">
            Upcoming
          </span>
        );
      case 'completed':
        return (
          <span className="px-3 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">
            Completed
          </span>
        );
      case 'cancelled':
        return (
          <span className="px-3 py-1 text-xs font-medium bg-red-100 text-red-800 rounded-full">
            Cancelled
          </span>
        );
      default:
        return null;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50" style={{ fontFamily: 'Poppins, sans-serif' }}>
        <Navbar />
        <div className="container mx-auto px-6 py-12 max-w-6xl" style={{ marginTop: '8vh' }}>
          <div className="flex justify-center items-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2" style={{ borderColor: '#56B280' }}></div>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50" style={{ fontFamily: 'Poppins, sans-serif' }}>
      <Navbar />
      
      <div className="container mx-auto px-6 py-12 max-w-6xl" style={{ marginTop: '8vh' }}>
        {/* Page Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-800 mb-2">My Appointments</h1>
          <p className="text-gray-600">Manage and view your medical appointments</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center">
              <div className="p-3 rounded-full" style={{ backgroundColor: '#E8F5E8' }}>
                <svg className="w-6 h-6" style={{ color: '#56B280' }} fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Upcoming Appointments</p>
                <p className="text-2xl font-bold text-gray-900">{upcomingBookings.length}</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center">
              <div className="p-3 rounded-full bg-blue-100">
                <svg className="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Completed Appointments</p>
                <p className="text-2xl font-bold text-gray-900">{pastBookings.filter(b => b.status === 'completed').length}</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center">
              <div className="p-3 rounded-full bg-gray-100">
                <svg className="w-6 h-6 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M3 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Appointments</p>
                <p className="text-2xl font-bold text-gray-900">{upcomingBookings.length + pastBookings.length}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Upcoming Bookings Section */}
        <div className="bg-white rounded-lg shadow-lg mb-8">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-xl font-semibold text-gray-800">Upcoming Appointments</h2>
          </div>
          <div className="overflow-x-auto">
            {upcomingBookings.length > 0 ? (
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Doctor
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Speciality
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Date
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Time
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {upcomingBookings.map((booking) => (
                    <tr key={booking.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">{booking.doctorName}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{booking.speciality}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{formatDate(booking.date)}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{booking.time}</div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <div className="px-6 py-8 text-center">
                <p className="text-gray-500">No upcoming appointments found.</p>
                <button 
                  className="mt-4 px-6 py-2 text-white rounded-lg font-medium transition-colors"
                  style={{ backgroundColor: '#56B280' }}
                  onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#4A9B6E'}
                  onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#56B280'}
                >
                  Book an Appointment
                </button>
              </div>
            )}
          </div>
        </div>

        {/* Past Bookings Section */}
        <div className="bg-white rounded-lg shadow-lg">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-xl font-semibold text-gray-800">Past Appointments</h2>
          </div>
          <div className="overflow-x-auto">
            {pastBookings.length > 0 ? (
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Doctor
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Speciality
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Date
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Time
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {pastBookings.map((booking) => (
                    <tr key={booking.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">{booking.doctorName}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{booking.speciality}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{formatDate(booking.date)}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">{booking.time}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        {getStatusBadge(booking.status)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <div className="px-6 py-8 text-center">
                <p className="text-gray-500">No past appointments found.</p>
              </div>
            )}
          </div>
        </div>
      </div>

      <Footer />
    </div>
  );
};

export default PatientBookings;
