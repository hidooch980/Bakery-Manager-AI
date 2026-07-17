import {useEffect,useState} from "react";
import axios from "axios";

export default function Dashboard(){

const [data,setData]=useState<any>(null);

useEffect(()=>{
 axios.get("/api/daily-report")
 .then(r=>setData(r.data))
},[]);

if(!data) return <div>در حال دریافت اطلاعات...</div>;

return <div dir="rtl" style={{padding:30,fontFamily:"Tahoma",background:"#f6f1e8",minHeight:"100vh"}}>
<h1>🥖 داشبورد مدیریت نانوایی</h1>

<div style={{display:"grid",gridTemplateColumns:"repeat(3,1fr)",gap:20}}>

<Card t="تولید امروز" v={data.production.breadCount}/>
<Card t="چانه تولیدی" v={data.production.doughCount}/>
<Card t="مصرف آرد" v={data.production.flourBags+" کیسه"}/>
<Card t="فروش" v={data.sales.total}/>
<Card t="هزینه" v={data.expenses}/>
<Card t="بدهی فروشنده" v={data.sellerDebt.open}/>

</div>

</div>
}

function Card(p:any){
return <div style={{
background:"#fff",
padding:25,
borderRadius:20,
boxShadow:"0 5px 15px #ddd"
}}>
<h3>{p.t}</h3>
<h2>{p.v}</h2>
</div>
}
