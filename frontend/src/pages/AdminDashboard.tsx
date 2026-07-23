import { useEffect, useState } from 'react';
import api from '../api/client';

export default function AdminDashboard() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    api.get('/dashboard/daily').then((res) => setData(res.data));
  }, []);

  if (!data) return <div>در حال بارگذاری...</div>;

  return (
    <div>
      <h2>داشبورد مدیر</h2>
      <div className="stat-grid">
        <div className="stat-card">
          <div className="label">فروش امروز</div>
          <div className="value">{data.today?.sales?.toLocaleString('fa-IR')}</div>
        </div>
        <div className="stat-card">
          <div className="label">هزینه امروز</div>
          <div className="value">{data.today?.expenses?.toLocaleString('fa-IR')}</div>
        </div>
        <div className="stat-card">
          <div className="label">سود امروز</div>
          <div className="value">{data.today?.profit?.toLocaleString('fa-IR')}</div>
        </div>
      </div>
    </div>
  );
}
