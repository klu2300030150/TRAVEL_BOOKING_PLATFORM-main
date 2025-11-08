import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';
import '../style/auth.css';

export default function Register() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    password: '',
    confirmPassword: '',
    role: 'USER',
  });

  const [errorMessage, setErrorMessage] = useState('');
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleRegister = async () => {
    const { name, email, phone, password, confirmPassword, role } = formData;

    if (!name || !email || !phone || !password || !confirmPassword) {
      setErrorMessage('Please fill in all fields');
      return;
    }

    if (password !== confirmPassword) {
      setErrorMessage('Passwords do not match');
      return;
    }

    try {
      const response = await api.user.register({
        name,
        email,
        phone,
        password,
        role,
      });

      // Response may be plain text or JSON; success phrase detection
      const respString = typeof response === 'string' ? response : JSON.stringify(response);
      if (respString.toLowerCase().includes('success')) {
        alert('Registration successful!');
        navigate('/login');
      } else {
        setErrorMessage(respString || 'Registration failed');
      }
    } catch (error) {
      console.error('Registration error:', error);
      setErrorMessage(error.message || 'Failed to register. Please check console for details.');
    }
  };

  return (
    <div className="auth-page fade-in">
      <div className="auth-box">
        <h2>Create Your TravelSathi Account</h2>

        <input
          type="text"
          name="name"
          placeholder="Full Name"
          value={formData.name}
          onChange={handleChange}
        />
        <input
          type="email"
          name="email"
          placeholder="Email Address"
          value={formData.email}
          onChange={handleChange}
        />
        <input
          type="text"
          name="phone"
          placeholder="Phone Number"
          value={formData.phone}
          onChange={handleChange}
        />
        <input
          type="password"
          name="password"
          placeholder="Password"
          value={formData.password}
          onChange={handleChange}
        />
        <input
          type="password"
          name="confirmPassword"
          placeholder="Confirm Password"
          value={formData.confirmPassword}
          onChange={handleChange}
        />
        <select name="role" value={formData.role} onChange={handleChange}>
          <option value="USER">User</option>
          <option value="ADMIN">Admin</option>
        </select>

        {errorMessage && <p className="error">{errorMessage}</p>}

        <button className="btn" onClick={handleRegister}>
          Register
        </button>

        <p className="switch-text">
          Already have an account? <span onClick={() => navigate('/login')}>Login</span>
        </p>
      </div>
    </div>
  );
}