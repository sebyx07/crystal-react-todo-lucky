// Bun build script for React app with React Compiler
import { watch } from 'fs';
import { createHash } from 'crypto';
import { readFileSync, writeFileSync } from 'fs';
import { babelPlugin } from './babel-plugin.js';

const isDev = process.argv.includes('--watch');
const isProd = process.argv.includes('--production');

function generateHash(filePath) {
  try {
    const content = readFileSync(filePath);
    return createHash('md5').update(content).digest('hex').substring(0, 16);
  } catch {
    return Date.now().toString(36);
  }
}

function generateManifest() {
  const jsHash = generateHash('./public/js/app.js');
  const cssHash = generateHash('./public/css/app.css');

  const manifest = {
    '/js/app.js': `/js/app.js?id=${jsHash}`,
    '/css/app.css': `/css/app.css?id=${cssHash}`
  };

  writeFileSync('./public/mix-manifest.json', JSON.stringify(manifest, null, 4));
  console.log('Generated manifest with hashes');
}

async function buildJS() {
  console.log(`Building JS${isDev ? ' (dev mode)' : isProd ? ' (production)' : ''}...`);

  const result = await Bun.build({
    entrypoints: ['./src/js/app.tsx'],
    outdir: './public/js',
    minify: isProd,
    sourcemap: isDev ? 'inline' : 'external',
    target: 'browser',
    splitting: true,
    naming: {
      entry: '[dir]/[name].[ext]',
      chunk: '[dir]/[name]-[hash].[ext]',
      asset: '[dir]/[name]-[hash].[ext]'
    },
    define: {
      'process.env.NODE_ENV': isProd ? '"production"' : '"development"'
    },
    plugins: [babelPlugin()]
  });

  if (!result.success) {
    console.error('Build failed');
    for (const message of result.logs) {
      console.error(message);
    }
    return false;
  }

  console.log('JS build successful!');
  return true;
}

async function buildCSS() {
  const proc = Bun.spawn([
    'bun', '--bun', 'sass',
    '--load-path=node_modules',
    '--silence-deprecation=import',
    '--silence-deprecation=global-builtin',
    '--silence-deprecation=color-functions',
    'src/css/app.scss',
    'public/css/app.css',
    isProd ? '--style=compressed' : '--style=expanded'
  ]);
  await proc.exited;
  console.log('CSS build successful!');
}

async function build() {
  const jsSuccess = await buildJS();
  if (!jsSuccess) {
    process.exit(1);
  }
  await buildCSS();
  generateManifest();
  console.log('✓ Build complete!');
}

// Build once or watch
if (isDev) {
  console.log('Building initial version...');
  await build();
  console.log('\nWatching for changes...');

  // Watch JS files
  watch('./src/js', { recursive: true }, async (eventType, filename) => {
    if (filename?.match(/\.(tsx?|jsx?)$/)) {
      console.log(`\nFile changed: ${filename}`);
      await buildJS();
      generateManifest();
    }
  });

  // Watch CSS files
  watch('./src/css', { recursive: true }, async (eventType, filename) => {
    if (filename?.match(/\.s?css$/)) {
      console.log(`\nCSS changed: ${filename}`);
      await buildCSS();
      generateManifest();
    }
  });

  console.log('Press Ctrl+C to stop watching');
  // Keep process alive
  await new Promise(() => {});
} else {
  await build();
}
