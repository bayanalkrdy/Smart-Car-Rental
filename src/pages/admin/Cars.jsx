import React, { useEffect, useState } from "react";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit } from "react-icons/fa";
import axios from "axios";
import { Link } from "react-router-dom";
import { FaSearch } from "react-icons/fa";
const Cars = () => {
  const [cars, setCars] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    fetch("http://localhost:8000/api/cars")
      .then((response) => response.json())
      .then((data) => {
        setCars(data.data);
        console.log("cars response:", data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
        setLoading(false);
      });
  }, []);

  const deleteCar = async (carId) => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage(" You must be logged in first.");
      return;
    }

    try {
      const response = await axios.delete(
        `http://localhost:8000/api/cars/${carId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200 || response.status === 204) {
        setMessage(" Car deleted successfully!");
        setCars((prevCars) => prevCars.filter((car) => car.id !== carId));
      }
    } catch (error) {
      if (error.response) {
        switch (error.response.status) {
          case 403:
            setMessage(" You don't have permission to delete this car.");
            break;
          case 404:
            setMessage(" Car not found.");
            break;
          default:
            setMessage(" An error occurred while deleting the car.");
        }
      } else {
        setMessage(" An error occurred while deleting the car.");
      }
      console.error("Error details:", error.response?.data);
    }
  };

  useEffect(() => {
    if (message) {
      const timer = setTimeout(() => {
        setMessage("");
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [message]);

  const filteredCars = cars.filter(
    (car) =>
      car.model.toLowerCase().includes(searchQuery.toLowerCase()) ||
      car.location.toLowerCase().includes(searchQuery.toLowerCase())
  );

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Cars</h1>

      <div className="mt-10">
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">
            Cars Table
          </h2>
          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search by model or location..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-4 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-full"
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
                <th className="py-3 px-6 text-left font-semibold">Car ID</th>
                <th className="py-3 px-6 text-left font-semibold">Model</th>
                <th className="py-3 px-6 text-left font-semibold">Year</th>
                <th className="py-3 px-6 text-left font-semibold">Color</th>
                <th className="py-3 px-6 text-left font-semibold">Features</th>
                <th className="py-3 px-6 text-left font-semibold">Seats</th>
                <th className="py-3 px-6 text-left font-semibold">Status</th>
                <th className="py-3 px-6 text-left font-semibold">Location</th>
                <th className="py-3 px-6 text-left font-semibold">
                  Daily Price
                </th>
                <th className="py-3 px-6 text-left font-semibold">Image</th>
                <th className="py-3 px-6 text-left font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredCars.map((car) => (
                <tr key={car.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{car.id}</td>
                  <td className="py-3 px-6">{car.model}</td>
                  <td className="py-3 px-6">{car.year}</td>
                  <td className="py-3 px-6">{car.color}</td>
                  <td className="py-3 px-6">{car.features}</td>
                  <td className="py-3 px-6">{car.seats}</td>
                  <td className="py-3 px-6">{car.status}</td>
                  <td className="py-3 px-6">{car.location}</td>
                  <td className="py-3 px-6">
                    {car.daily_price}
                    {"$"}
                  </td>
                  <td className="py-3 px-6">
                    <img
                      src={`http://localhost:8000/storage/${car.image}`}
                      alt="Car"
                      className="w-20 h-14 object-cover rounded-md"
                    />
                  </td>
                  <td className="py-3 px-6">
                    <div className="flex items-center justify-between gap-2">
                      <button
                        onClick={() => deleteCar(car.id)}
                        className="text-red-600 cursor-pointer hover:text-red-800"
                        title="Delete"
                      >
                        <MdOutlineDeleteForever className="w-7 h-7" />
                      </button>
                      <Link to={`/dashboard/cars/${car.id}/edit`}>
                        <FaRegEdit className="w-6 h-6" />
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
              {filteredCars.length === 0 && (
                <tr>
                  <td colSpan="11" className="text-center py-6 text-gray-500">
                    No cars found.
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

export default Cars;
