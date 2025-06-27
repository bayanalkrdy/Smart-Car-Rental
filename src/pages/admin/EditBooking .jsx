import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

const EditBooking = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    user_id: "",
    car_id: "",
    start_date: "",
    end_date: "",
    location: "",
    status: "pending",
  });
  const [cars, setCars] = useState([]);
  const [users, setUsers] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(true);
  const [successMessage, setSuccessMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setErrorMessage("You must be logged in first.");
        setLoading(false);
        setTimeout(() => setErrorMessage(""), 4000);
        return;
      }

      try {
        const bookingRes = await axios.get(`http://localhost:8000/api/bookings/${id}`, {
          headers: { Authorization: `Bearer ${token}` },
        });

        const carsRes = await axios.get("http://localhost:8000/api/cars", {
          headers: { Authorization: `Bearer ${token}` },
        });

        const usersRes = await axios.get("http://localhost:8000/api/admin/users", {
          headers: { Authorization: `Bearer ${token}` },
        });

        const booking = bookingRes.data;

        if (booking) {
          setFormData({
            user_id: booking.user_id?.toString() || "",
            car_id: booking.car_id?.toString() || "",
            start_date: booking.start_date ? booking.start_date.split("T")[0] : "",
            end_date: booking.end_date ? booking.end_date.split("T")[0] : "",
            location: booking.location || "",
            status: booking.status || "pending",
          });
        } else {
          setErrorMessage("Booking data not found.");
          setTimeout(() => setErrorMessage(""), 4000);
        }

        setCars(carsRes.data?.data || []);
        setUsers(usersRes.data?.users || []);
      } catch (error) {
        console.error("Error fetching data:", error);
        setErrorMessage("Failed to load data.");
        setTimeout(() => setErrorMessage(""), 4000);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrors({});
    const token = localStorage.getItem("token");

    if (!token) {
      setErrorMessage("You must be logged in first.");
      setTimeout(() => setErrorMessage(""), 4000);
      return;
    }

    try {
      await axios.put(
        `http://localhost:8000/api/bookings/${id}`,
        {
          ...formData,
          start_date: new Date(formData.start_date).toISOString(),
          end_date: new Date(formData.end_date).toISOString(),
        },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      setSuccessMessage("Booking updated successfully!");
      setTimeout(() => {
        setSuccessMessage("");
        navigate("/dashboard/booking");
      }, 4000);
    } catch (error) {
      console.error("Error updating booking:", error.response?.data || error.message);
      if (error.response?.status === 422) {
        setErrors(error.response.data.errors || {});
      } else {
        setErrorMessage("An error occurred while updating the booking.");
        setTimeout(() => setErrorMessage(""), 4000);
      }
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-[70vh]">
        <p className="text-lg text-gray-600">Loading...</p>
      </div>
    );
  }

  return (
    <div className="p-8">
      <h1 className="capitalize text-3xl font-bold text-gray-800  mb-6">
        Edit Booking
      </h1>

      {/* Success Message */}
      {successMessage && (
        <p className="fixed top-30 left-4/7 transform -translate-x-1/2 bg-green-100 text-green-800 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-500">
          {successMessage}
        </p>
      )}

      {/* Error Message */}
      {errorMessage && (
        <p className="mt-4 text-center text-red-500">{errorMessage}</p>
      )}

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            <div className="flex flex-col gap-5">
              {/* User Select */}
              <label>User:</label>
              <select
                name="user_id"
                value={formData.user_id}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              >
                <option value="">Select a user</option>
                {users.map((user) => (
                  <option key={user.id} value={user.id}>
                    {user.name}
                  </option>
                ))}
              </select>
              {errors.user_id && <span className="text-red-500">{errors.user_id[0]}</span>}

              {/* Car Select */}
              <label>Car:</label>
              <select
                name="car_id"
                value={formData.car_id}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              >
                <option value="">Select a car</option>
                {cars.map((car) => (
                  <option key={car.id} value={car.id}>
                    {car.model}
                  </option>
                ))}
              </select>
              {errors.car_id && <span className="text-red-500">{errors.car_id[0]}</span>}
            </div>

            <div className="flex flex-col gap-5">
              {/* Start Date */}
              <label>Start Date:</label>
              <input
                type="date"
                name="start_date"
                value={formData.start_date}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.start_date && <span className="text-red-500">{errors.start_date[0]}</span>}

              {/* End Date */}
              <label>End Date:</label>
              <input
                type="date"
                name="end_date"
                value={formData.end_date}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.end_date && <span className="text-red-500">{errors.end_date[0]}</span>}
            </div>

            <div className="flex flex-col gap-5">
              {/* Location */}
              <label>Location:</label>
              <input
                type="text"
                name="location"
                value={formData.location}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.location && <span className="text-red-500">{errors.location[0]}</span>}

              {/* Status */}
              <label>Status:</label>
              <select
                name="status"
                value={formData.status}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
              >
                <option value="pending">Pending</option>
                <option value="confirmed">Confirmed</option>
                <option value="cancelled">Cancelled</option>
              </select>
              {errors.status && <span className="text-red-500">{errors.status[0]}</span>}
            </div>
          </div>

          {/* Submit Button */}
          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              className="cursor-pointer w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none transition-all duration-300"
            >
              Update Booking
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default EditBooking;
