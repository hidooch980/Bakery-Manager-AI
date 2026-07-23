import { useEffect, useState } from 'react';
import api from '../api/client';

type Ingredient = {
  id: string;
  name: string;
  unit: string;
  quantity: number;
  minStock?: number | null;
};

export default function Inventory() {
  const [items, setItems] = useState<Ingredient[]>([]);
  const [lowStock, setLowStock] = useState<Ingredient[]>([]);
  const [name, setName] = useState('');
  const [unit, setUnit] = useState('kg');
  const [quantity, setQuantity] = useState('');
  const [minStock, setMinStock] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/inventory').then((res) => setItems(res.data));
    api.get('/inventory/low-stock').then((res) => setLowStock(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!name || !unit || !quantity) {
      setError('نام، واحد و مقدار الزامی هستند');
      return;
    }
    try {
      await api.post('/inventory', {
        name,
        unit,
        quantity: Number(quantity),
        minStock: minStock ? Number(minStock) : undefined,
      });
      setName('');
      setQuantity('');
      setMinStock('');
      load();
    } catch {
      setError('ثبت با خطا مواجه شد');
    }
  }

  const lowStockIds = new Set(lowStock.map((i) => i.id));

  return (
    <div>
      <h2>انبار مواد اولیه</h2>

      {lowStock.length > 0 && (
        <div className="card" style={{ marginBottom: 20, borderColor: 'var(--danger)' }}>
          <div className="label" style={{ color: 'var(--danger)', marginBottom: 8 }}>
            ⚠️ کالاهای رو به اتمام ({lowStock.length})
          </div>
          {lowStock.map((i) => (
            <div key={i.id} style={{ fontSize: 13, color: 'var(--text-dim)' }}>
              {i.name}: {i.quantity} {i.unit} (حداقل: {i.minStock ?? '-'})
            </div>
          ))}
        </div>
      )}

      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="نام کالا" value={name} onChange={(e) => setName(e.target.value)} />
        <select value={unit} onChange={(e) => setUnit(e.target.value)}>
          <option value="kg">کیلوگرم</option>
          <option value="g">گرم</option>
          <option value="l">لیتر</option>
          <option value="pcs">عدد</option>
          <option value="bag">کیسه</option>
        </select>
        <input placeholder="مقدار موجود" type="number" value={quantity} onChange={(e) => setQuantity(e.target.value)} />
        <input placeholder="حداقل موجودی (اختیاری)" type="number" value={minStock} onChange={(e) => setMinStock(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <table>
        <thead>
          <tr>
            <th>نام</th>
            <th>واحد</th>
            <th>موجودی</th>
            <th>حداقل موجودی</th>
          </tr>
        </thead>
        <tbody>
          {items.map((i) => (
            <tr key={i.id} style={lowStockIds.has(i.id) ? { color: 'var(--danger)' } : undefined}>
              <td>{i.name}</td>
              <td>{i.unit}</td>
              <td>{i.quantity}</td>
              <td>{i.minStock ?? '-'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
