import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";

const EditUser = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  const [user, setUser] = useState({
    name: "",
    email: "",
    phone: "",
    address: "",
    role: "",
    license_number: "",
    license_image: null,
    password: "",
  });
  const [message, setMessage] = useState("");
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchUser = async () => {
      const token = localStorage.getItem("token");
      try {
        const res = await axios.get(
          `http://localhost:8000/api/admin/users/${id}`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        const data = res.data.user || res.data;
        setUser({
          name: data.name || "",
          email: data.email || "",
          phone: data.phone || "",
          address: data.address || "",
          role: res.data.role || data.role || "",
          license_number: data.license_number || "",
          license_image: data.license_image || null,
          password: "",
        });
      } catch (err) {
        setMessage(" Failed to load user data.");
        console.error(err);
      }
    };
    fetchUser();
  }, [id]);

  // ✨ هنا التايمر لحذف الرسالة بعد 3 ثواني
  useEffect(() => {
    if (message) {
      const timer = setTimeout(() => {
        setMessage("");
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [message]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUser((u) => ({ ...u, [name]: value }));
  };

  const handleImageChange = (e) => {
    setUser((u) => ({ ...u, license_image: e.target.files[0] }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");
    setErrors({});

    const formData = new FormData();
    formData.append("name", user.name);
    formData.append("email", user.email);
    formData.append("phone", user.phone);
    formData.append("address", user.address);
    formData.append("license_number", user.license_number);
    formData.append("role", user.role);
    if (user.password.trim()) {
      formData.append("password", user.password);
    }
    if (user.license_image && typeof user.license_image !== "string") {
      formData.append("license_image", user.license_image);
    }

    try {
      const token = localStorage.getItem("token");
      const res = await axios.post(
        `http://localhost:8000/api/users/${id}?_method=PUT`,
        formData,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "multipart/form-data",
          },
        }
      );
      if (res.status === 200) {
        setMessage(" User updated successfully!");
        navigate("/dashboard/users");
      }
    } catch (err) {
      if (err.response?.status === 422) {
        setErrors(err.response.data.errors || {});
        setMessage(" Please check the fields.");
      } else if (err.response?.status === 403) {
        setMessage(" You are not authorized.");
      } else {
        setMessage(" Update failed.");
      }
      console.error("Error details:", err.response?.data);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-8">
      {/* Popup message */}
      {message && (
        <div className="fixed top-30 left-4/7 transform -translate-x-1/2 bg-green-100 text-green-800 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-500">
          {message}
        </div>
      )}

      <h1 className="capitalize text-3xl font-bold text-gray-800">Edit User</h1>

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            {/* First column */}
            <div className="flex flex-col gap-5">
              <label>Name:</label>
              <input
                type="text"
                name="name"
                value={user.name}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter name"
              />
              {errors.name && (
                <span className="text-red-500 text-sm">{errors.name[0]}</span>
              )}

              <label>Email:</label>
              <input
                type="email"
                name="email"
                value={user.email}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter email"
              />
              {errors.email && (
                <span className="text-red-500 text-sm">{errors.email[0]}</span>
              )}
              <label>Password (optional):</label>
              <input
                type="password"
                name="password"
                value={user.password}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter new password"
              />
              {errors.password && (
                <span className="text-red-500 text-sm">
                  {errors.password[0]}
                </span>
              )}
            </div>

            {/* Second column */}
            <div className="flex flex-col gap-5">
              <label>Phone:</label>
              <input
                type="text"
                name="phone"
                value={user.phone}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter phone"
              />
              {errors.phone && (
                <span className="text-red-500 text-sm">{errors.phone[0]}</span>
              )}
              <label>Address:</label>
              <input
                type="text"
                name="address"
                value={user.address}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter address"
              />
              {errors.address && (
                <span className="text-red-500 text-sm">
                  {errors.address[0]}
                </span>
              )}
              <label>License Number:</label>
              <input
                type="text"
                name="license_number"
                value={user.license_number}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter license number"
              />
              {errors.license_number && (
                <span className="text-red-500 text-sm">
                  {errors.license_number[0]}
                </span>
              )}
            </div>
              <div className="flex flex-col gap-5">
                <label>Role:</label>
                <select
                  name="role"
                  value={user.role}
                  onChange={handleChange}
                  className="w-80 px-4 py-1.5 border border-gray-300 rounded-full bg-white focus:shadow-sm shadow-blue-300 focus:outline-none"
                >
                  <option value="">Select Role</option>
                  <option value="Admin">Admin</option>
                  <option value="Employee">Employee</option>
                </select>
                {errors.role && (
                  <span className="text-red-500 text-sm">{errors.role[0]}</span>
                )}

                <label>License Image (optional):</label>
                <input
                  type="file"
                  name="license_image"
                  onChange={handleImageChange}
                  className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                />
                {errors.license_image && (
                  <span className="text-red-500 text-sm">
                    {errors.license_image[0]}
                  </span>
                )}
              </div>
            
          </div>

          {/* Submit button */}
          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              disabled={loading}
              className="w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none transition-all duration-300"
            >
              {loading ? "Updating..." : "Update User"}
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default EditUser;
