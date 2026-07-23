import { Fragment, useEffect, useState } from 'react';
import api from '../api/client';

export default function Employees() {
  const [employees, setEmployees] = useState<any[]>([]);
  const [name, setName] = useState('');
  const [role, setRole] = useState('');
  const [phone, setPhone] = useState('');

  function load() {
    api.get('/employees').then((res) => setEmployees(res.data));
  }

  useEffect(() => {
    load();
  }, []);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await api.post('/employees', { name, role, phone });
    setName('');
    setRole('');
    setPhone('');
    load();
  }

  return (
    <div>
      <h2>کارکنان</h2>
      <form onSubmit={submit} className="card" style={{ marginBottom: 20 }}>
        <input placeholder="نام" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="نقش" value={role} onChange={(e) => setRole(e.target.value)} />
        <input placeholder="موبایل" value={phone} onChange={(e) => setPhone(e.target.value)} />
        <button className="btn-primary" type="submit">افزودن</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>نام</th>
            <th>نقش</th>
            <th>موبایل</th>
          </tr>
        </thead>
        <tbody>
          {employees.map((e) => (
            <Fragment key={e.id}>
              <tr>
                <td>{e.name}</td>
                <td>{e.role}</td>
                <td>{e.phone}</td>
              </tr>
            </Fragment>
          ))}
        </tbody>
      </table>
    </div>
  );
}
