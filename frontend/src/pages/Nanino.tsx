import { useEffect, useState } from 'react';
import api from '../api/client';

type Employee = { id: string; name: string };
type NaninoRow = {
  id: string;
  date: string;
  period: string;
  employeeId?: string | null;
  sellingDoughCount: number;
  naninoDoughCount: number;
  difference: number;
  sellingWeight: number;
  naninoWeight: number;
  weightDifference: number;
  note?: string | null;
};

export default function Nanino() {
  const [rows, setRows] = useState<NaninoRow[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [period, setPeriod] = useState('');
  const [employeeId, setEmployeeId] = useState('');
  const [sellingDoughCount, setSellingDoughCount] = useState('');
  const [naninoDoughCount, setNaninoDoughCount] = useState('');
  const [sellingWeight, setSellingWeight] = useState('');
  const [naninoWeight, setNaninoWeight] = useState('');
  const [note, setNote] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/nanino').then((res) => setRows(res.data.data || []));
    api.get('/employees').then((res) => setEmployees(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!period) {
      setError('عنوان دوره الزامی است');
      return;
    }
    try {
      await api.post('/nanino', {
        period,
        employeeId: employeeId || undefined,
        sellingDoughCount: Number(sellingDoughCount) || 0,
        naninoDoughCount: Number(naninoDoughCount) || 0,
        sellingWeight: Number(sellingWeight) || 0,
        naninoWeight: Number(naninoWeight) || 0,
        note,
      });
      setPeriod('');
      setSellingDoughCount('');
      setNaninoDoughCount('');
      setSellingWeight('');
      setNaninoWeight('');
      setNote('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  const employeeName = (id?: string | null) => employees.find((e) => e.id === id)?.name ?? '-';

  return (
    <div>
      <h2>تعریف دوره نانینو</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="عنوان دوره (مثلاً هفته اول مهر)" value={period} onChange={(e) => setPeriod(e.target.value)} style={{ minWidth: 180 }} />
        <select value={employeeId} onChange={(e) => setEmployeeId(e.target.value)}>
          <option value="">بدون فروشنده مشخص</option>
          {employees.map((emp) => (
            <option key={emp.id} value={emp.id}>{emp.name}</option>
          ))}
        </select>
        <input placeholder="تعداد چانه فروش" type="number" value={sellingDoughCount} onChange={(e) => setSellingDoughCount(e.target.value)} />
        <input placeholder="تعداد چانه نانینو" type="number" value={naninoDoughCount} onChange={(e) => setNaninoDoughCount(e.target.value)} />
        <input placeholder="وزن فروش" type="number" value={sellingWeight} onChange={(e) => setSellingWeight(e.target.value)} />
        <input placeholder="وزن نانینو" type="number" value={naninoWeight} onChange={(e) => setNaninoWeight(e.target.value)} />
        <input placeholder="توضیح (اختیاری)" value={note} onChange={(e) => setNote(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>دوره</th>
            <th>فروشنده</th>
            <th>چانه فروش</th>
            <th>چانه نانینو</th>
            <th>اختلاف چانه</th>
            <th>اختلاف وزن</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id} style={r.difference !== 0 ? { color: 'var(--danger)' } : undefined}>
              <td>{r.period}</td>
              <td>{employeeName(r.employeeId)}</td>
              <td>{r.sellingDoughCount}</td>
              <td>{r.naninoDoughCount}</td>
              <td>{r.difference}</td>
              <td>{r.weightDifference}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
