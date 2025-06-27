import React, { useEffect, useState } from "react";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit } from "react-icons/fa";
import axios from "axios";
import { Link } from "react-router-dom";
import { FaSearch } from "react-icons/fa";
const Users = () => {
  const [users, setUsers] = useState([]);
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
      .get("http://localhost:8000/api/admin/users", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((response) => {
        setUsers(response.data.users);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
        setMessage(" Failed to load users.");
        setLoading(false);
      });
  }, []);

  const deleteUser = async (userId) => {
    const token = localStorage.getItem("token");

    if (!token) {
      setMessage(" You must be logged in first.");
      return;
    }

    try {
      const response = await axios.delete(
        `http://localhost:8000/api/users/${userId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200 || response.status === 204) {
        setMessage(" User deleted successfully!");
        setUsers((prevUsers) => prevUsers.filter((user) => user.id !== userId));

        setTimeout(() => {
          setMessage("");
        }, 1500);
      }
    } catch (error) {
      if (error.response) {
        switch (error.response.status) {
          case 403:
            setMessage(" You do not have permission to delete this user.");
            break;
          case 404:
            setMessage(" User not found.");
            break;
          default:
            setMessage(" An error occurred while deleting.");
        }
      } else {
        setMessage(" An error occurred while deleting.");
      }
      console.error("Error details:", error.response?.data);
    }
  };

  const filteredUsers = users.filter(
    (user) => user.name.toLowerCase().includes(searchQuery.toLowerCase()) //  فلترة حسب الاسم
  );

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  return (
    <div className="p-16 relative">
      {message && (
        <div className="fixed top-96 left-1/2 transform -translate-x-1/2 bg-green-100 text-green-800 px-6 py-3 rounded-lg shadow-lg text-center font-semibold z-50 transition-all duration-500">
          {message}
        </div>
      )}

      <h1 className="capitalize text-3xl font-bold text-gray-800">Users</h1>

      <div className="mt-10">
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">
            Users Table
          </h2>
          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>

            <input
              type="text"
              placeholder="Search by name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="px-10 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-80"
            />
          </div>
        </div>

        <div className="overflow-x-auto shadow-md rounded-lg bg-white p-4 w-full mt-7">
          <table className="min-w-full table-auto">
            <thead className="bg-blue-100 text-blue-900">
              <tr>
                <th className="py-3 px-6 text-left font-semibold">User ID</th>
                <th className="py-3 px-6 text-left font-semibold">User Name</th>
                <th className="py-3 px-6 text-left font-semibold">Email</th>
                <th className="py-3 px-6 text-left font-semibold">Phone</th>
                <th className="py-3 px-6 text-left font-semibold">Location</th>
                <th className="py-3 px-6 text-left font-semibold">Role</th>
                <th className="py-3 px-6 text-left font-semibold">Picture</th>
                {role === "Admin" && (
                  <th className="py-3 px-6 text-left font-semibold">Action</th>
                )}
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredUsers.map((user) => (
                <tr key={user.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{user.id}</td>
                  <td className="py-3 px-6">{user.name}</td>
                  <td className="py-3 px-6">{user.email}</td>
                  <td className="py-3 px-6">{user.phone}</td>
                  <td className="py-3 px-6">{user.address}</td>
                  <td className="py-3 px-6">{user.role}</td>

                  <td className="py-3 px-6">
                    <img
                      src={`http://localhost:8000/storage/${user.license_image}`}
                      alt="user-license"
                      className="w-20 h-14 object-cover rounded-md"
                    />
                  </td>
                  {role === "Admin" && (
                    <td className="py-3 px-6">
                      <div className="flex items-center justify-between gap-2">
                        <button
                          onClick={() => deleteUser(user.id)}
                          className="cursor-pointer text-red-600 hover:text-red-800 transition"
                          title="Delete"
                        >
                          <MdOutlineDeleteForever className="w-7 h-7" />
                        </button>
                        <Link
                          to={`/dashboard/user/${user.id}/edit`}
                          title="Edit"
                        >
                          <FaRegEdit className="w-6 h-6 text-blue-500 hover:text-blue-900 transition" />
                        </Link>
                      </div>
                    </td>
                  )}
                </tr>
              ))}
              {filteredUsers.length === 0 && (
                <tr>
                  <td colSpan="8" className="text-center py-6 text-gray-500">
                    No users found.
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

export default Users;
