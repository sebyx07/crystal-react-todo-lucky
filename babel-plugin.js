// Bun plugin to use Babel with React Compiler
import { transformAsync } from '@babel/core';

export function babelPlugin() {
  return {
    name: 'babel-plugin',
    async setup(build) {
      // Transform JSX/TSX files with Babel
      build.onLoad({ filter: /\.(jsx|tsx)$/ }, async (args) => {
        const text = await Bun.file(args.path).text();

        const result = await transformAsync(text, {
          filename: args.path,
          configFile: './babel.config.js',
          sourceMaps: true
        });

        return {
          contents: result.code,
          loader: 'js'
        };
      });
    }
  };
}
