#/bin/bash

# Here are the variables describes, which are used by the script. 
# - CRT_VALIDITY=3650         # days of validity
# - CRT_C=<CountryCode>       # Use the two digits-country-code
# - CRT_S=<State or Province> # e.g. Bavaria
# - CRT_L=<City>              # e.g. Ismaning
# - CRT_OU=<Org.-Unit>        # e.g. IT
# - CRT_CN=<CommonName>       # e.g. mycompany.local
# - CRT_ALTNAME=<IPADDRESS>   # The local IP address or another alternative name
# - CRT_ALTTYPE=<IP|DNS>      # The type of the alternative name

# Chrome 63 (out since December 2017), will force all domains ending on .dev (and .foo) to be redirected to HTTPS via a preloaded HTTP Strict Transport Security (HSTS) header.
# More infos here: https://hstspreload.org/

echo "Create certificates with following values"
if [ "${CRT_VALIDITY}" == "" ]; then CRT_VALIDITY="3650"; fi
echo "... Validity:      ${CRT_VALIDITY}"
if [ "${CRT_C}" == "" ]; then CRT_C="DE"; fi
echo "... Country:       ${CRT_C}"
if [ "${CRT_S}" == "" ]; then CRT_S="Bavarian"; fi
echo "... State:         ${CRT_S}"
if [ "${CRT_L}" == "" ]; then CRT_L="Hörgertshausen"; fi
echo "... Location:      ${CRT_L}"
if [ "${CRT_OU}" == "" ]; then CRT_OU="home"; fi
echo "... OU:            ${CRT_OU}"
if [ "${CRT_CN}" == "" ]; then CRT_CN="frickeldave.bavaria"; fi
echo "... Common name:   ${CRT_CN}"
if [ "${CRT_LENGTH}" == "" ]; then CRT_LENGTH="4096"; fi
echo "... Length:        ${CRT_LENGTH}"

echo "Check certificate directory"
if [ ! -d /home/appuser/data/certificates ]; then echo "createcerts: Does not exist, create...."; mkdir /home/appuser/data/certificates; else echo "createcerts: Directory already exist, skip...."; fi

echo "Create a self signed certificate with a validity of $CRT_VALIDITY days"
SSLSUBJECT="/C=$CRT_C/ST=$CRT_S/L=$CRT_L/O=$CRT_OU/CN=$CRT_CN"

if [ "$CRT_ALTNAME" == "" ]
then
    echo "Subject is \"$SSLSUBJECT\"" 
    openssl req -x509 -newkey rsa:${CRT_LENGTH} -keyout /home/appuser/data/certificates/key.key -out /home/appuser/data/certificates/cer.crt -days $CRT_VALIDITY -nodes -subj "$SSLSUBJECT"
    ret=$?

else
    if [ "$CRT_ALTTYPE" == "" ]; then echo "Alternative type is not set. Set it statically to DNS."; CRT_ALTTYPE="DNS"; fi
    echo "Subject is \"$SSLSUBJECT\", altname is \"$CRT_ALTNAME\", alttype is \"$CRT_ALTTYPE\""
    openssl req -x509 -newkey rsa:${CRT_LENGTH} -keyout /home/appuser/data/certificates/key.key -out /home/appuser/data/certificates/cer.crt -days $CRT_VALIDITY -nodes -subj "$SSLSUBJECT" -addext "subjectAltName = ${CRT_ALTTYPE}:${CRT_ALTNAME}"
    ret=$?
fi

if [ "$ret" == "0" ]
then
    echo "openssl returned with no error. Set security on certificates."
    if [ -f /home/appuser/data/certificates/key.key ]; then echo "set permissions to 600 for keyfile"; chmod 600 /home/appuser/data/certificates/key.key; else echo "keyfile doesn't exist"; set ret=1; fi
    if [ -f /home/appuser/data/certificates/cer.crt ]; then echo "set permissions to 644 for certfile"; chmod 644 /home/appuser/data/certificates/cer.crt; else echo "certfile doesn't exist"; set ret=1; fi
    if [ "$ret" == "1" ]; then echo "failed to set permissions to key or certfile."; exit 1; fi
else
    echo "failed. Returncode is: $ret"
    exit 1
fi