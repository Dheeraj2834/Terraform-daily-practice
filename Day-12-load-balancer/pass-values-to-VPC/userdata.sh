#!/bin/bash
yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

cat <<'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AWS Terraform Demo</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,Helvetica,sans-serif;
}

body{
height:100vh;
display:flex;
justify-content:center;
align-items:center;
background:linear-gradient(135deg,#667eea,#764ba2,#00c9ff,#92fe9d);
background-size:300% 300%;
animation:gradient 10s ease infinite;
}

@keyframes gradient{
0%{background-position:0% 50%;}
50%{background-position:100% 50%;}
100%{background-position:0% 50%;}
}

.container{
width:800px;
padding:40px;
background:rgba(255,255,255,.15);
backdrop-filter:blur(10px);
border-radius:20px;
text-align:center;
color:white;
box-shadow:0 10px 30px rgba(0,0,0,.4);
}

h1{
font-size:45px;
margin-bottom:10px;
}

h2{
color:#FFD54F;
margin-bottom:20px;
}

.grid{
display:grid;
grid-template-columns:repeat(3,1fr);
gap:20px;
margin-top:35px;
}

.card{
background:white;
color:#333;
padding:20px;
border-radius:12px;
transition:.3s;
}

.card:hover{
background:#2196F3;
color:white;
transform:scale(1.05);
}

button{
margin-top:35px;
padding:15px 40px;
font-size:18px;
border:none;
border-radius:30px;
background:#FF5722;
color:white;
cursor:pointer;
}

button:hover{
background:#E91E63;
}

#msg{
margin-top:20px;
font-size:22px;
color:yellow;
}

footer{
margin-top:30px;
}

</style>

</head>

<body>

<div class="container">

<h1>☁ AWS Cloud Demo</h1>

<h2>Terraform + EC2 + ALB</h2>

<p>Your application has been deployed successfully.</p>

<p id="instance">Loading Instance ID...</p>

<div class="grid">

<div class="card">
<h3>🚀 Terraform</h3>
<p>Infrastructure as Code</p>
</div>

<div class="card">
<h3>⚖ Application Load Balancer</h3>
<p>High Availability</p>
</div>

<div class="card">
<h3>💻 Amazon EC2</h3>
<p>Linux Web Server</p>
</div>

</div>

<button onclick="hello()">Click Here</button>

<p id="msg"></p>

<footer>
<hr>
<p>Created using Terraform User Data</p>
</footer>

</div>

<script>

function hello(){
document.getElementById("msg").innerHTML="🎉 Deployment Successful!";
}

fetch("http://169.254.169.254/latest/meta-data/instance-id")
.then(r=>r.text())
.then(data=>{
document.getElementById("instance").innerHTML="Instance ID : "+data;
});

</script>

</body>
</html>
EOF