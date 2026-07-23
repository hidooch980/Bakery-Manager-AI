import { useEffect, useState } from 'react';
import api from '../api/client';

type MenuCategory = {
  id: string;
  name: string;
  sortOrder: number;
  active: boolean;
};

type MenuItem = {
  id: string;
  name: string;
  price: number;
  costPrice: number;
  available: boolean;
  categoryId: string;
  category?: { name: string };
};

export default function CafeMenu() {
  const [categories, setCategories] = useState<MenuCategory[]>([]);
  const [items, setItems] = useState<MenuItem[]>([]);
  const [catName, setCatName] = useState('');
  const [name, setName] = useState('');
  const [price, setPrice] = useState('');
  const [costPrice, setCostPrice] = useState('');
  const [categoryId, setCategoryId] = useState('');
  const [error, setError] = useState('');

  function load() {
    api.get('/cafe/categories').then((res) => setCategories(res.data));
    api.get('/cafe/menu-items').then((res) => setItems(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function addCategory(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!catName) {
      setError('نام دسته‌بندی الزامی است');
      return;
    }
    try {
      await api.post('/cafe/categories', { name: catName });
      setCatName('');
      load();
    } catch {
      setError('ثبت دسته‌بندی با خطا مواجه شد');
    }
  }

  async function addItem(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!name || !price || !categoryId) {
      setError('نام، قیمت و دسته‌بندی آیتم الزامی هستند');
      return;
    }
    try {
      await api.post('/cafe/menu-items', {
        name,
        price: Number(price),
        costPrice: Number(costPrice) || 0,
        categoryId,
      });
      setName('');
      setPrice('');
      setCostPrice('');
      load();
    } catch {
      setError('ثبت آیتم منو با خطا مواجه شد');
    }
  }

  async function toggleCategory(cat: MenuCategory) {
    await api.put(`/cafe/categories/${cat.id}`, { active: !cat.active });
    load();
  }

  async function toggleItem(item: MenuItem) {
    await api.put(`/cafe/menu-items/${item.id}`, { available: !item.available });
    load();
  }

  return (
    <div>
      <h2>منوی کافه و رستوران</h2>

      <form onSubmit={addCategory} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="نام دسته‌بندی (مثلاً نوشیدنی گرم)" value={catName} onChange={(e) => setCatName(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن دسته‌بندی</button>
      </form>

      <form onSubmit={addItem} className="card" style={{ marginBottom: 20, display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'flex-end' }}>
        <input placeholder="نام آیتم (مثلاً اسپرسو)" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="قیمت فروش (تومان)" type="number" value={price} onChange={(e) => setPrice(e.target.value)} />
        <input placeholder="قیمت تمام‌شده (اختیاری)" type="number" value={costPrice} onChange={(e) => setCostPrice(e.target.value)} />
        <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
          <option value="">انتخاب دسته‌بندی</option>
          {categories.filter((c) => c.active).map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
          ))}
        </select>
        <button className="btn-primary" type="submit">افزودن آیتم</button>
      </form>

      {error && <div className="login-error" style={{ marginBottom: 12 }}>{error}</div>}

      <h3>دسته‌بندی‌ها</h3>
      <table style={{ marginBottom: 24 }}>
        <thead>
          <tr>
            <th>نام</th>
            <th>وضعیت</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {categories.map((c) => (
            <tr key={c.id} style={!c.active ? { color: 'var(--text-dim)' } : undefined}>
              <td>{c.name}</td>
              <td>{c.active ? 'فعال' : 'غیرفعال'}</td>
              <td>
                <button className="btn-ghost" onClick={() => toggleCategory(c)} type="button">
                  {c.active ? 'غیرفعال کردن' : 'فعال کردن'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>آیتم‌های منو</h3>
      <table>
        <thead>
          <tr>
            <th>نام</th>
            <th>دسته‌بندی</th>
            <th>قیمت فروش</th>
            <th>قیمت تمام‌شده</th>
            <th>وضعیت</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {items.map((i) => (
            <tr key={i.id} style={!i.available ? { color: 'var(--text-dim)' } : undefined}>
              <td>{i.name}</td>
              <td>{i.category?.name || '-'}</td>
              <td>{i.price.toLocaleString('fa-IR')}</td>
              <td>{i.costPrice.toLocaleString('fa-IR')}</td>
              <td>{i.available ? 'در دسترس' : 'ناموجود'}</td>
              <td>
                <button className="btn-ghost" onClick={() => toggleItem(i)} type="button">
                  {i.available ? 'ناموجود کردن' : 'در دسترس کردن'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
