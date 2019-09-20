"use strict";

const path = require("path");

const HtmlWebpackPlugin = require("html-webpack-plugin");

const isWebpackDevServer = process.argv.some(
  a => path.basename(a) === "webpack-dev-server"
);

const isWatch = process.argv.some(a => a === "--watch");

const appName = require("./package.json").name;

module.exports = {
  devServer: {
    contentBase: ".",
    port: 4008,
    stats: "errors-only"
  },

  entry: "./src/entrypoint.js",

  output: {
    path: path.join(__dirname, "dist"),
    pathinfo: true,
    filename: "bundle.js"
  },

  module: {
    rules: [
      {
        test: /\.purs$/,
        use: [
          {
            loader: "purs-loader",
            options: {
              src: [path.join("src", "**", "*.purs")],
              spago: true,
              psc: "psa",
              bundle: false,
              watch: isWebpackDevServer || isWatch,
              pscIde: false
            }
          }
        ]
      }
    ]
  },

  resolve: {
    modules: ["node_modules"],
    extensions: [".purs", ".js"]
  },

  plugins: [new HtmlWebpackPlugin({ title: appName })]
};
