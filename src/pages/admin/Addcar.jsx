import React, { useState, useEffect } from "react";
import axios from "axios";

const AddCarForm = () => {
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
  const [userRole, setUserRole] = useState('');

  useEffect(() => {
    const token = localStorage.getItem("token");
    const user = JSON.parse(localStorage.getItem("user"));
  
    if (token && user) {
      if (user.role === "Admin" || user.role === "Employee") {
        setUserRole("authorized");
      } else {
        setUserRole("unauthorized");
        showMessage(" You are not authorized to add a car.");
      }
    } else {
      setUserRole("unauthorized");
      showMessage(" You must be logged in first.");
    }
  }, []);

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

    if (userRole === "unauthorized") {
      showMessage(" You are not authorized to add a car.");
      return;
    }

    const token = localStorage.getItem("token");

    if (!token) {
      showMessage(" You must be logged in first.");
      return;
    }

    const formData = new FormData();
    ['model', 'year', 'color', 'features', 'seats', 'daily_price', 'status', 'location']
      .forEach(key => formData.append(key, car[key]));

    if (car.image) {
      formData.append('image', car.image);
    }

    try {
      const response = await axios.post("http://localhost:8000/api/cars", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data',
        },
      });

      if (response.status === 201) {
        showMessage(" Car added successfully!");
        setCar({
          model: "",
          year: "",
          color: "",
          features: "",
          seats: "",
          daily_price: "",
          status: "",
          location: "",
          image: null,
        });
      }
    } catch (error) {
      if (error.response) {
        switch (error.response.status) {
          case 403:
            showMessage(" You are not authorized to add a car.");
            break;
          case 401:
            showMessage(" You must be logged in first.");
            break;
          default:
            showMessage(" An error occurred while adding the car.");
        }
      } else {
        showMessage(" An error occurred while adding the car.");
      }
      console.error("Error details:", error.response?.data);
    }
  };

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Add Car</h1>
      {message && (
        <p className="mt-4 text-center text-red-500 transition-opacity duration-300">
          {message}
        </p>
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
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <label>Year of manufacture:</label>
              <input
                type="number"
                name="year"
                value={car.year}
                onChange={handleChange}
                placeholder="Enter manufacture year"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <label>Color:</label>
              <input
                type="text"
                name="color"
                value={car.color}
                onChange={handleChange}
                placeholder="Enter color"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
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
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <label>Number of seats:</label>
              <input
                type="number"
                name="seats"
                value={car.seats}
                onChange={handleChange}
                placeholder="Enter number of seats"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <label>Daily price:</label>
              <input
                type="number"
                name="daily_price"
                value={car.daily_price}
                onChange={handleChange}
                placeholder="Enter daily price in $"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
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
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <label>Location:</label>
              <input
                type="text"
                name="location"
                value={car.location}
                onChange={handleChange}
                placeholder="Enter car location"
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />

              <div className="mt-5">
                <label>Car Image:</label>
                <input
                  type="file"
                  name="image"
                  onChange={handleImageChange}
                  className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                />
              </div>
            </div>
          </div>

          <div className="w-full flex justify-center py-12">
            <button type="submit" className="w-80 px-4 py-2 bg-blue-500 text-white rounded-[100px] hover:bg-blue-600">
              Add Car
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default AddCarForm;
