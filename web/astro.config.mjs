import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://desafiocircular.org',
  trailingSlash: 'ignore',
  build: { format: 'directory' },
});
