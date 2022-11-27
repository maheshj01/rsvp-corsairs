# download this file to your project folder and excute
# chmod +x generate-ios.sh
# then run using
# ./generate-ios.sh

# flutter build defaults to --release
flutter build ios

# make folder, add .app then zip it and rename it to .ipa
mkdir -p Payload
mv ./build/ios/iphoneos/Runner.app Payload
zip -r -y Payload.zip Payload/Runner.app
mv Payload.zip Payload.ipa

# the following are options, remove Payload folder
rm -Rf Payload
# open finder and manually find the .ipa and upload to diawi using chrome
open .
open -a "Google Chrome" https://www.diawi.com/