// Mock booking service - In production, this would make actual API calls to Ballerina backend

export interface Booking {
  id: string;
  patientName?: string;
  doctorName?: string;
  date: string;
  time: string;
  status: 'upcoming' | 'completed' | 'cancelled';
  speciality?: string;
  appointmentType?: string;
  location?: string;
  contactNumber?: string;
}

export interface BookingResponse {
  success: boolean;
  data: Booking[];
  message?: string;
}

// Base URL for Ballerina backend (update this when backend is ready)
const API_BASE_URL = 'http://localhost:8080/api';

// Mock data for development
const mockPatientBookings = {
  upcoming: [
    {
      id: '1',
      doctorName: 'Dr. Ajith Perera',
      date: '2025-09-15',
      time: '10:00 AM',
      status: 'upcoming' as const,
      speciality: 'Neurology',
      location: 'Colombo'
    },
    {
      id: '2',
      doctorName: 'Dr. Saman Silva',
      date: '2025-09-20',
      time: '2:30 PM',
      status: 'upcoming' as const,
      speciality: 'Cardiology',
      location: 'Kandy'
    }
  ],
  past: [
    {
      id: '3',
      doctorName: 'Dr. Kamala Jayasinghe',
      date: '2025-08-15',
      time: '11:00 AM',
      status: 'completed' as const,
      speciality: 'General Medicine',
      location: 'Colombo'
    }
  ]
};

const mockDoctorBookings = {
  upcoming: [
    {
      id: '1',
      patientName: 'Sarath Ananda',
      date: '2025-09-15',
      time: '10:00 AM',
      status: 'upcoming' as const,
      appointmentType: 'Consultation',
      contactNumber: '077 325 6748'
    },
    {
      id: '2',
      patientName: 'Kamala Perera',
      date: '2025-09-15',
      time: '11:30 AM',
      status: 'upcoming' as const,
      appointmentType: 'Follow-up',
      contactNumber: '071 234 5678'
    }
  ],
  past: [
    {
      id: '3',
      patientName: 'Rajitha Wickrama',
      date: '2025-08-30',
      time: '11:00 AM',
      status: 'completed' as const,
      appointmentType: 'Consultation',
      contactNumber: '077 111 2222'
    }
  ]
};

export class BookingService {
  // Get patient bookings
  static async getPatientBookings(patientId: string): Promise<BookingResponse> {
    try {
      // In production, make actual API call:
      // const response = await fetch(`${API_BASE_URL}/patients/${patientId}/bookings`);
      // const data = await response.json();
      
      // For now, return mock data
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve({
            success: true,
            data: [...mockPatientBookings.upcoming, ...mockPatientBookings.past]
          });
        }, 1000);
      });
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to fetch patient bookings'
      };
    }
  }

  // Get doctor bookings
  static async getDoctorBookings(doctorId: string): Promise<BookingResponse> {
    try {
      // In production, make actual API call:
      // const response = await fetch(`${API_BASE_URL}/doctors/${doctorId}/bookings`);
      // const data = await response.json();
      
      // For now, return mock data
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve({
            success: true,
            data: [...mockDoctorBookings.upcoming, ...mockDoctorBookings.past]
          });
        }, 1000);
      });
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to fetch doctor bookings'
      };
    }
  }

  // Create new booking
  static async createBooking(bookingData: Partial<Booking>): Promise<BookingResponse> {
    try {
      // In production, make actual API call:
      // const response = await fetch(`${API_BASE_URL}/bookings`, {
      //   method: 'POST',
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: JSON.stringify(bookingData)
      // });
      // const data = await response.json();
      
      // For now, simulate successful creation
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve({
            success: true,
            data: [{ 
              id: Date.now().toString(), 
              ...bookingData 
            } as Booking],
            message: 'Booking created successfully'
          });
        }, 1000);
      });
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to create booking'
      };
    }
  }

  // Update booking status
  static async updateBookingStatus(bookingId: string, status: 'upcoming' | 'completed' | 'cancelled'): Promise<BookingResponse> {
    try {
      // In production, make actual API call:
      // const response = await fetch(`${API_BASE_URL}/bookings/${bookingId}/status`, {
      //   method: 'PUT',
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: JSON.stringify({ status })
      // });
      // const data = await response.json();
      
      // For now, simulate successful update
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve({
            success: true,
            data: [],
            message: 'Booking status updated successfully'
          });
        }, 500);
      });
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to update booking status'
      };
    }
  }
}
