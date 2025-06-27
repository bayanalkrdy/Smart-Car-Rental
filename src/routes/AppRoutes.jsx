import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import PrivateRoute from "./PrivateRoute";

// الصفحات

import Login from "../pages/user/Login";
import Dashboard from "../pages/admin/Dashboard";
import Pagedashboard from "../pages/admin/Pagedashboard";
import Cars from "../pages/admin/Cars";
import Bookings from "../pages/admin/Bookings";
import Categories from "../pages/admin/Categories";
import Discounts from "../pages/admin/Discounts";
import Addcar from "../pages/admin/Addcar";
import Editecar from "../pages/admin/Editecar";
import AddEmployee from "../pages/admin/AddEmployee";
import Users from "../pages/admin/Users";
import EditUsers from "../pages/admin/EditUsers";
import AddUserbyemployee from "../pages/admin/AddUserbyemployee";
import AddCategory from "../pages/admin/AddCategories";
import EditCategory from "../pages/admin/EditCategory";
import AddBooking from "../pages/admin/AddBooking ";
import EditBooking from "../pages/admin/EditBooking ";
import AddDiscount from "../pages/admin/AddDiscount";
import EditDiscount from "../pages/admin/EditDiscount";
import Payments from "../pages/admin/Payments ";
import EditPayment from "../pages/admin/EditPayment";
import Reviews from "../pages/admin/Reviews ";

const AppRoutes = () => {
  return (
    <Router>
      <Routes>
        {/* صفحة تسجيل الدخول */}
        <Route path="/" element={<Login />} />

        {/* مسارات داخلية محمية */}
        <Route path="/dashboard" element={<PrivateRoute><Dashboard /></PrivateRoute>}>
          <Route index element={<Pagedashboard />} />
          <Route path="pagedashboard" element={<Pagedashboard />} />
          <Route path="car" element={<Cars />} />
          <Route path="booking" element={<Bookings />} />
          <Route path="categories" element={<Categories />} />
          <Route path="discounts" element={<Discounts />} />
          <Route path="addcar" element={<Addcar />} />
          <Route path="cars/:id/edit" element={<Editecar />} />
          <Route path="user/:id/edit" element={<EditUsers />} />
          <Route path="addEmployee" element={<AddEmployee />} />
          <Route path="users" element={<Users />} />
          <Route path="adduserbyemployee" element={<AddUserbyemployee />} />
          <Route path="addcategory" element={<AddCategory />} />
          <Route path="categories/edit/:id" element={<EditCategory />} />
          <Route path="addbooking" element={<AddBooking />} />
          <Route path="editbooking/edit/:id" element={<EditBooking />} />
          <Route path="adddiscount" element={<AddDiscount />} />
          <Route path="editdiscount/edit/:id" element={<EditDiscount />} />
          <Route path="payments" element={<Payments />} />
          <Route path="editpayment/edit/:id" element={<EditPayment />} />
          <Route path="reviews" element={<Reviews />} />
          <Route path="*" element={<Navigate to="/dashboard/pagedashboard" replace />} />
        </Route>

        {/* fallback لو الرابط ما يتطابق مع أي شيء */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
};

export default AppRoutes;
