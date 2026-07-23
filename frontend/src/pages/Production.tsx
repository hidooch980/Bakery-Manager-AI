import { useEffect, useState } from 'react';
import api from '../api/client';

export default function Production() {
  const [items, setItems] = useState<any[]>([]);
  const [shift, setShift] = useState('');
  const [flourBags, setFlourBags] = useState('');
  const [flourWeight, setFlourWeight] = useState('');
  const [doughCount, setDoughCount] = useState('');
  const [breadCount, setBreadCount] = useState('');

  function load() {
    api.get('/production').then((res) => setItems(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await api.post('/production', {
      shift,
      flourBags: Number(flourBags),
      flourWeight: Number(flourWeight),
      doughCount: Number(doughCount),
      breadCount: Number(breadCount),
    });
    setShift('');
    setFlourBags('');
    setFlourWeight('');
    setDoughCount('');
    setBreadCount('');
    load();
  }

  return (
    <div>
      <h2>تولید</h2>
      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <input placeholder="شیفت" value={shift} onChange={(e) => setShift(e.target.value)} />
        <input placeholder="کیسه آرد" value={flourBags} onChange={(e) => setFlourBags(e.target.value)} />
        <input placeholder="وزن آرد" value={flourWeight} onChange={(e) => setFlourWeight(e.target.value)} />
        <input placeholder="تعداد چانه" value={doughCount} onChange={(e) => setDoughCount(e.target.value)} />
        <input placeholder="تعداد نان" value={breadCount} onChange={(e) => setBreadCount(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>شیفت</th>
            <th>کیسه آرد</th>
            <th>وزن آرد</th>
            <th>چانه</th>
            <th>نان</th>
          </tr>
        </thead>
        <tbody>
          {items.map((p) => (
            <tr key={p.id}>
              <td>{p.shift}</td>
              <td>{p.flourBags}</td>
              <td>{p.flourWeight}</td>
              <td>{p.doughCount}</td>
              <td>{p.breadCount}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
