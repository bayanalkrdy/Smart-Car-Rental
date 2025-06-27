import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useParams, useNavigate } from 'react-router-dom';

const EditDiscount = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    car_id: '',
    discount_value: '',
    discount_type: 'daily',
    expiration_date: '',
  });

  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const [fetching, setFetching] = useState(true);

  useEffect(() => {
    const fetchDiscount = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:8000/api/discount/${id}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        if (response.status === 200) {
          const discount = response.data;
          setFormData({
            car_id: discount.car_id || '',
            discount_value: discount.discount_value || '',
            discount_type: discount.discount_type || 'daily',
            expiration_date: discount.expiration_date ? discount.expiration_date.split('T')[0] : '',
          });
        }
      } catch (error) {
        setErrorMessage('An error occurred while fetching the discount data');
        console.error('Error:', error.response || error.message);
      } finally {
        setFetching(false);
      }
    };

    fetchDiscount();
  }, [id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setErrorMessage('');
    setSuccessMessage('');

    try {
      const token = localStorage.getItem('token');
      const response = await axios.put(`http://localhost:8000/api/discount/${id}`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (response.status === 200) {
        setSuccessMessage(' Discount updated successfully!');
      }
    } catch (error) {
      if (error.response && error.response.data.errors) {
        setErrorMessage('Input errors: ' + Object.values(error.response.data.errors).join(', '));
      } else {
        setErrorMessage('An error occurred while updating the discount');
      }
      console.error('Error:', error.response || error.message);
    }
    navigate("/dashboard/discounts");
    setLoading(false);
  };

  useEffect(() => {
    if (successMessage || errorMessage) {
      const timer = setTimeout(() => {
        setSuccessMessage('');
        setErrorMessage('');
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [successMessage, errorMessage]);

  if (fetching) {
    return <div className="p-8 text-lg font-semibold">Loading data...</div>;
  }

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold text-gray-800">Edit Discount</h2>

      {errorMessage && <p className="text-red-500 mt-4">{errorMessage}</p>}
      {successMessage && <p className="mt-4 text-center text-green-600 font-semibold">{successMessage}</p>}
      <section className="mt-8">
      <form onSubmit={handleSubmit} >
      <div className="flex flex-row gap-16 justify-center">
      <div className="flex flex-col gap-5">
          <label className="font-semibold">Discount Type</label>
          <select
            name="discount_type"
            value={formData.discount_type}
            onChange={handleChange}
            className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            required
          >
            <option value="daily">Daily</option>
            <option value="monthly">Monthly</option>
          </select>

          <label className="font-semibold">Expiration Date (optional)</label>
          <input
            type="date"
            name="expiration_date"
            value={formData.expiration_date}
            onChange={handleChange}
            className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            placeholder="Select expiration date (optional)"
          />
        </div>
        <div className="flex flex-col gap-5">
          <label className="font-semibold">Car ID (car_id)</label>
          <input
            type="text"
            name="car_id"
            value={formData.car_id}
            onChange={handleChange}
            className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            required
            placeholder="Enter car ID"
          />
        </div>

        <div className="flex flex-col gap-5">
          <label className="font-semibold">Discount Value</label>
          <input
            type="number"
            name="discount_value"
            value={formData.discount_value}
            onChange={handleChange}
            className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
            required
            min="0"
            placeholder="Enter discount value"
          />
        </div>

        </div>
        <div className="w-full flex justify-center py-12">
          <button
            type="submit"
             className="w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600"
            disabled={loading}
          >
            {loading ? 'Updating Discount...' : 'Update Discount'}
          </button>
        </div>
      </form>
      </section>
    </div>
  );
};

export default EditDiscount;
