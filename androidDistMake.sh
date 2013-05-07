echo "Enter store password:"
stty -echo
read pass
stty echo
date
adt -package -target apk-captive-runtime -storetype pkcs12 -keystore ~/Documents/android/androidCert.p12 -storepass $pass MellowJingle.apk MellowJingle_android-app.xml MellowJingle_android.swf media/mp3_64 media/mp3_192 icons/MellowJingleIcon_48.png design/MellowJingleIcon72.png
date