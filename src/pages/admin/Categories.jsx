import React, { useEffect, useState } from "react";
import axios from "axios";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit, FaSearch } from "react-icons/fa"; 
import { Link } from "react-router-dom";

const Categories = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage("You must be logged in first.");
      setLoading(false);
      return;
    }

    axios
      .get("http://localhost:8000/api/categories", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((response) => {
        setCategories(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching data", error);
        setMessage("Failed to load categories.");
        setLoading(false);
      });
  }, []);

  const handleDelete = async (id) => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage("You must be logged in first.");
      return;
    }

    try {
      const response = await axios.delete(
        `http://localhost:8000/api/categories/${id}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setMessage(response.data.message || "Category deleted successfully.");
      setCategories(categories.filter((category) => category.id !== id));
    } catch (error) {
      if (error.response) {
        if (error.response.status === 403) {
          setMessage("You are not authorized to delete categories.");
        } else {
          setMessage("An error occurred while deleting the category.");
        }
      } else {
        setMessage("Failed to connect to the server.");
      }
    }
  };

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

 
  const filteredCategories = categories.filter((category) =>
    category.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    (category.description && category.description.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Categories</h1>

      <div className="mt-10">
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">
            Categories Table
          </h2>

          
          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search categories..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-4 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-full"
            />
          </div>
        </div>

        {message && (
          <p className="text-red-500 my-4 font-semibold">{message}</p>
        )}

        <div className="overflow-x-auto shadow-md rounded-lg bg-white p-4 w-[100%] mt-7">
          <table className="min-w-full table-auto">
            <thead className="bg-blue-100 text-blue-900">
              <tr>
                <th className="py-3 px-6 text-left font-semibold">Car ID</th>
                <th className="py-3 px-6 text-left font-semibold">Category Name</th>
                <th className="py-3 px-6 text-left font-semibold">Description</th>
                <th className="py-3 px-6 text-left font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredCategories.map((category) => (
                <tr key={category.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{category.car_id}</td>
                  <td className="py-3 px-6">{category.name}</td>
                  <td className="py-3 px-6">{category.description}</td>
                  <td className="py-3 px-6">
                    <div className="flex items-center justify-between gap-2">
                      <button
                        onClick={() => handleDelete(category.id)}
                        className="text-red-600 cursor-pointer hover:text-red-800"
                        title="Delete"
                      >
                        <MdOutlineDeleteForever className="w-7 h-7" />
                      </button>
                      <Link to={`/dashboard/categories/edit/${category.id}`} title="Edit">
                        <FaRegEdit className="w-6 h-6" />
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
              {filteredCategories.length === 0 && (
                <tr>
                  <td colSpan="4" className="text-center py-6 text-gray-500">
                    No categories found.
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

export default Categories;
