%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Hello World</title>
  <style>
    html, body {
      height: 100%;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
    }
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #111827, #1f2937, #0f172a);
      color: #fff;
    }
    .card {
      width: min(520px, 92vw);
      padding: 36px 32px;
      border-radius: 20px;
      background: rgba(255,255,255,0.08);
      box-shadow: 0 20px 60px rgba(0,0,0,0.35);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.12);
      text-align: center;
    }
    h1 {
      margin: 0 0 10px;
      font-size: 48px;
      letter-spacing: 0.5px;
    }
    p {
      margin: 0;
      opacity: 0.85;
      font-size: 16px;
      line-height: 1.5;
    }
    .badge {
      display: inline-block;
      margin-top: 18px;
      padding: 8px 12px;
      border-radius: 999px;
      background: rgba(255,255,255,0.12);
      font-size: 13px;
      opacity: 0.9;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello World</h1>
    <p>Welcome to our improved interface 🎉</p>
    <div class="badge">SE3318 · Labwork 2</div>
  </div>
</body>
</html>
