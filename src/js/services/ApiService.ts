// API Service class with JWT token management
export class ApiService {
  private baseUrl: string;
  private tokenKey = 'jwt_token';

  constructor(baseUrl: string = '/api') {
    this.baseUrl = baseUrl;
  }

  // Get stored JWT token
  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  // Set JWT token
  setToken(token: string): void {
    localStorage.setItem(this.tokenKey, token);
  }

  // Remove JWT token
  clearToken(): void {
    localStorage.removeItem(this.tokenKey);
  }

  // Check if user is authenticated
  isAuthenticated(): boolean {
    return this.getToken() !== null;
  }

  // Make authenticated request
  async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const token = this.getToken();
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...(options.headers as Record<string, string>),
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      ...options,
      headers,
    });

    if (response.status === 401) {
      this.clearToken();
      throw new Error('Unauthorized');
    }

    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new Error(error.message || 'Request failed');
    }

    return response.json();
  }

  // GET request
  async get<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, { method: 'GET' });
  }

  // POST request
  async post<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  // PUT request
  async put<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  // PATCH request
  async patch<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PATCH',
      body: JSON.stringify(data),
    });
  }

  // DELETE request
  async delete<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, { method: 'DELETE' });
  }

  // Auth methods
  async signIn(email: string, password: string): Promise<{ token: string }> {
    const response = await this.post<{ token: string }>('/sign_ins', {
      user: { email, password },
    });
    this.setToken(response.token);
    return response;
  }

  async signUp(email: string, password: string, passwordConfirmation: string): Promise<{ token: string }> {
    const response = await this.post<{ token: string }>('/sign_ups', {
      user: { email, password, password_confirmation: passwordConfirmation },
    });
    this.setToken(response.token);
    return response;
  }

  async signOut(): Promise<void> {
    this.clearToken();
  }

  async getCurrentUser(): Promise<any> {
    return this.get('/me');
  }

  // Todo methods
  async getTodos(page: number = 1, perPage: number = 20): Promise<any> {
    return this.get(`/todos?page=${page}&per_page=${perPage}`);
  }

  async getTodo(id: number): Promise<any> {
    return this.get(`/todos/${id}`);
  }

  async createTodo(title: string, completed: boolean = false): Promise<any> {
    return this.post('/todos', { todo: { title, completed } });
  }

  async updateTodo(id: number, title: string, completed: boolean): Promise<any> {
    return this.patch(`/todos/${id}`, { todo: { title, completed } });
  }

  async deleteTodo(id: number): Promise<any> {
    return this.delete(`/todos/${id}`);
  }
}

// Export singleton instance
export const apiService = new ApiService();
