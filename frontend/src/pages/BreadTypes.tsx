import { useEffect, useState } from 'react';
import api from '../api/client';

type BreadType = {
  id: string;
  name: string;
  active: boolean;
  saleWeight: number;
  naninoWeight: number;
};

export default function BreadTypes() {
  const [items, setItems] = useState<BreadType[]>([]);
  const [name, setName] = useState('');
  const [saleWeight, setSaleWeight] = useState('');
  const [naninoWeight, setNaninoWeight] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/bread-type').then((res) => setItems(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!name || !saleWeight || !naninoWeight) {
      setError('نام، وزن فروش و وزن نانینو الزامی هستند');
      return;
    }
    try {
      await api.post('/bread-type', {
        name,
        saleWeight: Number(saleWeight),
        naninoWeight: Number(naninoWeight),
      });
      setName('');
      setSaleWeight('');
      setNaninoWeight('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  async function toggleActive(item: BreadType) {
    await api.put(`/bread-type/${item.id}`, { active: !item.active });
    load();
  }

  return (
    <div>
      <h2>تعریف نوع نان</h2>

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="نام نان (مثلاً بربری)" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="وزن فروش (گرم)" type="number" value={saleWeight} onChange={(e) => setSaleWeight(e.target.value)} />
        <input placeholder="وزن نانینو (گرم)" type="number" value={naninoWeight} onChange={(e) => setNaninoWeight(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>نام</th>
            <th>وزن فروش</th>
            <th>وزن نانینو</th>
            <th>وضعیت</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {items.map((b) => (
            <tr key={b.id} style={!b.active ? { color: 'var(--text-dim)' } : undefined}>
              <td>{b.name}</td>
              <td>{b.saleWeight}</td>
              <td>{b.naninoWeight}</td>
              <td>{b.active ? 'فعال' : 'غیرفعال'}</td>
              <td>
                <button className="btn-ghost" onClick={() => toggleActive(b)} type="button">
                  {b.active ? 'غیرفعال کردن' : 'فعال کردن'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
