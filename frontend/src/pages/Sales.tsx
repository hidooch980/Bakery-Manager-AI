import { useEffect, useState } from 'react';
import api from '../api/client';

export default function Sales() {
  const [sales, setSales] = useState<any[]>([]);
  const [products, setProducts] = useState<any[]>([]);
  const [productId, setProductId] = useState('');
  const [quantity, setQuantity] = useState('');

  function load() {
    api.get('/sales').then((res) => setSales(res.data));
    api.get('/products').then((res) => setProducts(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await api.post('/sales', {
      items: [{ productId, quantity: Number(quantity) }],
    });
    setProductId('');
    setQuantity('');
    load();
  }

  return (
    <div>
      <h2>فروش</h2>
      <form onSubmit={submit} className="card" style={{ marginBottom: 20, display: 'flex', gap: 8 }}>
        <select value={productId} onChange={(e) => setProductId(e.target.value)}>
          <option value="">انتخاب محصول</option>
          {products.map((p) => (
            <option key={p.id} value={p.id}>{p.name}</option>
          ))}
        </select>
        <input placeholder="تعداد" value={quantity} onChange={(e) => setQuantity(e.target.value)} />
        <button className="btn-primary" type="submit">ثبت فروش</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>تاریخ</th>
            <th>مبلغ کل</th>
          </tr>
        </thead>
        <tbody>
          {sales.map((s) => (
            <tr key={s.id}>
              <td>{new Date(s.createdAt).toLocaleDateString('fa-IR')}</td>
              <td>{s.total?.toLocaleString('fa-IR')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
