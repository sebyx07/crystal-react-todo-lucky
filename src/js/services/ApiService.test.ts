import { describe, it, expect, beforeEach, vi } from 'vitest';
import { ApiService } from './ApiService';

describe('ApiService', () => {
  let apiService: ApiService;

  beforeEach(() => {
    apiService = new ApiService('/api');
    localStorage.clear();
    vi.clearAllMocks();
  });

  describe('Token Management', () => {
    it('should get token from localStorage', () => {
      localStorage.getItem = vi.fn().mockReturnValue('test-token');
      expect(apiService.getToken()).toBe('test-token');
    });

    it('should set token in localStorage', () => {
      apiService.setToken('new-token');
      expect(localStorage.setItem).toHaveBeenCalledWith('jwt_token', 'new-token');
    });

    it('should clear token from localStorage', () => {
      apiService.clearToken();
      expect(localStorage.removeItem).toHaveBeenCalledWith('jwt_token');
    });

    it('should check if authenticated', () => {
      localStorage.getItem = vi.fn().mockReturnValue('token');
      expect(apiService.isAuthenticated()).toBe(true);

      localStorage.getItem = vi.fn().mockReturnValue(null);
      expect(apiService.isAuthenticated()).toBe(false);
    });
  });

  describe('HTTP Methods', () => {
    beforeEach(() => {
      global.fetch = vi.fn();
    });

    it('should make GET request', async () => {
      const mockResponse = { data: 'test' };
      (global.fetch as any).mockResolvedValue({
        ok: true,
        json: async () => mockResponse,
      });

      const result = await apiService.get('/test');
      expect(result).toEqual(mockResponse);
      expect(fetch).toHaveBeenCalledWith('/api/test', expect.objectContaining({
        method: 'GET',
      }));
    });

    it('should make POST request with data', async () => {
      const mockData = { title: 'Test' };
      const mockResponse = { id: 1, ...mockData };
      (global.fetch as any).mockResolvedValue({
        ok: true,
        json: async () => mockResponse,
      });

      const result = await apiService.post('/test', mockData);
      expect(result).toEqual(mockResponse);
      expect(fetch).toHaveBeenCalledWith('/api/test', expect.objectContaining({
        method: 'POST',
        body: JSON.stringify(mockData),
      }));
    });

    it('should include Authorization header when token exists', async () => {
      localStorage.getItem = vi.fn().mockReturnValue('test-token');
      (global.fetch as any).mockResolvedValue({
        ok: true,
        json: async () => ({}),
      });

      await apiService.get('/test');
      expect(fetch).toHaveBeenCalledWith('/api/test', expect.objectContaining({
        headers: expect.objectContaining({
          'Authorization': 'Bearer test-token',
        }),
      }));
    });

    it('should clear token on 401 response', async () => {
      const clearTokenSpy = vi.spyOn(apiService, 'clearToken');
      (global.fetch as any).mockResolvedValue({
        status: 401,
        ok: false,
      });

      await expect(apiService.get('/test')).rejects.toThrow('Unauthorized');
      expect(clearTokenSpy).toHaveBeenCalled();
    });
  });
});
