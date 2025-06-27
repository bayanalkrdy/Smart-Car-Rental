import React, { useEffect, useState } from "react";
import axios from "axios";
import { FaSearch } from "react-icons/fa"; 

const Reviews = () => {
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState("");
  const [searchQuery, setSearchQuery] = useState(""); 

  useEffect(() => {
    const fetchReviews = async () => {
      const token = localStorage.getItem("token");

      if (!token) {
        setMessage("You must log in first");
        setLoading(false);
        return;
      }

      try {
        const response = await axios.get("http://localhost:8000/api/reviews", {
          headers: { Authorization: `Bearer ${token}` },
        });

        setReviews(response.data.reviews);
      } catch (error) {
        console.error("Error fetching reviews:", error);
        setMessage("Unable to load reviews");
      } finally {
        setLoading(false);
      }
    };

    fetchReviews();
  }, []);

  if (loading) {
    return <p className="p-16 text-xl font-semibold">Loading data...</p>;
  }

  
  const filteredReviews = reviews.filter((review) =>
    review.id.toString().includes(searchQuery.toLowerCase()) ||
    review.user_id.toString().includes(searchQuery.toLowerCase()) ||
    review.car_id.toString().includes(searchQuery.toLowerCase()) ||
    review.rating.toString().includes(searchQuery.toLowerCase()) ||
    (review.comment && review.comment.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  return (
    <div className="p-16">
      <h1 className="capitalize text-3xl font-bold text-gray-800">Reviews</h1>

      <div className="mt-10">
        
        <div className="flex justify-between items-center mb-6">
          <h2 className="capitalize text-2xl font-bold text-gray-700">Reviews Table</h2>

          <div className="relative w-80">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <FaSearch className="text-gray-400 w-4 h-4" />
            </div>
            <input
              type="text"
              placeholder="Search reviews..."
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
                <th className="py-3 px-6 text-left font-semibold">Review ID</th>
                <th className="py-3 px-6 text-left font-semibold">User ID</th>
                <th className="py-3 px-6 text-left font-semibold">Car ID</th>
                <th className="py-3 px-6 text-left font-semibold">Rating</th>
                <th className="py-3 px-6 text-left font-semibold">Comment</th>
              </tr>
            </thead>
            <tbody className="text-gray-700">
              {filteredReviews.map((review) => (
                <tr key={review.id} className="border-b hover:bg-blue-50">
                  <td className="py-3 px-6">{review.id}</td>
                  <td className="py-3 px-6">{review.user_id}</td>
                  <td className="py-3 px-6">{review.car_id}</td>
                  <td className="py-3 px-6">{review.rating}</td>
                  <td className="py-3 px-6">{review.comment || "No comment"}</td>
                </tr>
              ))}
              {filteredReviews.length === 0 && (
                <tr>
                  <td colSpan="5" className="text-center py-6 text-gray-500">
                    No reviews found.
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

export default Reviews;
