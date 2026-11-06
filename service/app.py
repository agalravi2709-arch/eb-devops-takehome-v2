
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            response = {
                "app": os.environ.get("APP_NAME", "demo"),
                "version": os.environ.get("VERSION", "1.0.0"),
                "pod": os.environ.get("HOSTNAME", os.uname().nodename if hasattr(os, "uname") else "localhost")
            }
            self.respond(200, response)

        elif self.path == "/healthz":
            self.respond(200, {"status": "healthy"})

        else:
            self.respond(404, {"error": "Not Found"})

    def respond(self, status, data):
        body = json.dumps(data).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    server = HTTPServer(("0.0.0.0", port), Handler)
    print(f"Server running on port {port}", flush=True)
    server.serve_forever()
