import React, { useState, useEffect } from "react";
import axios from "axios";

const AddBooking = () => {
  const [cars, setCars] = useState([]);
  const [users, setUsers] = useState([]); // users state
  const [formData, setFormData] = useState({
    user_id: "",
    car_id: "",
    start_date: "",
    end_date: "",
    location: "",
    status: "pending",
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(true);
  const [successMessage, setSuccessMessage] = useState(""); // state for success message
  const [errorMessage, setErrorMessage] = useState(""); // state for error message
  const [hasPermission, ] = useState(true); // state to check if the user has permission
  const [bookingId, setBookingId] = useState(null); // state to store booking ID for confirmation
  const [isBookingConfirmed, setIsBookingConfirmed] = useState(false); // state to track if booking is confirmed

  useEffect(() => {
    const token = localStorage.getItem("token");

    const fetchData = async () => {
      try {
        const carsResponse = await axios.get("http://localhost:8000/api/cars", {
          headers: { Authorization: `Bearer ${token}` },
        });
        setCars(carsResponse.data.data);

        const usersResponse = await axios.get("http://localhost:8000/api/admin/users", {
          headers: { Authorization: `Bearer ${token}` },
        });
        setUsers(usersResponse.data.users);

        setLoading(false);
      } catch (error) {
        console.error("Error fetching data:", error);
        setErrorMessage("Failed to load data, please try again.");
      }
    };

    fetchData();
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem("token");

    if (!hasPermission) {
      setErrorMessage("You do not have the necessary permissions to create a booking.");
      setTimeout(() => {
        setErrorMessage(""); // hide the error message after 4 seconds
      }, 4000);
      return;
    }

    try {
      const response = await axios.post(
        "http://localhost:8000/api/bookings",
        formData,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log("Booking created:", response.data);
      setSuccessMessage("Booking created successfully!"); // show success message
      setBookingId(response.data.booking.id); // save the created booking id for confirmation
      setTimeout(() => {
        setSuccessMessage(""); // hide the success message after 4 seconds
      }, 4000);

      // Reset form after success
      setFormData({
        user_id: "",
        car_id: "",
        start_date: "",
        end_date: "",
        location: "",
        status: "pending",
      });
      setErrorMessage(""); // Clear error message if success
    } catch (error) {
      console.error("Booking error:", error.response?.data || error.message);
      setErrorMessage("Failed to create booking. Please try again.");
      setErrors(error.response?.data?.errors || {});
      setTimeout(() => {
        setErrorMessage(""); // hide the error message after 4 seconds
      }, 4000);
    }
  };

  // Confirm booking API call
  const confirmBooking = async () => {
    if (!bookingId) {
      setErrorMessage("Booking ID is missing.");
      return;
    }
  
    const token = localStorage.getItem("token");
  
    try {
      await axios.post(
        `http://localhost:8000/api/bookings/${bookingId}/confirm`,
        {},
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      
      setSuccessMessage("Booking confirmed successfully!"); // عرض رسالة نجاح
      setIsBookingConfirmed(true); // Set booking confirmed to true to hide the button
      setTimeout(() => {
        setSuccessMessage(""); // إخفاء رسالة النجاح بعد 4 ثواني
      }, 4000);
    } catch (error) {
      console.error("Confirmation error:", error.response?.data || error.message);
      setErrorMessage("Failed to confirm booking. Please try again.");
      setTimeout(() => {
        setErrorMessage(""); // إخفاء رسالة الخطأ بعد 4 ثواني
      }, 4000);
    }
  };

  if (loading) {
    return <p>Loading...</p>;
  }

  return (
    <div className="p-8">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Add Booking</h1>

      {Object.keys(errors).length > 0 && (
        <p className="mt-4 text-center text-red-500">
          There was an error with your input data.
        </p>
      )}

      {/* Display success message */}
      {successMessage && (
        <p className="fixed top-30 left-4/7 transform -translate-x-1/2 bg-green-100 text-green-800 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-500">
          {successMessage}
        </p>
      )}

      {/* Display error message */}
      {errorMessage && (
        <p className="mt-4 text-center text-red-500">{errorMessage}</p>
      )}

      {/* Show message if user doesn't have permission */}
      {!hasPermission && (
        <p className="mt-4 text-center text-red-500">
          You do not have the necessary permissions to create a booking.
        </p>
      )}

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            <div className="flex flex-col gap-5">
              {/* Car select */}
              <label>Car:</label>
              <select
                name="car_id"
                value={formData.car_id}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              >
                <option value="">Select a car</option>
                {Array.isArray(cars) &&
                  cars.map((car) => (
                    <option key={car.id} value={car.id}>
                      {car.model}
                    </option>
                  ))}
              </select>
              {errors.car_id && (
                <span className="text-red-500">{errors.car_id[0]}</span>
              )}

              {/* User select */}
              <label>User:</label>
              <select
                name="user_id"
                value={formData.user_id}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              >
                <option value="">Select a user</option>
                {Array.isArray(users) &&
                  users.map((user) => (
                    <option key={user.id} value={user.id}>
                      {user.name}
                    </option>
                  ))}
              </select>
              {errors.user_id && (
                <span className="text-red-500">{errors.user_id[0]}</span>
              )}
            </div>

            <div className="flex flex-col gap-5">
              <label>Start Date:</label>
              <input
                type="date"
                name="start_date"
                value={formData.start_date}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.start_date && (
                <span className="text-red-500">{errors.start_date[0]}</span>
              )}

              <label>End Date:</label>
              <input
                type="date"
                name="end_date"
                value={formData.end_date}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.end_date && (
                <span className="text-red-500">{errors.end_date[0]}</span>
              )}
            </div>

            <div className="flex flex-col gap-5">
              <label>Location:</label>
              <input
                type="text"
                name="location"
                value={formData.location}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                required
              />
              {errors.location && (
                <span className="text-red-500">{errors.location[0]}</span>
              )}

              <label>Booking Status:</label>
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
              {errors.status && (
                <span className="text-red-500">{errors.status[0]}</span>
              )}
            </div>
          </div>

          {/* Submit button */}
          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              disabled={loading || !hasPermission}
              className="cursor-pointer w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none transition-all duration-300"
            >
              {loading ? "Processing booking..." : "Create Booking"}
            </button>
          </div>
        </form>

        {/* Confirm booking button */}
        {!isBookingConfirmed && bookingId && (
          <div className="flex justify-center py-4">
            <button
              onClick={confirmBooking}
              className="cursor-pointer w-80 px-4 py-2 bg-green-500 text-white rounded-full hover:bg-green-600 focus:outline-none transition-all duration-300"
            >
              Send Notifications
            </button>
          </div>
        )}
      </section>
    </div>
  );
};

export default AddBooking;
