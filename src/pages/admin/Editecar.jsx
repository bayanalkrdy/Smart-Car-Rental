import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

const EditCar = () => {
  const { id } = useParams(); 
  const navigate = useNavigate();
  const [car, setCar] = useState({
    model: '',
    year: '',
    color: '',
    features: '',
    seats: '',
    daily_price: '',
    status: '',
    location: '',
    image: null,
  });

  const [message, setMessage] = useState('');

  useEffect(() => {
    const fetchCar = async () => {
      try {
        const response = await axios.get(`http://localhost:8000/api/cars/${id}`);
        const data = response.data?.data || response.data;

        if (data && data.model) {
          setCar({
            model: data.model || '',
            year: data.year || '',
            color: data.color || '',
            features: data.features || '',
            seats: data.seats || '',
            daily_price: data.daily_price || '',
            status: data.status || '',
            location: data.location || '',
            image: null, // لما تعدل، بنرفع صورة جديدة
          });
        } else {
          showMessage(" Car data not found.");
        }
      } catch (error) {
        showMessage(" Failed to load car data.");
        console.error(error);
      }
    };

    fetchCar();
  }, [id]);

  const showMessage = (msg) => {
    setMessage(msg);
    setTimeout(() => {
      setMessage('');
    }, 4000); // 4 seconds
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setCar({ ...car, [name]: value });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    setCar({ ...car, image: file });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem("token");

    const formData = new FormData();
    ['model', 'year', 'color', 'features', 'seats', 'daily_price', 'status', 'location']
      .forEach(key => formData.append(key, car[key]));

    if (car.image) {
      formData.append('image', car.image);
    }

    try {
      const response = await axios.post(
        `http://localhost:8000/api/cars/${id}?_method=PUT`, 
        formData,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200) {
        showMessage(" Car updated successfully!");
        setTimeout(() => {
          navigate("/dashboard/car"); 
        }, 1000); // ننتظر ثانية صغيرة قبل الرجوع
      }
    } catch (error) {
      showMessage(" Failed to update the car.");
      console.error(error.response?.data);
    }
  };

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Edit Car</h1>
      {message && (
        <p className="mt-4 text-center text-red-500 transition-opacity duration-300">{message}</p>
      )}

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16">
            <div className="flex flex-col gap-5">
              <label>Car name:</label>
              <input
                type="text"
                name="model"
                value={car.model}
                onChange={handleChange}
                placeholder="Enter car model name"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>Year:</label>
              <input
                type="number"
                name="year"
                value={car.year}
                onChange={handleChange}
                placeholder="Enter manufacture year"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>Color:</label>
              <input
                type="text"
                name="color"
                value={car.color}
                onChange={handleChange}
                placeholder="Enter color"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />
            </div>

            <div className="flex flex-col gap-5">
              <label>Features:</label>
              <input
                type="text"
                name="features"
                value={car.features}
                onChange={handleChange}
                placeholder="Enter car features"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>Seats:</label>
              <input
                type="number"
                name="seats"
                value={car.seats}
                onChange={handleChange}
                placeholder="Enter number of seats"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>Daily price:</label>
              <input
                type="number"
                name="daily_price"
                value={car.daily_price}
                onChange={handleChange}
                placeholder="Enter daily price in $"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />
            </div>

            <div className="flex flex-col gap-5">
              <label>Status:</label>
              <input
                type="text"
                name="status"
                value={car.status}
                onChange={handleChange}
                placeholder="Enter status (Available / Rented)"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>Location:</label>
              <input
                type="text"
                name="location"
                value={car.location}
                onChange={handleChange}
                placeholder="Enter car location"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
                required
              />

              <label>New Image (optional):</label>
              <input
                type="file"
                name="image"
                onChange={handleImageChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px]"
              />
            </div>
          </div>

          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              className="w-80 px-4 py-2 bg-blue-500 text-white rounded-[100px] hover:bg-blue-600"
            >
              Update Car
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default EditCar;
