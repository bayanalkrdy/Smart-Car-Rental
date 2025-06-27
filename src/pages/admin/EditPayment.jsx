import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";

const EditPayment = () => {
  const { id } = useParams();
  const [payment, setPayment] = useState({
    payment_method: "",
    amount: "",
    status: "pending",
    invoice: "",
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  useEffect(() => {
    const fetchPayment = async () => {
      const token = localStorage.getItem("token");
      try {
        const response = await axios.get(`http://localhost:8000/api/payments/${id}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        if (response.status === 200) {
          setPayment({
            payment_method: response.data.payment_method || "",
            amount: response.data.amount || "",
            status: response.data.status || "pending",
            invoice: response.data.invoice || "",
          });
        }
      } catch (error) {
        console.error("Error fetching payment data:", error);
        setMessage(" Error loading payment data.");
        clearMessageAfterDelay();
      }
    };

    fetchPayment();
  }, [id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setPayment((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});
    setMessage("");

    const token = localStorage.getItem("token");

    try {
      const response = await axios.put(`http://localhost:8000/api/payments/${id}`, payment, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (response.status === 200) {
        setMessage(" Payment updated successfully.");
        clearMessageAfterDelay();
      }
    } catch (error) {
      if (error.response && error.response.data.errors) {
        setErrors(error.response.data.errors);
      } else {
        setMessage(" Error updating payment.");
        clearMessageAfterDelay();
      }
    } finally {
      setLoading(false);
    }
  };

  const clearMessageAfterDelay = () => {
    setTimeout(() => {
      setMessage("");
    }, 4000); // 4 seconds
  };

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold text-gray-800">Edit Payment</h2>

      {message && <div className="text-center text-green-600 font-semibold">{message}</div>}
      <section className="mt-8">
        <form onSubmit={handleSubmit}>
          <div className="flex flex-row gap-16 justify-center">
            <div className="flex flex-col gap-5">
              <label>Payment Method:</label>
              <input
                type="text"
                name="payment_method"
                value={payment.payment_method}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter payment method"
              />
              {errors.payment_method && <span className="text-red-500 text-sm">{errors.payment_method[0]}</span>}

              <label>Amount:</label>
              <input
                type="number"
                name="amount"
                value={payment.amount}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter amount"
                min="0"
              />
              {errors.amount && <span className="text-red-500 text-sm">{errors.amount[0]}</span>}
            </div>

            <div className="flex flex-col gap-5">
              <label>Status:</label>
              <select
                name="status"
                value={payment.status}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] bg-white focus:shadow-sm shadow-blue-300 focus:outline-none"
              >
                <option value="pending">Pending</option>
                <option value="completed">Completed</option>
                <option value="failed">Failed</option>
              </select>
              {errors.status && <span className="text-red-500 text-sm">{errors.status[0]}</span>}
            </div>

            <div className="flex flex-col gap-5">
              <label>Invoice Number:</label>
              <input
                type="text"
                name="invoice"
                value={payment.invoice}
                onChange={handleChange}
                className="w-80 px-4 py-1.5 border border-gray-300 rounded-[100px] focus:shadow-sm shadow-blue-300 focus:outline-none"
                placeholder="Enter invoice number (optional)"
              />
              {errors.invoice && <span className="text-red-500 text-sm">{errors.invoice[0]}</span>}
            </div>
          </div>

          <div className="w-full flex justify-center py-12">
            <button
              type="submit"
              disabled={loading}
              className="w-80 px-4 py-2 bg-blue-500 text-white rounded-[100px] hover:bg-blue-600"
            >
              {loading ? "Updating..." : "Update Payment"}
            </button>
          </div>

          
        </form>
      </section>
    </div>
  );
};

export default EditPayment;
