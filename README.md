# Eyedropper

A mobile app demonstrating the use of color tool's lookup API. [Color Tools Website](https://color-tools.herokuapp.com/)

## Flutter resources

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Brief Description

Point your camera towards a color and with a press of a button, get the names of the nearest match colors and their description too in future versions.

## Known bug(s)

**YUV 420** to **RGB** conversion sometimes give incorrect color information. **Camera support** for flutter is limited and an unknown bug in it might be causing this problem. Switch camera or re-launch the app if you encounter this bug. The picked color might not be perfect at the moment and I will be working to fix it in future (Hoping to reimplement using some new camera API release for flutter).

## Testing

This app is currently tested on my **Vivo V5 Pro** android phone.

## Credits

This app is entirely created in **Flutter** framework.
The icon is designed by me in **Inkwell** which is an open-source graphic design program.
