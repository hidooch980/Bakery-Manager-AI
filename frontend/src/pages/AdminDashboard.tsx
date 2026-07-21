import {useEffect,useState} from "react";
import axios from "axios";
import {BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer} from "recharts";
import {Wheat, Wallet, TrendingUp} from "lucide-react";

export default function AdminDashboard(){

const [data,setData]=useState<any>(null);

useEffect(()=>{
 Promise.all([
 axios.get("/api/daily-report"),
 axios.get("/api/bread-type")
 ]).then(([report,bread])=>{
 setData({...report.data,bread:bread.data})
 })
},[]);

if(!data) return <div>در حال بارگذاری داشبورد...</div>;

const chart=[
{name:"تولید",value:data.production.breadCount},
{name:"چانه",value:data.production.doughCount},
{name:"آرد",value:data.production.flourBags}
];

return <div dir="rtl" style={{padding:30,background:"#faf6ee",minHeight:"100vh"}}>

<h1>🥖 داشبورد مدیریت هوشمند نانوایی</h1>

<div style={{display:"grid",gridTemplateColumns:"repeat(auto-fit,minmax(220px,1fr))",gap:20}}>

<Card icon={<Wheat/>} title="تولید امروز" value={data.production.breadCount}/>
<Card icon={<Wheat/>} title="مصرف آرد" value={data.production.flourBags}/>
<Card icon={<Wallet/>} title="فروش امروز" value={data.sales.total}/>
<Card icon={<TrendingUp/>} title="سود/زیان" value={data.profit}/>

</div>

<div style={{marginTop:40,height:350,background:"#fff",padding:20,borderRadius:20}}>
<ResponsiveContainer>
<BarChart data={chart}>
<XAxis dataKey="name"/>
<YAxis/>
<Tooltip/>
<Bar dataKey="value"/>
</BarChart>
</ResponsiveContainer>
</div>

</div>
}

function Card({icon,title,value}:any){
return <div style={{
background:"#fff",
padding:25,
borderRadius:20,
boxShadow:"0 5px 20px #ddd"
}}>
{icon}
<h3>{title}</h3>
<h2>{value}</h2>
</div>
}
