module.exports = {
  presets: [
    ['@babel/preset-react', {
      runtime: 'automatic' // Use automatic JSX runtime (React 17+)
    }],
    '@babel/preset-typescript'
  ],
  plugins: [
    // React Compiler must be first in the plugin array
    ['babel-plugin-react-compiler', {
      target: '19' // React 19
    }]
  ]
};
