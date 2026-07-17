import { useEffect,useState } from 'react'
import './App.css'

type Data={
 id:string
 productionId:string
 flourKg:number
 doughCount:number
 breadCount:number
 totalCost:number
 createdAt:string
}

function App(){

const [data,setData]=useState<Data[]>([])

useEffect(()=>{
 fetch('http://185.97.118.255:3001/production-cost')
 .then(r=>r.json())
 .then(setData)
},[])

const flour=data.reduce((a,b)=>a+b.flourKg,0)
const dough=data.reduce((a,b)=>a+b.doughCount,0)
const bread=data.reduce((a,b)=>a+b.breadCount,0)
const cost=data.reduce((a,b)=>a+b.totalCost,0)

return(
<div className="page">

<h1>🥖 Bakery AI</h1>
<h2>داشبورد مدیریت تولید</h2>

<div className="cards">

<div className="card">
<h3>مصرف آرد</h3>
<strong>{flour} Kg</strong>
</div>

<div className="card">
<h3>تعداد چانه</h3>
<strong>{dough}</strong>
</div>

<div className="card">
<h3>تعداد نان</h3>
<strong>{bread}</strong>
</div>

<div className="card">
<h3>هزینه تولید</h3>
<strong>{cost.toLocaleString()}</strong>
</div>

</div>


<table>
<thead>
<tr>
<th>تولید</th>
<th>آرد</th>
<th>چانه</th>
<th>نان</th>
<th>هزینه</th>
<th>تاریخ</th>
</tr>
</thead>

<tbody>
{data.map(x=>
<tr key={x.id}>
<td>{x.productionId}</td>
<td>{x.flourKg}</td>
<td>{x.doughCount}</td>
<td>{x.breadCount}</td>
<td>{x.totalCost.toLocaleString()}</td>
<td>{new Date(x.createdAt).toLocaleDateString()}</td>
</tr>
)}
</tbody>

</table>

</div>
)

}

export default App
