import { useEffect, useState } from "react";
import { api } from "../api/client";
import { UserPlus, AlertCircle, CheckCircle2 } from "lucide-react";

const ROLES = [
  { value: "MANAGER", label: "مدیر" },
  { value: "SELLER", label: "فروشنده" },
  { value: "DOUGH_MAKER", label: "خمیرگیر" },
  { value: "DOUGH_DIVIDER", label: "چانه‌گیر" },
  { value: "ACCOUNTANT", label: "حسابدار" },
  { value: "EMPLOYEE", label: "کارمند" },
];

function roleLabel(value: string) {
  return ROLES.find((r) => r.value === value)?.label || value;
}

export default function Users() {
  const [users, setUsers] = useState<any[]>([]);
  const [form, setForm] = useState({
    name: "",
    phone: "",
    password: "",
    role: "SELLER",
  });
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function load() {
    try {
      const res = await api.get("/users");
      setUsers(res.data || []);
    } catch (e: any) {
      setError(e?.response?.data?.message || "خطا در دریافت کاربران");
    }
  }

  useEffect(() => {
    load();
  }, []);

  async function submit() {
    setError("");
    setMessage("");
    if (!form.name || !form.phone || !form.password) {
      setError("نام، موبایل و رمز عبور الزامی است");
      return;
    }
    setLoading(true);
    try {
      await api.post("/users", form);
      setForm({ name: "", phone: "", password: "", role: "SELLER" });
      setMessage("کاربر با موفقیت ایجاد شد");
      await load();
    } catch (e: any) {
      setError(e?.response?.data?.message || "خطا در ایجاد کاربر");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      <div className="page-header">
        <div className="page-heading">
          <span className="page-heading-icon">
            <UserPlus size={20} />
          </span>
          کاربران
        </div>
      </div>

      <div className="card">
        <div className="card-title">ایجاد کاربر جدید</div>
        <div className="form-grid">
          <div className="field">
            <label>نام *</label>
            <input
              className="input"
              value={form.name}
              onChange={(e) => setForm({ ...form, name: e.target.value })}
            />
          </div>
          <div className="field">
            <label>موبایل *</label>
            <input
              className="input"
              value={form.phone}
              onChange={(e) => setForm({ ...form, phone: e.target.value })}
            />
          </div>
          <div className="field">
            <label>رمز عبور *</label>
            <input
              className="input"
              type="password"
              value={form.password}
              onChange={(e) => setForm({ ...form, password: e.target.value })}
            />
          </div>
          <div className="field">
            <label>نقش</label>
            <select
              className="input"
              value={form.role}
              onChange={(e) => setForm({ ...form, role: e.target.value })}
            >
              {ROLES.map((r) => (
                <option key={r.value} value={r.value}>
                  {r.label}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button
          className="btn btn-primary"
          onClick={submit}
          disabled={loading}
          style={{ marginTop: 16 }}
        >
          {loading ? "در حال ثبت..." : "ایجاد کاربر"}
        </button>

        {error ? (
          <div className="alert alert-error">
            <AlertCircle size={16} />
            {error}
          </div>
        ) : null}
        {message ? (
          <div className="alert alert-success">
            <CheckCircle2 size={16} />
            {message}
          </div>
        ) : null}
      </div>

      <div className="card">
        <div className="card-title">لیست کاربران</div>
        <div className="table-wrap">
          <table className="table">
            <thead>
              <tr>
                <th>نام</th>
                <th>موبایل</th>
                <th>نقش</th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id}>
                  <td>{u.name}</td>
                  <td>{u.phone}</td>
                  <td>{roleLabel(u.role)}</td>
                </tr>
              ))}
            </tbody>
          </table>
          {users.length === 0 ? (
            <div className="table-empty">کاربری ثبت نشده است.</div>
          ) : null}
        </div>
      </div>
    </div>
  );
}
