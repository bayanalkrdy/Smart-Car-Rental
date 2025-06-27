import React from "react";
import { Link, useNavigate } from "react-router-dom";
import {
  MdOutlineSpaceDashboard,
  MdOutlineCategory,
  MdPayment,
  MdOutlineReviews,
} from "react-icons/md";
import { FaRegUser } from "react-icons/fa";
import { RiDiscountPercentLine } from "react-icons/ri";
import { TbBrandBooking } from "react-icons/tb";
import { IoCarSportOutline, IoNotificationsOutline } from "react-icons/io5";
import { BiLogOut } from "react-icons/bi";

const Sidebar = () => {
  const navigate = useNavigate();
  const role = localStorage.getItem("role");

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("role");

    if (window.socket) {
      window.socket.close();
      console.log(" تم إغلاق الاتصال بـ WebSocket");
    }

    navigate("/login");
  };

  return (
    <div className="hidden md:block md:w-[15%] bg-blue-300 p-8 rounded-tr-[100px] sticky top-0 h-screen overflow-y-auto">
      <div className="pt-6">
        <ul className="flex flex-col gap-y-3 text-gray-900 font-semibold text-sm md:text-base lg:text-lg">
          <li>
            <div className="flex items-center gap-3">
              <MdOutlineSpaceDashboard />
              <Link to="pagedashboard">Dashboard</Link>
            </div>
          </li>

          <li className="relative group">
            <div className="flex items-center gap-3">
              <Link to="addEmployee">
                <FaRegUser />
              </Link>
              <Link to="users">User</Link>
            </div>
            <ul className="hidden group-hover:block bg-blue-100 mt-2 rounded-md p-2 space-y-2 ml-5 text-xs md:text-sm">
              {role === "Admin" && (
                <li>
                  <Link to="addEmployee">Add Employee</Link>
                </li>
              )}
              {role === "Employee" && (
                <li>
                  <Link to="adduserbyemployee">Add User</Link>
                </li>
              )}
            </ul>
          </li>

          <li className="relative group">
            <div className="flex items-center gap-3">
              <Link to="booking">
                <TbBrandBooking />
              </Link>
              <Link to="booking">Booking</Link>
            </div>
            <ul className="hidden group-hover:block bg-blue-100 mt-2 rounded-md p-2 space-y-2 ml-5 text-xs md:text-sm">
              {role === "Admin" && (
                <li>
                  <Link to="addbooking">Add</Link>
                </li>
              )}
            </ul>
          </li>

          <li className="relative group">
            <div className="flex items-center gap-3">
              <Link to="car">
                <IoCarSportOutline />
              </Link>
              <Link to="car">Car</Link>
            </div>
            <ul className="hidden group-hover:block bg-blue-100 mt-2 rounded-md p-2 space-y-2 ml-5 text-xs md:text-sm">
              <li>
                <Link to="addcar">Add</Link>
              </li>
            </ul>
          </li>

          <li className="relative group">
            <div className="flex items-center gap-3">
              <Link to="categories">
                <MdOutlineCategory />
              </Link>
              <Link to="categories">Category</Link>
            </div>
            {role === "Admin" && (
              <ul className="hidden group-hover:block bg-blue-100 mt-2 rounded-md p-2 space-y-2 ml-5 text-xs md:text-sm">
                <li>
                  <Link to="addcategory">Add</Link>
                </li>
              </ul>
            )}
          </li>

          <li className="relative group">
            <div className="flex items-center gap-3">
              <Link to="Discounts">
                <RiDiscountPercentLine />
              </Link>
              <Link to="Discounts">Discount</Link>
            </div>
            <ul className="hidden group-hover:block bg-blue-100 mt-2 rounded-md p-2 space-y-2 ml-5 text-xs md:text-sm">
              {role === "Admin" && (
                <li>
                  <Link to="adddiscount">Add</Link>
                </li>
              )}
            </ul>
          </li>


          <li>
            <div className="flex items-center gap-3">
              <Link to="payments">
                <MdPayment />
              </Link>
              <Link to="payments">Payment</Link>
            </div>
          </li>

          <li>
            <div className="flex items-center gap-3">
              <Link to="reviews">
                <MdOutlineReviews />
              </Link>
              <Link to="reviews">Review</Link>
            </div>
          </li>
        </ul>
      </div>

      {/* Logout */}
      <div className="absolute bottom-28 left-5 flex items-center gap-3 text-sm md:text-base">
        <Link to="/" onClick={handleLogout} className=" text-lg">
          <BiLogOut />
        </Link>
        <Link to="/" onClick={handleLogout} className=" font-semibold text-lg">
          Logout
        </Link>
      </div>
    </div>
  );
};

export default Sidebar;
