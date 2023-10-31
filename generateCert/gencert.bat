To convert your shell script into a Windows batch script (`.bat`), you can use the following equivalent commands:

```batch
@echo off
setlocal enabledelayedexpansion

echo Enter the domain name:
set /p name=

mkdir !name!

set EXTFILE=%cd%\cert_ext.cnf

:: Uncomment the below if you want to encrypt the key
:: openssl genrsa -des3 -out !name!.key 4096

echo -------------Generating !name!.key--------------
openssl genrsa -out !name!\!name!.key 4096

echo -------------Generating !name!.csr--------------
:: Update Common Name in External File
echo commonName = !name! >> %EXTFILE%
openssl req -key !name!\!name!.key -new -out !name!\!name!.csr -config %EXTFILE%

:: Remove the last line from the external file
for /f %%i in (%EXTFILE%) do (
    set lastline=%%i
)
echo %lastline% > temp.csr
move /y temp.csr %EXTFILE%

(
    echo [alt_names]
    echo DNS.1 = *.!name!
) > !name!\!name!.ext

echo -------------Generating !name!.crt-------------
openssl x509 -req -CA "..\rootCA\rootCA.crt" -CAkey "..\rootCA\rootCA.key" -in !name!\!name!.csr -out !name!\!name!.crt -days 3650 -CAcreateserial -extfile !name!\!name!.ext

echo -------------Generating !name!.pfx-------------
openssl pkcs12 -export -out !name!\!name!.pfx -inkey !name!\!name!.key -in !name!\!name!.crt

echo -------------Certification Generating complete with below Subject and Subject Alternate Name---------------
openssl x509 -noout -text -in !name!\!name!.crt | findstr /c:"Subject"

:: Uncomment below 2 lines to generate JKS format certificate
:: echo -------------Generating !name!.jks------------
:: keytool -importkeystore -srckeystore !name!\!name!.pfx -srcstoretype PKCS12 -destkeystore !name!\!name!.jks -deststoretype JKS

endlocal

endlocal
```

