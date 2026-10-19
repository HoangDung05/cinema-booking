import axios, { AxiosHeaders } from 'axios';
import { CURRENT_USER_STORAGE_KEY } from '../utils/authSession';
import { API_BASE_URL } from './apiBaseUrl';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor cho Request (ví dụ muốn đính kèm JWT Token)
apiClient.interceptors.request.use(
  (config) => {
    const rawCurrentUser = localStorage.getItem(CURRENT_USER_STORAGE_KEY);
    if (rawCurrentUser) {
      try {
        const parsed = JSON.parse(rawCurrentUser) as {
          token?: string;
          accessToken?: string;
          jwt?: string;
          type?: string;
        };
        const rawToken = (parsed.token || parsed.accessToken || parsed.jwt || '').trim();
        if (rawToken) {
          // Hỗ trợ cả token thuần hoặc token đã có sẵn prefix Bearer.
          const tokenValue = /^Bearer\s+/i.test(rawToken)
            ? rawToken
            : `${parsed.type?.trim() || 'Bearer'} ${rawToken}`;
          const headers = AxiosHeaders.from(config.headers);
          headers.set('Authorization', tokenValue);
          config.headers = headers;
        }
      } catch (e) {
        // Ignore JSON parse error
      }
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor cho Response (ví dụ xử lý lỗi 401 token hết hạn)
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    // A guest booking can return 401 for a missing proof; that must not log out
    // an unrelated signed-in account.
    if (error?.response?.status === 401
      && error?.response?.data?.message === 'Unauthorized'
      && error?.config?.headers?.Authorization) {
      localStorage.removeItem(CURRENT_USER_STORAGE_KEY);
    }
    return Promise.reject(error);
  }
);

export default apiClient;
