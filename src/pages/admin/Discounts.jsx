import React, { useEffect, useState } from "react";
import axios from "axios";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit, FaSearch } from "react-icons/fa";
import { Link } from "react-router-dom";

const Discounts = () => {
  const [discounts, setDiscounts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState("");
  const role = localStorage.getItem("role");
  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage("You must be logged in first.");
      setLoading(false);
      return;
    }

    axios
      .get("http://localhost:8000/api/discount", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((response) => {
        setDiscounts(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching discounts data", error);
        setMessage("Failed to load discounts data.");
        setLoading(false);
      });
  }, []);

  const deleteDiscount = async (id) => {
    const token = localStorage.getItem("token");
    if (!token) {
      setMessage("You must be logged in first.");
      return;
    }

    try {
      const response = await axios.delete(
        `http://localhost:8000/api/discount/${id}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200) {
        setMessage("Discount deleted successfully.");
        setDiscounts(discounts.filter((discount) => discount.id !== id));
      }
    } catch (error) {
      console.error("Error deleting discount", error);
      setMessage("An error occurred while deleting the discount.");
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

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  const filteredDiscounts = discounts.filter(
    (discount) =>
      discount.id.toString().includes(searchQuery.toLowerCase()) ||
      discount.car_id.toString().includes(searchQuery.toLowerCase()) ||
      discount.discount_type.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Discounts</h1>

      <div className="mt-10">
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">
            Discounts Table
          </h2>

          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search discounts..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-4 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-full"
            />
          </div>
        </div>

        {message && (
          <p className="text-green-600 my-4 font-semibold text-center">
            {message}
          </p>
        )}

        <div className="overflow-x-auto shadow-md rounded-2xl bg-white p-4 w-full mt-7">
          <table className="min-w-full table-auto">
            <thead className="bg-blue-100 text-blue-900">
              <tr>
                <th className="py-3 px-6 text-left font-semibold">
                  Discount ID
                </th>
                <th className="py-3 px-6 text-left font-semibold">Car ID</th>
                <th className="py-3 px-6 text-left font-semibold">
                  Discount Type
                </th>
                <th className="py-3 px-6 text-left font-semibold">
                  Discount Value (%)
                </th>
                <th className="py-3 px-6 text-left font-semibold">
                  Expiration Date
                </th>
                {role === "Admin" && (
                  <th className="py-3 px-6 text-center font-semibold">
                    Actions
                  </th>
                )}
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredDiscounts.map((discount) => (
                <tr key={discount.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{discount.id}</td>
                  <td className="py-3 px-6">{discount.car_id}</td>
                  <td className="py-3 px-6 capitalize">
                    {discount.discount_type}
                  </td>
                  <td className="py-3 px-6">{discount.discount_value}%</td>
                  <td className="py-3 px-6">{discount.expiration_date}</td>
                  {role === "Admin" && (
                    <td className="py-3 px-6 flex items-center justify-center gap-4">
                      <button
                        onClick={() => deleteDiscount(discount.id)}
                        className="text-red-600 hover:text-red-800 transition"
                        title="Delete Discount"
                      >
                        <MdOutlineDeleteForever className="w-7 h-7" />
                      </button>
                      <Link to={`/dashboard/editdiscount/edit/${discount.id}`}>
                        <FaRegEdit className="w-6 h-6 text-blue-600 hover:text-blue-800 transition" />
                      </Link>
                    </td>
                  )}
                </tr>
              ))}
              {filteredDiscounts.length === 0 && (
                <tr>
                  <td colSpan="6" className="text-center py-6 text-gray-500">
                    No discounts found.
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

export default Discounts;
