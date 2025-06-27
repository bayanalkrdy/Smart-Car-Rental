import React, { useEffect, useState } from "react";
import axios from "axios";
import { MdOutlineDeleteForever } from "react-icons/md";
import { FaRegEdit, FaSearch } from "react-icons/fa"; 
import { Link } from "react-router-dom";

const Payments = () => {
  const [payments, setPayments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState(""); 

  useEffect(() => {
    const fetchPayments = async () => {
      const token = localStorage.getItem("token");

      if (!token) {
        setMessage("You must log in first");
        setLoading(false);
        return;
      }

      try {
        const response = await axios.get("http://localhost:8000/api/payments", {
          headers: { Authorization: `Bearer ${token}` },
        });

        setPayments(response.data);
      } catch (error) {
        console.error("Error fetching payment data:", error);
        setMessage("Unable to load payment data");
      } finally {
        setLoading(false);
      }
    };

    fetchPayments();
  }, []);

  const deletePayment = async (id) => {
    const token = localStorage.getItem("token");
    if (!token) {
      setMessage("You must log in first");
      return;
    }

    try {
      const response = await axios.delete(`http://localhost:8000/api/payments/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (response.status === 200) {
        setPayments((prevPayments) => prevPayments.filter((payment) => payment.id !== id));
        setMessage(" Payment deleted successfully");
      }
    } catch (error) {
      console.error("Error deleting payment:", error);
      setMessage("An error occurred while deleting the payment");
    }
  };

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  
  const filteredPayments = payments.filter((payment) =>
    payment.id.toString().includes(searchQuery.toLowerCase()) ||
    payment.booking_id.toString().includes(searchQuery.toLowerCase()) ||
    payment.payment_method.toLowerCase().includes(searchQuery.toLowerCase()) ||
    payment.status.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Payments</h1>

      <div className="mt-10">
        
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">Payments Table</h2>

          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search payments..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-4 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400 w-full"
            />
          </div>
        </div>

        {message && (
          <p className="text-center text-red-500 my-4 font-semibold">{message}</p>
        )}

        <div className="overflow-x-auto shadow-md rounded-lg bg-white p-4 w-full mt-7">
          <table className="min-w-full table-auto">
            <thead className="bg-blue-100 text-blue-900">
              <tr>
                <th className="py-3 px-6 text-left font-semibold">Invoice ID</th>
                <th className="py-3 px-6 text-left font-semibold">Booking ID</th>
                <th className="py-3 px-6 text-left font-semibold">Payment Method</th>
                <th className="py-3 px-6 text-left font-semibold">Amount</th>
                <th className="py-3 px-6 text-left font-semibold">Status</th>
                <th className="py-3 px-6 text-left font-semibold">Invoice</th>
                <th className="py-3 px-6 text-left font-semibold">Actions</th>
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredPayments.map((payment) => (
                <tr key={payment.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{payment.id}</td>
                  <td className="py-3 px-6">{payment.booking_id}</td>
                  <td className="py-3 px-6">{payment.payment_method}</td>
                  <td className="py-3 px-6">{payment.amount}</td>
                  <td className="py-3 px-6">{payment.status}</td>
                  <td className="py-3 px-6">
                    {payment.invoice ? payment.invoice : "No invoice"}
                  </td>
                  <td className="py-3 px-6">
                    <div className="flex items-center gap-3">
                      <button
                        onClick={() => deletePayment(payment.id)}
                        className="text-red-600 hover:text-red-800"
                        title="Delete Payment"
                      >
                        <MdOutlineDeleteForever className="w-7 h-7" />
                      </button>
                      <Link
                        to={`/dashboard/editpayment/edit/${payment.id}`}
                        className="text-blue-600 hover:text-blue-800"
                        title="Edit Payment"
                      >
                        <FaRegEdit className="w-6 h-6" />
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
              {filteredPayments.length === 0 && (
                <tr>
                  <td colSpan="7" className="text-center py-6 text-gray-500">
                    No payments found.
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

export default Payments;
