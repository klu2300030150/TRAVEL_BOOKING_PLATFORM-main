// API Configuration and Service
// Centralized API calls for TravelSathi

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:9000';

const api = {
  baseUrl: API_BASE_URL,
  
  // Helper method for making requests
  async request(endpoint, options = {}) {
    const url = `${API_BASE_URL}${endpoint}`;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return await response.json();
    } catch (error) {
      console.error('API Error:', error);
      throw error;
    }
  },

  // User APIs
  user: {
    login: (credentials) => 
      api.request('/api/user/login', {
        method: 'POST',
        body: JSON.stringify(credentials),
      }),
    
    register: (userData) =>
      api.request('/api/user/register', {
        method: 'POST',
        body: JSON.stringify(userData),
      }),
  },

  // Booking APIs
  booking: {
    create: (bookingData) =>
      api.request('/api/booking', {
        method: 'POST',
        body: JSON.stringify(bookingData),
      }),
    
    getAll: () => api.request('/api/booking'),
    
    getById: (id) => api.request(`/api/booking/${id}`),
  },

  // Hotels/Stays APIs
  hotels: {
    getAll: () => api.request('/api/hotels'),
    getById: (id) => api.request(`/api/hotels/${id}`),
  },
};

export default api;
export { API_BASE_URL };
