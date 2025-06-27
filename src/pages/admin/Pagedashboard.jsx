import React, { useState, useEffect } from "react";
import axios from "axios";
import { Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler,
} from "chart.js";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
);
import { IoCarSportOutline } from "react-icons/io5";
import { FaRegUser } from "react-icons/fa";
import { IoNewspaperOutline } from "react-icons/io5";
import { CiDiscount1 } from "react-icons/ci";

const Pagedashboard = () => {
  const [accounts, setAccounts] = useState(0);
  const [cars, setCars] = useState(0);
  const [bookings, setBookings] = useState(0);
  const [discounts, setDiscounts] = useState(0);
  const [bookingData, setBookingData] = useState([]);
  const [userData, setUserData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem("token");

      if (!token) {
        setMessage(" Please log in first.");
        setLoading(false);
        return;
      }

      try {
        const accountsResponse = await axios.get(
          "http://localhost:8000/api/admin/users",
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setAccounts(accountsResponse.data.users.length);

        const carsResponse = await axios.get("http://localhost:8000/api/cars", {
          headers: { Authorization: `Bearer ${token}` },
        });
        setCars(carsResponse.data.data.length);

        const bookingsResponse = await axios.get(
          "http://localhost:8000/api/bookings",
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setBookings(bookingsResponse.data.length);

        const discountsResponse = await axios.get(
          "http://localhost:8000/api/discount",
          {
            headers: { Authorization: `Bearer ${token}` },
          }
        );
        setDiscounts(discountsResponse.data.length);

        const dailyBookings = bookingsResponse.data.reduce((acc, booking) => {
          const startDateString = booking.start_date;
          if (!startDateString) return acc;
          const date = new Date(startDateString);
          if (isNaN(date)) return acc;
          const formattedDate = date.toLocaleDateString("ar-EG");
          acc[formattedDate] = (acc[formattedDate] || 0) + 1;
          return acc;
        }, {});
        setBookingData(
          Object.entries(dailyBookings).map(([date, count]) => ({
            date,
            count,
          }))
        );

        const dailyUsers = accountsResponse.data.users.reduce((acc, user) => {
          const userDateString = user.created_at;
          if (!userDateString) return acc;
          const date = new Date(userDateString);
          const formattedDate = date.toLocaleDateString("ar-EG");
          acc[formattedDate] = (acc[formattedDate] || 0) + 1;
          return acc;
        }, {});
        setUserData(
          Object.entries(dailyUsers).map(([date, count]) => ({ date, count }))
        );

        setLoading(false);
      } catch (error) {
        console.error("Error fetching data:", error);
        setMessage(" An error occurred while fetching the data.");
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <p className="p-16 text-xl font-semibold text-gray-600">
        Loading data...
      </p>
    );
  }

  const bookingChartData = {
    labels: bookingData.map((data) => data.date),
    datasets: [
      {
        label: "Daily Bookings Count",
        data: bookingData.map((data) => data.count),
        borderColor: "#60A5FA", // Light blue
        backgroundColor: "rgba(96, 165, 250, 0.2)",
        fill: true,
      },
    ],
  };

  const userChartData = {
    labels: userData.map((data) => data.date),
    datasets: [
      {
        label: "New Users Count",
        data: userData.map((data) => data.count),
        borderColor: "#818CF8", // Light purple
        backgroundColor: "rgba(129, 140, 248, 0.2)",
        fill: true,
      },
    ],
  };

  const options = {
    scales: {
      x: {
        type: "category",
        title: {
          display: true,
          text: "Date",
        },
      },
      y: {
        title: {
          display: true,
          text: "Count",
        },
      },
    },
  };

  return (
    <div className="p-8 bg-stone-50 min-h-screen w-full">
      <h1 className="text-3xl font-bold text-gray-700 mb-8">Dashboard</h1>

      <div className="bg-white p-6 rounded-xl shadow-md mb-10">
        {message && (
          <p className="text-red-500 mb-4 font-semibold">{message}</p>
        )}

        {/* Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-10">
          {/* Accounts card */}
          <div className="bg-blue-100 hover:bg-blue-200 transition p-6 rounded-xl shadow">
            <div className=" flex gap-4 items-center">
              <FaRegUser className="mb-2 text-gray-600" />
              <h3 className="text-lg font-semibold text-gray-600 mb-2 ">
                Accounts
              </h3>
            </div>
            <p className="text-2xl font-bold text-gray-700 ">{accounts}</p>
          </div>

          {/* Cars card */}
          <div className="bg-blue-100 hover:bg-blue-200 transition p-6 rounded-xl shadow">
            <div className=" flex gap-4 items-center">
              <IoCarSportOutline className="mb-2 text-gray-600 size-6" />
              <h3 className="text-lg font-semibold text-gray-600 mb-2 ">
                Cars
              </h3>
            </div>
            <p className="text-2xl font-bold text-gray-700 ">{cars}</p>
          </div>

          {/* Bookings card */}
          <div className="bg-blue-50 hover:bg-blue-200 transition p-6 rounded-xl shadow">
            <div className=" flex gap-4 items-center">
              <IoNewspaperOutline className="mb-2 text-gray-600 size-5" />
              <h3 className="text-lg font-semibold text-gray-600 mb-2 ">
                Bookings
              </h3>
            </div>
            <p className="text-2xl font-bold text-gray-700 ">{bookings}</p>
          </div>

          {/* Discounts card */}
          <div className="bg-blue-50 hover:bg-blue-200 transition p-6 rounded-xl shadow">
            <div className=" flex gap-4 items-center">
              <CiDiscount1 className="mb-2 text-gray-600 size-6" />
              <h3 className="text-lg font-semibold text-gray-600 mb-2 ">
                Discounts
              </h3>
            </div>
            <p className="text-2xl font-bold text-gray-700 ">{discounts}</p>
          </div>
        </div>

        {/* Booking chart */}
        <div className="bg-blue-50 p-6 rounded-xl shadow mb-10">
          <h3 className="text-xl font-semibold text-gray-700 mb-4">
            Booking Statistics
          </h3>
          <Line data={bookingChartData} options={options} />
        </div>

        {/* User chart */}
        <div className="bg-blue-50 p-6 rounded-xl shadow">
          <h3 className="text-xl font-semibold text-gray-700 mb-4">
            User Statistics
          </h3>
          <Line data={userChartData} options={options} />
        </div>
      </div>
    </div>
  );
};

export default Pagedashboard;
