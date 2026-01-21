/*
 module.exports = {
  test: /\.coffee(\.erb)?$/,
  use: [{
    loader: 'coffee-loader'
  }]
}
*/
module.exports = {
    rules: [
      {
        test: /\.coffee$/,
        loader: "coffee-loader",
        options: {
          bare: false,
          transpile: {
            presets: ["@babel/env"],
          },
        },
      },
    ],
};
