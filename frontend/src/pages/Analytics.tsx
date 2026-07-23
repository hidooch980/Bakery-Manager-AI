import { useEffect, useState } from 'react';
import api from '../api/client';

export default function Analytics() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    api.get('/profit-dashboard').then((res) => setData(res.data));
  }, []);

  if (!data) return <div>در حال بارگذاری...</div>;

  return (
    <div>
      <h2>تحلیل و سود</h2>
      <div className="stat-grid">
        <div className="stat-card">
          <div className="label">فروش کل</div>
          <div className="value">{data.totalSales?.toLocaleString('fa-IR')}</div>
        </div>
        <div className="stat-card">
          <div className="label">هزینه کل</div>
          <div className="value">{data.totalCost?.toLocaleString('fa-IR')}</div>
        </div>
        <div className="stat-card">
          <div className="label">سود خالص</div>
          <div className="value">{data.profit?.toLocaleString('fa-IR')}</div>
        </div>
      </div>
      <div className="card">
        <h3>جزئیات</h3>
        <table>
          <tbody>
            {Object.entries(data.breakdown || {}).map(([k, v]: any) => (
              <tr key={k}>
                <td>{k}</td>
                <td>{typeof v === 'number' ? v.toLocaleString('fa-IR') : v}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
