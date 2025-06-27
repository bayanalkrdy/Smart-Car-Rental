import React from "react";
import Navbar from "../../components/Navbar";
import Sidebar from "../../components/Sidebar";
import { Outlet } from "react-router-dom";

const Dashboard = () => {
  return (
    <div className="h-screen overflow-hidden">
      <div className="shadow-md shadow-blue-500">
      <Navbar className="fixed top-0 left-0 w-full z-50 " />
      </div>
      <div className="flex  h-screen bg-stone-50">
        {/* Sidebar */}
        <Sidebar className="fixed  left-0 w-[15%] h-[85vh] bg-stone-50 z-40 overflow-y-auto" />

        <main className=" w-[85%] h-[90vh] overflow-y-auto bg-stone-50 p-4">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default Dashboard;
