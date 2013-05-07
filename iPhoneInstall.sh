echo "Enter store password:"
stty -echo
read pass
stty echo
echo ">> install iphone application"
adt -package -target ipa-test -keystore ~/Documents/iOS/Certificate.p12 -storetype pkcs12 -storepass $pass -provisioning-profile ~/Documents/iOS/DevWildCardProvisioning.mobileprovision MellowJingle.ipa MellowJingle_iPhone-app.xml MellowJingle_iPhone.swf media/m4r_64 media/mp3_192 Default-568h@2x.png ./design/MellowJingleIcon.png
adt -installApp -platform ios -package MellowJingle.ipa
