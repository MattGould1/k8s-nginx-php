<!DOCTYPE html>
<html>

<head>
  <title>K8s Nginx PHP</title>
  <script src="static/index.js"></script>
  <link rel="stylesheet" href="static/index.css">
</head>

<body>
  <p>K8s Nginx PHP</p>
  <p>Your (not very secret) secret is <?php echo $_ENV['SECRET']; ?>. Don't do this for real ofc!</p>
</body>

</html>