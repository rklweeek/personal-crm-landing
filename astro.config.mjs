// @ts-check
import { defineConfig, envField } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  output: 'static',
  env: {
    schema: {
      // Every call to action leads here. Override via .env or the CI environment.
      PUBLIC_APP_URL: envField.string({
        context: 'client',
        access: 'public',
        url: true,
        default: 'https://app.stayintouch.site',
      }),
    },
  },
  vite: {
    plugins: [tailwindcss()],
  },
});
