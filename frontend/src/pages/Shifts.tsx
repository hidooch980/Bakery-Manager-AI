import { useEffect, useState } from 'react';
import api from '../api/client';

type Employee = { id: string; name: string };
type Shift = {
  id: string;
  employeeId: string;
  active: boolean;
  startTime: string;
  endTime?: string | null;
  breadReceived: number;
  cashDelivered: number;
  soldBread: number;
  shortage: number;
  totalDebt: number;
};

export default function Shifts() {
  const [shifts, setShifts] = useState<Shift[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [employeeId, setEmployeeId] = useState('');
  const [breadReceived, setBreadReceived] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/seller-shift').then((res) => setShifts(res.data));
    api.get('/employees').then((res) => setEmployees(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!employeeId) {
      setError('انتخاب فروشنده الزامی است');
      return;
    }
    try {
      await api.post('/seller-shift', {
        employeeId,
        breadReceived: Number(breadReceived) || 0,
      });
      setEmployeeId('');
      setBreadReceived('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  async function toggle(id: string) {
    await api.put(`/seller-shift/${id}/toggle`);
    load();
  }

  const employeeName = (id: string) => employees.find((e) => e.id === id)?.name ?? id;

  return (
    <div>
      <h2>تعریف شیفت فروش</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <select value={employeeId} onChange={(e) => setEmployeeId(e.target.value)}>
          <option value="">انتخاب فروشنده</option>
          {employees.map((emp) => (
            <option key={emp.id} value={emp.id}>{emp.name}</option>
          ))}
        </select>
        <input placeholder="تعداد نان تحویلی" type="number" value={breadReceived} onChange={(e) => setBreadReceived(e.target.value)} />
        <button className="btn-primary" type="submit">شروع شیفت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>فروشنده</th>
            <th>وضعیت</th>
            <th>نان تحویلی</th>
            <th>نان فروخته‌شده</th>
            <th>کسری</th>
            <th>بدهی کل</th>
            <th>شروع</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {shifts.map((s) => (
            <tr key={s.id}>
              <td>{employeeName(s.employeeId)}</td>
              <td>{s.active ? 'باز' : 'بسته'}</td>
              <td>{s.breadReceived}</td>
              <td>{s.soldBread}</td>
              <td>{s.shortage}</td>
              <td>{s.totalDebt.toLocaleString('fa-IR')}</td>
              <td>{new Date(s.startTime).toLocaleDateString('fa-IR')}</td>
              <td>
                <button className="btn-ghost" onClick={() => toggle(s.id)} type="button">
                  {s.active ? 'بستن شیفت' : 'بازکردن'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
