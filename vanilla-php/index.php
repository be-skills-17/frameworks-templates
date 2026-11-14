<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP</title>
</head>
<body style="padding: 2rem; font-family: system-ui, sans-serif;">
    <h1 style="color: #777bb4; font-size: 2rem; font-weight: bold;">
        PHP - It works!
    </h1>
    <p style="margin-top: 1rem; color: #666;">
        Your PHP application is running successfully (PHP <?= htmlspecialchars(PHP_VERSION) ?>).
    </p>
    <p style="margin-top: 1rem; color: #666;">
        Want plain HTML instead? Delete <code>index.php</code>: Apache serves <code>index.php</code> before
        <code>index.html</code>, so <code>index.html</code> is only shown once <code>index.php</code> is gone.
    </p>
</body>
</html>
