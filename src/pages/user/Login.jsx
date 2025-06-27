import React, { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import Imagecar from "../../assets/logo/ChatGPT Image Apr 29, 2025, 05_08_43 PM.png";

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const validateEmail = (email) => {
    const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return regex.test(email);
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    // إعادة تهيئة الخطأ وحالة التحميل عند كل محاولة
    setError("");
    setLoading(true);

    if (!validateEmail(email)) {
      setError("Invalid email address.");
      setLoading(false);
      return;
    }

    try {
      const { data } = await axios.post("http://localhost:8000/api/login", {
        email,
        password,
      });
      const { token, role, user } = data;

      // تخزين التوكن والمعلومات
      localStorage.setItem("token", token);
      localStorage.setItem("role", role);
      localStorage.setItem("user", JSON.stringify(user));

      // تفقد الصلاحيات
      if (role === "Admin" || role === "Employee") {
        navigate("/dashboard");
      } else {
        setError("You are not authorized to access this page.");
        setLoading(false);
      }
    } catch (err) {
      // إيقاف حالة التحميل وعرض رسالة الخطأ
      setLoading(false);
      const msg = err.response?.data?.message;
      setError(msg || "An unexpected error occurred. Please try again later.");
      console.error("Login error:", err);
    }
  };

  useEffect(() => {
    if (!error) return;
    const timer = setTimeout(() => setError(""), 4000);
    return () => clearTimeout(timer);
  }, [error]);

  return (
    <div
      className="min-h-screen bg-cover bg-center flex items-center justify-center"
      style={{ backgroundImage: `url(${Imagecar})` }}
    >
      <form
        onSubmit={handleLogin}
        className="bg-gray-800 opacity-90 backdrop-blur-sm p-8 rounded-2xl shadow-xl w-full max-w-sm space-y-6"
      >
        <h2 className="text-3xl font-extrabold text-white text-center">
          CAR RENTAL
        </h2>

        {error && (
          <p className="text-red-400 text-sm text-center animate-pulse">
            {error}
          </p>
        )}

        <input
          type="email"
          placeholder="Email Address"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full p-3 bg-gray-700 bg-opacity-50 placeholder-gray-300 text-white border border-gray-600 rounded focus:outline-none focus:ring-2 focus:ring-blue-400"
          required
        />

        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full p-3 bg-gray-700 bg-opacity-50 placeholder-gray-300 text-white border border-gray-600 rounded focus:outline-none focus:ring-2 focus:ring-blue-400"
          required
        />

        <div className="flex items-center justify-between text-sm text-gray-300">
          <label className="flex items-center space-x-2">
            <input
              type="checkbox"
              className="form-checkbox h-4 w-4 text-blue-400 bg-gray-700 border-gray-600 rounded"
            />
            <span>Remember me</span>
          </label>
         
        </div>

        <button
          type="submit"
          className="w-full py-3 rounded-lg font-semibold bg-blue-600 hover:bg-blue-700 text-white transition"
          disabled={loading}
        >
          {loading ? "Logging in..." : "Log in"}
        </button>
      </form>
    </div>
  );
};

export default Login;
