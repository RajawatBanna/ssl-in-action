## generate rootCA private key
echo "Generating RootCA private key"
openssl genrsa -out rootCA.key 4096
## generate rootCA certificate
echo "Generating RootCA certificate"
openssl req -new -x509 -days 3650 -config ca_cert.cnf -key rootCA.key -out rootCA.crt
## read the certificate
echo "Verify RootCA certificate"
openssl x509 -noout -text -in rootCA.crt
