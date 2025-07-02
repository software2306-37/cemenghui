import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'

export default defineConfig({
  plugins: [uni()],
  server: {
    hmr: true,
    watch: {
      usePolling: true,
      interval: 1000
    }
  },
  build: {
    watch: {
      include: 'src/**'
    }
  }
}) 