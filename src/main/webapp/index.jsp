<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Hello World</title>

  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">

  <style>
    * {
      box-sizing: border-box;
    }

    html, body {
      height: 100%;
      margin: 0;
      font-family: 'Inter', sans-serif;
    }

    body {
      display: flex;
      align-items: center;
      justify-content: center;
      background: radial-gradient(circle at 20% 20%, #1e293b, #0f172a 60%);
      color: #fff;
      overflow: hidden;
    }

    /* Soft animated background glow */
    body::before {
      content: "";
      position: absolute;
      width: 600px;
      height: 600px;
      background: radial-gradient(circle, rgba(59,130,246,0.25), transparent 70%);
      filter: blur(100px);
      animation: float 8s ease-in-out infinite alternate;
    }

    @keyframes float {
      from { transform: translate(-100px, -50px); }
      to { transform: translate(100px, 80px); }
    }

    .card {
      position: relative;
      width: min(540px, 92vw);
      padding: 50px 40px;
      border-radius: 24px;
      background: rgba(255,255,255,0.06);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255,255,255,0.12);
      box-shadow: 0 30px 80px rgba(0,0,0,0.5);
      text-align: center;
      transition: transform 0.4s ease, box-shadow 0.4s ease;
    }

    .card:hover {
      transform: translateY(-8px);
      box-shadow: 0 40px 100px rgba(0,0,0,0.6);
    }

    h1 {
      margin: 0;
      font-size: 52px;
      font-weight: 800;
      letter-spacing: -1px;
      background: linear-gradient(90deg, #3b82f6, #22d3ee);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    p {
      margin-top: 16px;
      font-size: 17px;
      opacity: 0.85;
      line-height: 1.6;
    }

    .divider {
      width: 60px;
      height: 4px;
      margin: 28px auto;
      border-radius: 2px;
      background: linear-gradient(90deg, #3b82f6, #22d3ee);
    }

    .badge {
      display: inline-block;
      padding: 10px 18px;
      border-radius: 999px;
      background: rgba(59,130,246,0.15);
      border: 1px solid rgba(59,130,246,0.3);
      font-size: 14px;
      font-weight: 600;
      letter-spacing: 0.5px;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello World</h1>
    <div class="divider"></div>
    <p>Welcome to our improved interface</p>
    <div class="badge">SE3318 · Labwork 2</div>
  </div>
</body>
</html>
