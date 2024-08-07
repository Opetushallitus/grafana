const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");
const { gunzipSync, gzipSync } = require("node:zlib");

const app = express();

app.get("/health", (req, res) => res.send("This is fine."));

const onProxyRes = function (proxyRes, req, res) {
  proxyRes
}

const options = {
  target: "https://api.pingdom.com",
  changeOrigin: true,
  selfHandleResponse: true,
  on: { proxyRes: onProxyRes }
}

app.use(
  "/api/2.1/checks",
  createProxyMiddleware({
    target: "https://api.pingdom.com",
    changeOrigin: true,
    selfHandleResponse: true,
    onProxyRes: (proxyRes, req, res) => {
      let originalBody = Buffer.from([]);
      proxyRes.on("data", data => {
        originalBody = Buffer.concat([originalBody, data]);
      });
      proxyRes.on("end", function() {
        try {
          const bodyString = gunzipSync(originalBody).toString("utf-8");
          const newBody = JSON.parse(bodyString);

          checksFiltered = newBody.checks.filter(
            check => check.status != "paused"
          );
          checksFilteredCount = checksFiltered.length;
          failedCount = checksFiltered.filter(object => object.status !== "up")
            .length;

          newBody.extra = {
            check_count: checksFilteredCount,
            failed_check_count: failedCount
          };

          res.set({
            "content-type": "text/json; charset=utf-8",
            "content-encoding": "gzip"
          });
          res.write(gzipSync(JSON.stringify(newBody)));
          res.end();
        } catch (err) {
          res.writeHead(500, {
            "Content-Type": "text/plain"
          });
          res.end(err.toString());
        }
      });
    },
    onError(proxyErr, req, res) {
      res.writeHead(500, {
        "Content-Type": "text/plain"
      });
      res.end("Error");
    }
  })
);
app.listen(5000);
