import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Login from "./pages/Login";
import AdminDashboard from "./pages/AdminDashboard";
import Dashboard from "./pages/Dashboard";
import Sales from "./pages/Sales";
import Production from "./pages/Production";
import Expenses from "./pages/Expenses";
import Products from "./pages/Products";
import Employees from "./pages/Employees";
import Users from "./pages/Users";
import Analytics from "./pages/Analytics";
import Inventory from "./pages/Inventory";
import Cashbox from "./pages/Cashbox";
import Payroll from "./pages/Payroll";
import FinancialReport from "./pages/FinancialReport";
import Shifts from "./pages/Shifts";
import BreadTypes from "./pages/BreadTypes";
import Nanino from "./pages/Nanino";
import FlourPurchase from "./pages/FlourPurchase";
import FlourSale from "./pages/FlourSale";
import DoughWeightControl from "./pages/DoughWeightControl";
import CafeMenu from "./pages/CafeMenu";
import CafeOrders from "./pages/CafeOrders";
import ProtectedRoute from "./auth/ProtectedRoute";
import Layout from "./components/Layout";
import { AuthProvider } from "./auth/AuthContext";

function Protected({ children }: { children: React.ReactNode }) {
  return (
    <ProtectedRoute>
      <Layout>{children}</Layout>
    </ProtectedRoute>
  );
}

const routes: Array<{ path: string; element: React.ReactNode }> = [
  { path: "/dashboard", element: <AdminDashboard /> },
  { path: "/sales", element: <Sales /> },
  { path: "/production", element: <Production /> },
  { path: "/expenses", element: <Expenses /> },
  { path: "/products", element: <Products /> },
  { path: "/employees", element: <Employees /> },
  { path: "/users", element: <Users /> },
  { path: "/analytics", element: <Analytics /> },
  { path: "/inventory", element: <Inventory /> },
  { path: "/cashbox", element: <Cashbox /> },
  { path: "/payroll", element: <Payroll /> },
  { path: "/financial-report", element: <FinancialReport /> },
  { path: "/shifts", element: <Shifts /> },
  { path: "/bread-types", element: <BreadTypes /> },
  { path: "/nanino", element: <Nanino /> },
  { path: "/flour-purchase", element: <FlourPurchase /> },
  { path: "/flour-sale", element: <FlourSale /> },
  { path: "/dough-weight-control", element: <DoughWeightControl /> },
  { path: "/cafe-menu", element: <CafeMenu /> },
  { path: "/cafe-orders", element: <CafeOrders /> },
  { path: "/report", element: <Dashboard /> },
];

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<Login />} />
          {routes.map((r) => (
            <Route
              key={r.path}
              path={r.path}
              element={<Protected>{r.element}</Protected>}
            />
          ))}
          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}
