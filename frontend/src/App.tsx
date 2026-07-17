import {BrowserRouter,Routes,Route} from "react-router-dom";
import Login from "./pages/Login";
import AdminDashboard from "./pages/AdminDashboard";
import ProtectedRoute from "./auth/ProtectedRoute";

export default function App(){
return <BrowserRouter>
<Routes>
<Route path="/login" element={<Login/>}/>
<Route path="/dashboard" element={
<ProtectedRoute>
<AdminDashboard/>
</ProtectedRoute>
}/>
<Route path="*" element={<Login/>}/>
</Routes>
</BrowserRouter>
}
