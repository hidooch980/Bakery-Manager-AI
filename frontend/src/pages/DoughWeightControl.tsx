import { useEffect, useState } from 'react';
import api from '../api/client';

type DoughWeightRow = {
  id: string;
  date: string;
  sellerWeight: number;
  naninoWeight: number;
  difference: number;
  breadCount: number;
  note?: string | null;
};

export default function DoughWeightControl() {
  const [rows, setRows] = useState<DoughWeightRow[]>([]);
  const [sellerWeight, setSellerWeight] = useState('');
  const [naninoWeight, setNaninoWeight] = useState('');
  const [breadCount, setBreadCount] = useState('');
  const [note, setNote] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/dough-weight-control').then((res) => setRows(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!sellerWeight || !naninoWeight) {
      setError('وزن فروشنده و وزن نانینو الزامی هستند');
      return;
    }
    try {
      await api.post('/dough-weight-control', {
        sellerWeight: Number(sellerWeight),
        naninoWeight: Number(naninoWeight),
        breadCount: Number(breadCount) || 0,
        note,
      });
      setSellerWeight('');
      setNaninoWeight('');
      setBreadCount('');
      setNote('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  return (
    <div>
      <h2>کنترل وزن چانه</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="وزن چانه فروشنده (گرم)" type="number" value={sellerWeight} onChange={(e) => setSellerWeight(e.target.value)} />
        <input placeholder="وزن چانه نانینو (گرم)" type="number" value={naninoWeight} onChange={(e) => setNaninoWeight(e.target.value)} />
        <input placeholder="تعداد نان (اختیاری)" type="number" value={breadCount} onChange={(e) => setBreadCount(e.target.value)} />
        <input placeholder="توضیح (اختیاری)" value={note} onChange={(e) => setNote(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>تاریخ</th>
            <th>وزن فروشنده</th>
            <th>وزن نانینو</th>
            <th>اختلاف</th>
            <th>تعداد نان</th>
            <th>توضیح</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id} style={r.difference !== 0 ? { color: 'var(--danger)' } : undefined}>
              <td>{new Date(r.date).toLocaleDateString('fa-IR')}</td>
              <td>{r.sellerWeight}</td>
              <td>{r.naninoWeight}</td>
              <td>{r.difference}</td>
              <td>{r.breadCount}</td>
              <td>{r.note ?? '-'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
