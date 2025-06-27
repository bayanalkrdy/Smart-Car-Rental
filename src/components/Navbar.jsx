import React, { useEffect, useState } from "react";
import { IoIosSearch } from "react-icons/io";
import axios from "axios";
import ImageLogo from "../assets/logo/car-rental-logo.png";
const Navbar = () => {
  const [user, setUser] = useState({ name: "", license_image: "" });
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState(""); // قيمة البحث
  const [cars, setCars] = useState([]); // قائمة السيارات
  const [users, setUsers] = useState([]); // قائمة المستخدمين
  const [invoices, setInvoices] = useState([]); // قائمة الفواتير
  const [ratings, setRatings] = useState([]); // قائمة التقييمات
  const [categories, setCategories] = useState([]); // قائمة الفئات
  const [filteredData, setFilteredData] = useState([]); // البيانات المفلترة حسب البحث

  useEffect(() => {
    // تحميل بيانات المستخدم من التخزين المحلي
    const token = localStorage.getItem("token");
    const storedUser = JSON.parse(localStorage.getItem("user"));

    if (!token || !storedUser) {
      setLoading(false);
      return;
    }

    setUser({
      name: storedUser.name || "مستخدم",
      license_image: storedUser.license_image || "",
    });

    const headers = { Authorization: `Bearer ${token}` };

    // تحميل البيانات من API مع التأكد من التعامل مع الأخطاء
    axios
      .get("http://localhost:8000/api/cars", { headers })
      .then((response) => {
        setCars(response.data.data || []); // تأكد أن السيارات هي مصفوفة داخل data
      })
      .catch((error) => console.error("Error loading cars data:", error));

    axios
      .get("http://localhost:8000/api/admin/users", { headers })
      .then((response) => setUsers(response.data.users || []))
      .catch((error) => console.error("Error loading users data:", error));

    axios
      .get("http://localhost:8000/api/payments", { headers })
      .then((response) => setInvoices(response.data || []))
      .catch((error) => console.error("Error loading invoices data:", error));

    axios
      .get("http://localhost:8000/api/reviews", { headers })
      .then((response) => setRatings(response.data.reviews || []))
      .catch((error) => console.error("Error loading ratings data:", error));

    axios
      .get("http://localhost:8000/api/categories", { headers })
      .then((response) => setCategories(response.data || []))
      .catch((error) => console.error("Error loading categories data:", error));

    setLoading(false);
  }, []);

  // تحديث قيمة البحث
  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };

  // تصفية البيانات بناءً على قيمة البحث
  useEffect(() => {
    // التصفية فقط عندما يوجد نص في البحث
    if (searchQuery) {
      const filteredCars = cars.filter(
        (car) =>
          car.name && car.name.toLowerCase().includes(searchQuery.toLowerCase())
      );
      const filteredUsers = users.filter(
        (user) =>
          user.name &&
          user.name.toLowerCase().includes(searchQuery.toLowerCase())
      );
      const filteredInvoices = invoices.filter((invoice) =>
        invoice.id.toString().includes(searchQuery)
      );
      const filteredRatings = ratings.filter((rating) =>
        rating.score.toString().includes(searchQuery)
      );
      const filteredCategories = categories.filter(
        (category) =>
          category.name &&
          category.name.toLowerCase().includes(searchQuery.toLowerCase())
      );

      // دمج كل البيانات المفلترة
      setFilteredData({
        cars: filteredCars,
        users: filteredUsers,
        invoices: filteredInvoices,
        ratings: filteredRatings,
        categories: filteredCategories,
      });
    } else {
      // إذا كان نص البحث فارغًا، إفراغ البيانات المفلترة
      setFilteredData({});
    }
  }, [searchQuery, cars, users, invoices, ratings, categories]);

  if (loading) {
    return <p className="p-4">جاري تحميل بيانات المستخدم...</p>;
  }

  return (
    <div className="px-4 py-0.5 sm:px-6 bg-stone-50 border-b-2 border-gray-300 shadow-md shadow-blue-200">
      <div className="flex flex-col md:flex-row md:justify-between md:items-center gap-4">
        {/* Logo and title */}
        <div className="flex items-center gap-3">
          <div className="w-14 h-14 sm:w-16 sm:h-16 md:w-20 md:h-20 rounded-lg overflow-hidden">
            <img
              src={ImageLogo}
              alt="Car"
              className="w-full h-full object-cover"
            />
          </div>
          <h1 className="text-xl sm:text-2xl md:text-3xl capitalize font-semibold">
            Car rental
          </h1>
        </div>

        {/* Search bar */}
        <div className="relative w-full md:w-auto">
          <IoIosSearch className="text-xl sm:text-2xl text-blue-500 absolute left-4 top-2.5 sm:top-2" />
          <input
            type="text"
            placeholder="Search"
            value={searchQuery}
            onChange={handleSearchChange}
            className="border border-gray-300 w-full md:w-80 px-10 py-2 rounded-[100px] pl-12 text-sm sm:text-base focus:shadow-sm shadow-blue-300 focus:outline-none"
          />
        </div>

        {/* Search results */}
        {searchQuery && (
          <div className="absolute bg-white w-[90%] sm:w-80 shadow-lg p-4 rounded-lg z-10 left-1/2 top-24 sm:top-16 transform -translate-x-1/2 mt-2 text-sm">
            <ul>
              {filteredData.cars?.length > 0 && (
                <>
                  <h3 className="text-base font-semibold mb-2">السيارات:</h3>
                  {filteredData.cars.map((car) => (
                    <li key={car.id} className="p-1">
                      {car.name}
                    </li>
                  ))}
                </>
              )}
              {filteredData.users?.length > 0 && (
                <>
                  <h3 className="text-base font-semibold mb-2">المستخدمين:</h3>
                  {filteredData.users.map((user) => (
                    <li key={user.id} className="p-1">
                      {user.name}
                    </li>
                  ))}
                </>
              )}
              {filteredData.invoices?.length > 0 && (
                <>
                  <h3 className="text-base font-semibold mb-2">الفواتير:</h3>
                  {filteredData.invoices.map((invoice) => (
                    <li key={invoice.id} className="p-1">
                      فاتورة رقم: {invoice.id}
                    </li>
                  ))}
                </>
              )}
              {filteredData.ratings?.length > 0 && (
                <>
                  <h3 className="text-base font-semibold mb-2">التقييمات:</h3>
                  {filteredData.ratings.map((rating) => (
                    <li key={rating.id} className="p-1">
                      تقييم: {rating.score}
                    </li>
                  ))}
                </>
              )}
              {filteredData.categories?.length > 0 && (
                <>
                  <h3 className="text-base font-semibold mb-2">الفئات:</h3>
                  {filteredData.categories.map((category) => (
                    <li key={category.id} className="p-1">
                      {category.name}
                    </li>
                  ))}
                </>
              )}
            </ul>
          </div>
        )}

        {/* User info */}
        <div className="flex items-center gap-4 mr-5">
          {user.license_image ? (
            <img
              src={`http://localhost:8000/storage/${user.license_image}`}
              alt={user.name}
              className="w-10 h-10 object-cover rounded-[100px] border-2 border-gray-300"
            />
          ) : (
            <div className="w-8 h-8 sm:w-10 sm:h-10 rounded-full bg-gray-300 flex items-center justify-center text-white text-xs sm:text-sm">
              {user.name && user.name[0]}
            </div>
          )}
          <p className="capitalize text-sm font-semibold sm:text-base ">
            {user.name}
          </p>
        </div>
      </div>
    </div>
  );
};

export default Navbar;
