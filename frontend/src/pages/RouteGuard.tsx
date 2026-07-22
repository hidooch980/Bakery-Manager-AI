import {Navigate} from "react-router-dom";
import {useAuth} from "../auth/AuthContext";

export default function RouteGuard({children}:any){
 const {user}=useAuth();

 if(!user) return <Navigate to="/"/>;
 if(user.role!=="ADMIN") return <Navigate to="/"/>;

 return children;
}
