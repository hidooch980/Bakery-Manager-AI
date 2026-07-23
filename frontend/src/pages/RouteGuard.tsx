import { type ReactNode } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';

type Props = {
  children: ReactNode;
  roles?: string[];
};

export function RouteGuard({ children, roles }: Props) {
  const { user, loading } = useAuth();

  if (loading) {
    return <div style={{ padding: 24 }}>در حال بارگذاری...</div>;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (roles && !roles.includes(user.role) && user.role !== 'ADMIN') {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
}
