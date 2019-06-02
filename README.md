# Orientiir

Moto-orienteerumise rakendus
<http://orienteerumine.streetmoto.ee/orienteerumissari>

## Release new version

The process of releasing a new version consists of building, testing and deployment.

1. Increase app version name and number in pubspec.yaml file.
2. Build release version of the app. To do so run `flutter build apk`. To install it, run `flutter install`.
3. Test the app 
4. Upload to Google Play and App Store

## Json

Run `flutter packages pub run build_runner watch`
