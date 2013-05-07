echo "Enter store password:"
stty -echo
read pass
stty echo
date
adt -package -target ipa-ad-hoc -keystore ~/Documents/iOS/CertificateDistribute.p12 -storetype pkcs12 -storepass $pass -provisioning-profile ./iOS/MellowJingleAdHoc.mobileprovision MellowJingleAdHoc.ipa MellowJingle_iPhone-app.xml MellowJingle_iPhone.swf media/m4r_64 media/mp3_192 Default-568h@2x.png icons design/MellowJingleIcon.png design/AppStore/MellowJingle_Icon_1024x1024.png
date