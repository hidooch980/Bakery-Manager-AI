import { useEffect, useState } from 'react';
import api from '../api/client';

export default function Products() {
  const [products, setProducts] = useState<any[]>([]);
  const [name, setName] = useState('');
  const [price, setPrice] = useState('');
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState('');
  const [editPrice, setEditPrice] = useState('');

  function load() {
    api.get('/products').then((res) => setProducts(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await api.post('/products', { name, price: Number(price) });
    setName('');
    setPrice('');
    load();
  }

  function startEdit(p: any) {
    setEditingId(p.id);
    setEditName(p.name);
    setEditPrice(String(p.price));
  }

  async function saveEdit(id: string) {
    await api.patch(`/products/${id}`, {
      name: editName,
      price: Number(editPrice),
    });
    setEditingId(null);
    load();
  }

  async function remove(id: string) {
    if (!confirm('این محصول حذف شود؟')) return;
    await api.delete(`/products/${id}`);
    load();
  }

  return (
    <div>
      <h2>محصولات</h2>
      <form onSubmit={submit} className="card" style={{ marginBottom: 20 }}>
        <input placeholder="نام محصول" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="قیمت" value={price} onChange={(e) => setPrice(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>نام</th>
            <th>قیمت</th>
            <th>عملیات</th>
          </tr>
        </thead>
        <tbody>
          {products.map((p) => (
            <tr key={p.id}>
              {editingId === p.id ? (
                <>
                  <td><input value={editName} onChange={(e) => setEditName(e.target.value)} /></td>
                  <td><input value={editPrice} onChange={(e) => setEditPrice(e.target.value)} /></td>
                  <td>
                    <button className="btn-primary" onClick={() => saveEdit(p.id)}>ذخیره</button>
                  </td>
                </>
              ) : (
                <>
                  <td>{p.name}</td>
                  <td>{p.price?.toLocaleString('fa-IR')}</td>
                  <td>
                    <button onClick={() => startEdit(p)}>✉️ ویرایش</button>{' '}
                    <button onClick={() => remove(p.id)}>🧹 حذف</button>
                  </td>
                </>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
