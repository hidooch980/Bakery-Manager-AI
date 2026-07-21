import {createContext,useContext,useState} from "react";

const AuthContext=createContext<any>(null);

export function AuthProvider({children}:any){
 const [user,setUser]=useState(()=>{
  const data=localStorage.getItem("user");
  return data?JSON.parse(data):null;
 });

 const login=(username:string)=>{
  const admin={
   username,
   role:"ADMIN",
   name:"مدیر نانوایی"
  };
  localStorage.setItem("user",JSON.stringify(admin));
  setUser(admin);
 };

 const logout=()=>{
  localStorage.removeItem("user");
  setUser(null);
 };

 return <AuthContext.Provider value={{user,login,logout}}>
  {children}
 </AuthContext.Provider>
}

export const useAuth=()=>useContext(AuthContext);
