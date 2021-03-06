#!/usr/bin/env zsh


# Feel free to change any of these defaults
countryName="UK"
stateOrProvinceName="England"
localityName=""
organizationName="Will Boyce"
organizationalUnitName=""
commonName="Sirious"
emailAddress=""

## Do not edit below here!

mkdir -p ssl
mkdir -p demoCA/{certs,crl,newcerts,private}
touch demoCA/index.txt
echo 01 > demoCA/crtnumber

CAREQARGS="${countryName}\n${stateOrProvinceName}\n${localityName}\n${organizationName}\n${organizationalUnitName}\n${commonName}\n${emailAddress}\n\n\n"
echo -n $CAREQARGS | openssl req -new -keyout demoCA/private/cakey.pem -out demoCA/careq.pem -passin pass:1234 -passout pass:1234
openssl ca -create_serial -out demoCA/cacert.pem -days 1095 -batch -keyfile demoCA/private/cakey.pem -selfsign -extensions v3_ca -infiles demoCA/careq.pem

CRTREQARGS="${countryName}\n${stateOrProvinceName}\n${localityName}\n${organizationName}\n${organizationalUnitName}\nguzzoni.apple.com\n${emailAddress}\n\n\n"
echo $CRTREQARGS | openssl req -new -keyout newkey.pem -out newreq.pem -days 1095 -passin pass:1234 -passout pass:1234
openssl ca -policy policy_anything -out newcert.pem -infiles newreq.pem
openssl rsa -in newkey.pem -out server.key -passin pass:1234

mv newcert.pem server.crt
mv demoCA/cacert.pem ssl/ca.pem
mv server.{crt,key} ssl/
rm -rf new{key,req}.pem demoCA
