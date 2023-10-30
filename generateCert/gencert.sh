echo "Enter the domain name"
read name
mkdir ${name}
EXTFILE="$PWD/cert_ext.cnf"
#Uncomment the below if you want to encrypt the key
#openssl genrsa -des3 -out ${name}.key 4096
echo "-------------Genrating ${name}.key--------------"
openssl genrsa -out ${name}/${name}.key 4096
echo "-------------Genrating ${name}.csr--------------"
## Update Common Name in External File
echo "commonName              = ${name}" >> $EXTFILE
openssl req -key  ${name}/${name}.key -new -out  ${name}/${name}.csr -config $EXTFILE
head -n -1 $EXTFILE > temp.csr; mv temp.csr $EXTFILE
cat <<EOF > ${name}/${name}.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${name}
EOF
echo "-------------Generating ${name}.crt-------------"
openssl x509 -req -CA "../rootCA/rootCA.crt" -CAkey "../rootCA/rootCA.key" -in  ${name}/${name}.csr -out  ${name}/${name}.crt -days 3650 -CAcreateserial -extfile ${name}/${name}.ext
echo "-------------Generating ${name}.pfx-------------"
openssl pkcs12 -export -out  ${name}/${name}.pfx -inkey  ${name}/${name}.key -in  ${name}/${name}.crt
echo "-------------Certification Genrating complete with below Subject and Subject Alternate Name---------------"
openssl x509 -noout -text -in  ${name}/${name}.crt | grep -A 1 "Subject"
#Uncomment below to generate jsk along with pfx
#keytool -importkeystore -srckeystore ${name}.pfx -srcstoretype pkcs12 -destkeystore {$name}.jks -deststoretype JKS
