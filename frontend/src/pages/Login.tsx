import {useState} from "react";
import {useNavigate} from "react-router-dom";

export default function Login(){
const [user,setUser]=useState("");
const [pass,setPass]=useState("");
const nav=useNavigate();

function login(){
if(user==="admin" && pass==="1234"){
localStorage.setItem("admin","true");
nav("/dashboard");
}
}

return <div dir="rtl" style={{height:"100vh",display:"flex",alignItems:"center",justifyContent:"center",background:"#f5efe5"}}>
<div style={{background:"#fff",padding:40,borderRadius:20,width:320,boxShadow:"0 5px 25px #ccc"}}>
<h2>🥖 مدیریت نانوایی</h2>
<input placeholder="نام کاربری" onChange={e=>setUser(e.target.value)} style={{width:"100%",padding:12,margin:10}}/>
<input placeholder="رمز عبور" type="password" onChange={e=>setPass(e.target.value)} style={{width:"100%",padding:12,margin:10}}/>
<button onClick={login} style={{width:"100%",padding:12}}>ورود مدیر</button>
</div>
</div>
}
