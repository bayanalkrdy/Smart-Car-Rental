import React, { useEffect, useState } from "react";
import axios from "axios";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit } from "react-icons/fa";
import { Link } from "react-router-dom";
import { FaSearch } from "react-icons/fa";
const Bookings = () => {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState("");
  const role = localStorage.getItem("role");
  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage(" You must log in first.");
      setLoading(false);
      return;
    }

    axios
      .get("http://localhost:8000/api/bookings", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((response) => {
        setBookings(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching bookings data", error);
        setMessage(" Failed to load bookings data.");
        setLoading(false);
      });
  }, []);

  const cancelBooking = async (id) => {
    const token = localStorage.getItem("token");
    if (!token) {
      setMessage(" You must log in first.");
      return;
    }

    try {
      const response = await axios.delete(
        `http://localhost:8000/api/bookings/${id}/cancel`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200) {
        setMessage(" Booking cancelled successfully.");
        setBookings(bookings.filter((booking) => booking.id !== id));
      }
    } catch (error) {
      console.error("Error cancelling booking", error);
      setMessage(" An error occurred while cancelling the booking.");
    }
  };

  //  فلترة الحجوزات حسب البحث
  const filteredBookings = bookings.filter(
    (booking) =>
      booking.user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      booking.car.model.toLowerCase().includes(searchQuery.toLowerCase())
  );

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Bookings</h1>

      <div className="mt-10">
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">
            Bookings Table
          </h2>

          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search by user or car..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="px-10 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-80"
            />
          </div>
        </div>

        {message && (
          <p className="text-red-500 my-4 font-semibold">{message}</p>
        )}

        <div className="overflow-x-auto shadow-md rounded-lg bg-white p-4 w-full mt-7">
          <table className="min-w-full table-auto">
            <thead className="bg-blue-100 text-blue-900">
              <tr>
                <th className="py-3 px-6 text-left font-semibold">
                  Booking ID
                </th>
                <th className="py-3 px-6 text-left font-semibold">User Name</th>
                <th className="py-3 px-6 text-left font-semibold">Car Name</th>
                <th className="py-3 px-6 text-left font-semibold">Location</th>
                <th className="py-3 px-6 text-left font-semibold">
                  Start Date
                </th>
                <th className="py-3 px-6 text-left font-semibold">End Date</th>
                <th className="py-3 px-6 text-left font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredBookings.map((booking) => (
                <tr key={booking.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{booking.id}</td>
                  <td className="py-3 px-6">{booking.user.name}</td>
                  <td className="py-3 px-6">{booking.car.model}</td>
                  <td className="py-3 px-6">{booking.car.location}</td>
                  <td className="py-3 px-6">{booking.start_date}</td>
                  <td className="py-3 px-6">{booking.end_date}</td>
                  <td className="py-3 px-6">
                    <div className="flex items-center justify-between gap-2">
                      <button
                        onClick={() => cancelBooking(booking.id)}
                        className="text-red-600 cursor-pointer hover:text-red-800"
                        title="Cancel Booking"
                      >
                        <MdOutlineDeleteForever className="w-7 h-7" />
                      </button>
                      {role === "Admin" && (
                        <Link
                          to={`/dashboard/editbooking/edit/${booking.id}`}
                          title="Edit Booking"
                        >
                          <FaRegEdit className="w-6 h-6 text-blue-500 hover:text-blue-900 transition" />
                        </Link>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
              {filteredBookings.length === 0 && (
                <tr>
                  <td colSpan="7" className="text-center py-6 text-gray-500">
                    No bookings found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Bookings;
