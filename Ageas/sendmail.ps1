cls
$PSEmailServer = "10.120.67.93"

$campo ="<html><body><image src=cid:fidelidade.jpg></body></html>"

Send-MailMessage  -From "luis.mendes.lopes@fidelidade.pt" -To "luis.mendes.lopes@cgd.pt" -Subject "1 teste de e-mail LGS fidelidade 15:24" -Bodyashtml $campo 
