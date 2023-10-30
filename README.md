Make sure you give read and execute persmission to all the files in this directory
chmod -R 755 ssl-in-action
docker run --rm --name mynginx -v ./ssl-in-action:/home nginx
docker exec -it mynginx bash
cd /home/generateCert/
./gencert.sh
