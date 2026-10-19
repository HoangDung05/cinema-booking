import { Navigate } from 'react-router-dom';
import AdminLayout from '../layouts/AdminLayout';
import { readAuthSession, isAdminSession } from '../utils/authSession';

/**
 * Điều hướng UI theo role name; backend vẫn kiểm tra ROLE_ADMIN cho mọi API.
 */
export default function AdminRoute() {
  const session = readAuthSession();
  if (!session) {
    return <Navigate to="/" replace />;
  }
  if (!isAdminSession(session)) {
    return <Navigate to="/" replace />;
  }
  return <AdminLayout />;
}
