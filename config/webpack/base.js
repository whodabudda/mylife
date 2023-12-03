const { webpackConfig, merge } = require('@rails/webpacker')
const webpack = require('webpack')
/*
// resolve-url-loader must be used before sass-loader
 webpackConfig.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})
module.exports = {
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          "style-loader",
          "css-loader",
          {
            loader: "sass-loader",
            options: {
              implementation: require("sass"),
              webpackImporter: false,
              sassOptions: {
                fiber: false,
              },
            },
          },
        ],
      },
    ],
  },
};
module.exports = {
  mode: 'development',
  entry: './fixture-import.scss',
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          'css-loader',
          {
            loader: 'sass-loader',
              options: {
                webpackImporter: false,
                sassOptions: {
                  includePaths: ['node_modules'],
                },
                implementation: require('sass'),
            },
          },
        ],
      },
    ],
  },
};
webpackConfig.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
  })
)
*/
module.exports = merge(
  webpackConfig,
  {
    plugins: [
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        JQuery: "jquery",
        Modal: "Modal",
        modal: "Modal",
      })
    ]
  }
  )
//  },
// ...
module.exports = merge(
  webpackConfig,
  {
  test: /\.(scss)$/,
  use: [{
    // inject CSS to page
    loader: 'style-loader'
  }, 
  {
    // translates CSS into CommonJS modules
    loader: 'css-loader'
  }, 
  {
    // Run postcss actions
    loader: 'postcss-loader',
    options: {
      // `postcssOptions` is needed for postcss 8.x;
      // if you use postcss 7.x skip the key
      postcssOptions: {
        // postcss plugins, can be exported to postcss.config.js
        plugins: function () {
          return [
            require('autoprefixer')
          ];
        }
      }
    }
  }, 
  {
    // compiles Sass to CSS
    loader: 'sass-loader'
  }
  ]
})
// ...

module.exports = webpackConfig
