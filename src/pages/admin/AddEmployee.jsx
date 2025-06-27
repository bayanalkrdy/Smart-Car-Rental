import React, { useState, useEffect } from "react";
import axios from "axios";

const AddEmployee = () => {
  const [employee, setEmployee] = useState({
    name: "",
    email: "",
    password: "",
    phone: "",
    address: "",
    license_number: "",
    license_image: null,
    role: "Employee",
  });

  const [message, setMessage] = useState("");
  const [userRole, setUserRole] = useState("");
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({});

  useEffect(() => {
    const token = localStorage.getItem("token");
    const user = JSON.parse(localStorage.getItem("user"));

    if (token && user && user.role === "Admin") {
      setUserRole("authorized");
    } else {
      setUserRole("unauthorized");
      setMessage(" You are not authorized to add an employee.");
      setTimeout(() => setMessage(""), 1000);
    }
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEmployee({ ...employee, [name]: value });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    setEmployee({ ...employee, license_image: file });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (userRole === "unauthorized") {
      setMessage(" You are not authorized to add an employee.");
      setTimeout(() => setMessage(""), 1000);
      return;
    }

    const token = localStorage.getItem("token");
    if (!token) {
      setMessage(" Please log in first.");
      setTimeout(() => setMessage(""), 1000);
      return;
    }

    setLoading(true);
    setErrors({});
    const formData = new FormData();
    for (let key in employee) {
      if (employee[key]) {
        formData.append(key, employee[key]);
      }
    }

    try {
      const response = await axios.post("http://localhost:8000/api/add-employee", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      });

      if (response.status === 201) {
        setMessage(" Employee added successfully!");
        setEmployee({
          name: "",
          email: "",
          password: "",
          phone: "",
          address: "",
          license_number: "",
          license_image: null,
          role: "Employee",
        });
        setTimeout(() => setMessage(""), 4000);
      }
    } catch (error) {
      if (error.response?.data?.errors) {
        setErrors(error.response.data.errors);
      }

      if (error.response) {
        switch (error.response.status) {
          case 403:
            setMessage(" You are not authorized to add an employee.");
            break;
          case 401:
            setMessage(" Please log in first.");
            break;
          default:
            setMessage(" An error occurred while adding the employee.");
        }
      } else {
        setMessage(" An error occurred while adding the employee.");
      }
      setTimeout(() => setMessage(""), 1000);
      console.error("Error details:", error.response?.data);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className=" p-8">
      {/* Popup message */}
      {message && (
        <div className="fixed top-30 left-4/7 transform -translate-x-1/2 bg-green-100 text-green-800 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-500">
          {message}
        </div>
      )}

      <h1 className="capitalize text-3xl font-bold text-gray-800 ">Add Employee</h1>

      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            {/* Employee Fields */}
            <div className="flex flex-col gap-5">
              <label>Name:</label>
              <input
                type="text"
                name="name"
                value={employee.name}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter name"
                required
              />
              {errors.name && <span className="text-red-500 text-sm">{errors.name[0]}</span>}

              <label>Email:</label>
              <input
                type="email"
                name="email"
                value={employee.email}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter email"
                required
              />
              {errors.email && <span className="text-red-500 text-sm">{errors.email[0]}</span>}

              <label>Password:</label>
              <input
                type="password"
                name="password"
                value={employee.password}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter password"
                required
              />
              {errors.password && <span className="text-red-500 text-sm">{errors.password[0]}</span>}
            </div>

            {/* Other Fields */}
            <div className="flex flex-col gap-5">
              <label>Phone:</label>
              <input
                type="text"
                name="phone"
                value={employee.phone}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter phone"
                required
              />
              {errors.phone && <span className="text-red-500 text-sm">{errors.phone[0]}</span>}

              <label>Address:</label>
              <input
                type="text"
                name="address"
                value={employee.address}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter address"
                required
              />
              {errors.address && <span className="text-red-500 text-sm">{errors.address[0]}</span>}

              <label>License Number:</label>
              <input
                type="text"
                name="license_number"
                value={employee.license_number}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter license number"
                required
              />
              {errors.license_number && <span className="text-red-500 text-sm">{errors.license_number[0]}</span>}
            </div>

            {/* Image & Role */}
            <div className="flex flex-col gap-5">
              <label>Upload Photo:</label>
              <input
                type="file"
                name="license_image"
                onChange={handleImageChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full focus:shadow-sm shadow-blue-300 focus:outline-none"
              />
              {errors.license_image && <span className="text-red-500 text-sm">{errors.license_image[0]}</span>}

              <label>Role:</label>
              <select
                name="role"
                value={employee.role}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-full bg-white focus:shadow-sm shadow-blue-300 focus:outline-none"
              >
                <option value="Employee">Employee</option>
                <option value="Admin">Admin</option>
              </select>
              {errors.role && <span className="text-red-500 text-sm">{errors.role[0]}</span>}
            </div>
          </div>

          {/* Submit Button */}
          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              disabled={loading}
              className="w-80 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none transition-all duration-300"
            >
              {loading ? "Adding..." : "Add Employee"}
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};

export default AddEmployee;
