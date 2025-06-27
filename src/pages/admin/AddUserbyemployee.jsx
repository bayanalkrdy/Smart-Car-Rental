import React, { useState } from 'react';
import axios from 'axios';

const AddUserbyEmployee = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    phone: '',
    address: '',
    license_number: '',
    license_image: null,
  });
  const [message, setMessage] = useState('');
  const [messageType, setMessageType] = useState(''); // 'success' or 'error'
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value, type, files } = e.target;
    if (type === 'file') {
      setFormData(prev => ({ ...prev, [name]: files[0] }));
    } else {
      setFormData(prev => ({ ...prev, [name]: value }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('');

    const data = new FormData();
    Object.entries(formData).forEach(([key, val]) => {
      if (val) data.append(key, val);
    });

    try {
      const token = localStorage.getItem('token');
      const res = await axios.post('http://localhost:8000/api/add-user', data, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data',
        },
      });
      if (res.status === 201) {
        setMessage(' User added successfully!');
        setMessageType('success');
        setFormData({ name: '', email: '', password: '', phone: '', address: '', license_number: '', license_image: null });
        setTimeout(() => setMessage(''), 1000);
      }
    } catch (err) {
      setMessage(' Failed to add user. Please try again.');
      setMessageType('error');
      console.error(err.response || err.message);
      setTimeout(() => setMessage(''), 4000);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-8 ">
      {/* Popup message */}
      {message && (
        <div className={
          `fixed top-30 left-4/7 transform -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-300 
           ${messageType === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`
        }>
          {message}
        </div>
      )}
      <h2 className="capitalize text-3xl font-bold text-gray-800 ">Add New User</h2>
      <section className="mt-8">
      <form onSubmit={handleSubmit}>
        <div className="flex flex-row gap-16 justify-center">
          <div className="flex flex-col gap-5">
            <label htmlFor="name" className="text-gray-600">Full Name</label>
            <input
              id="name"
              type="text"
              name="name"
              placeholder="Enter full name"
              value={formData.name}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
              required
            />

            <label htmlFor="email" className="text-gray-600">Email Address</label>
            <input
              id="email"
              type="email"
              name="email"
              placeholder="Enter email"
              value={formData.email}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
              required
            />

            <label htmlFor="password" className="text-gray-600">Password</label>
            <input
              id="password"
              type="password"
              name="password"
              placeholder="Enter password"
              value={formData.password}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
              required
            />
          </div>

          <div className="flex flex-col gap-5">
            <label htmlFor="phone" className="text-gray-600">Phone Number</label>
            <input
              id="phone"
              type="text"
              name="phone"
              placeholder="Enter phone number"
              value={formData.phone}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            />

            <label htmlFor="address" className="text-gray-600">Address</label>
            <input
              id="address"
              type="text"
              name="address"
              placeholder="Enter address"
              value={formData.address}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            />

            <label htmlFor="license_number" className="text-gray-600">License Number</label>
            <input
              id="license_number"
              type="text"
              name="license_number"
              placeholder="Enter license number"
              value={formData.license_number}
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            />
          </div>

          <div className="flex flex-col gap-4">
            <label htmlFor="license_image" className="text-gray-600">Upload License Image</label>
            <input
              id="license_image"
              type="file"
              name="license_image"
              onChange={handleChange}
              className="w-80 px-4 py-2 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            />
          </div>
        </div>

        <div className="w-full flex justify-center py-12">
          <button
            type="submit"
            disabled={loading}
            className={
              `w-80 px-4 py-2 rounded-full text-white transition-all duration-300
               ${loading ? 'bg-blue-300 cursor-not-allowed' : 'bg-blue-500 hover:bg-blue-600'}`
            }
          >
            {loading ? 'Adding...' : 'Add User'}
          </button>
        </div>
      </form>
      </section>
    </div>
  );
};

export default AddUserbyEmployee;
