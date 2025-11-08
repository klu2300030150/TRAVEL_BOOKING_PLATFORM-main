import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/TRAVEL_BOOKING_PLATFORM-main/',
  build: {
    outDir: '../dist',
    emptyOutDir: true,
  }
})
