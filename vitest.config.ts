import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    globals: true,
    environment: 'happy-dom',
    setupFiles: './src/js/test/setup.ts',
    include: ['src/js/**/*.{test,spec}.{js,jsx,ts,tsx}'],
    coverage: {
      reporter: ['text', 'json', 'html'],
      include: ['src/js/**/*.{js,jsx,ts,tsx}'],
      exclude: ['src/js/**/*.{test,spec}.{js,jsx,ts,tsx}', 'src/js/test/**'],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src/js'),
    },
  },
});
