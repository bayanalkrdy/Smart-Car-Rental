import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

const EditCategory = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  const [category, setCategory] = useState({
    name: "",
    description: "",
    car_id: "",
  });
  const [errors, setErrors] = useState({});
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  // Fetch category data on component mount
  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage("You must be logged in first.");
      return;
    }

    axios
      .get(`http://localhost:8000/api/categories/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((response) => {
        if (response.data) {
          setCategory(response.data);
        } else {
          setMessage("Category not found.");
        }
      })
      .catch((error) => {
        console.error("Error fetching category data", error);
        setMessage("Failed to load category data.");
      });
  }, [id]);

  const handleChange = (e) => {
    setCategory({ ...category, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");
    setErrors({});

    const token = localStorage.getItem("token");
    if (!token) {
      setMessage("You must be logged in first.");
      setLoading(false);
      return;
    }

    try {
      const response = await axios.put(
        `http://localhost:8000/api/categories/${id}`,
        category,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setMessage(response.data.message || "Category updated successfully.");
      navigate("/dashboard/categories");
    } catch (error) {
      if (error.response) {
        if (error.response.status === 403) {
          setMessage("You are not authorized to edit categories.");
        } else if (error.response.status === 422) {
          setErrors(error.response.data.errors);
        } else {
          setMessage("An error occurred while updating the category.");
        }
      } else {
        setMessage("Failed to connect to the server.");
      }
    } finally {
      setLoading(false);
    }
  };

  // Auto hide message after 4 seconds
  useEffect(() => {
    if (message) {
      const timer = setTimeout(() => {
        setMessage("");
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [message]);

  return (
    <div className="p-8">
      <h1 className="capitalize text-3xl font-bold text-gray-800">
        Edit Category
      </h1>

      {message && (
        <p className="mt-4 text-center text-green-600 font-semibold">{message}</p>
      )}

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            <div className="flex flex-col gap-5">
              <label>Category Name:</label>
              <input
                type="text"
                name="name"
                value={category.name || ""}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter category name"
                required
              />
              {errors.name && (
                <span className="text-red-500 text-sm">{errors.name[0]}</span>
              )}
            </div>

            <div className="flex flex-col gap-5">
              <label>Description:</label>
              <input
                type="text"
                name="description"
                value={category.description || ""}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter description"
              />
              {errors.description && (
                <span className="text-red-500 text-sm">
                  {errors.description[0]}
                </span>
              )}
            </div>

            <div className="flex flex-col gap-5">
              <label>Car ID:</label>
              <input
                type="text"
                name="car_id"
                value={category.car_id || ""}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter related car ID"
                required
              />
              {errors.car_id && (
                <span className="text-red-500 text-sm">{errors.car_id[0]}</span>
              )}
            </div>
          </div>

          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              disabled={loading}
              className="w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600"
            >
              {loading ? "Updating..." : "Update Category"}
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default EditCategory;
