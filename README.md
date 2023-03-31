# booking_extra

A Booking App for Phu Quoc Express

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

when we are try to install on the Sunmi V2 Device , the compile get error
Execution failed for task ':flutter_sunmi_printer:compileDebugJavaWithJavac'.

To fix this bug just delete all the comments:
-> Go to the root of the package in Flutter Plugins
-> Ctrl + shift + r;
-> Search for \/\*([\s\S]_?\*\/) with REGEX enabled;
-> Delete everything
-> Search for \/\/._ with REGEX enabled;
-> Delete everything but the code in Android Manifest
-> Have fun


------Lỗi liên quan Gradle-----
Could not initialize class org.codehaus.groovy.runtime.InvokerHelper site:stackoverflow.com

Downgrade Java đang cài trên máy xuống version 8 (cụ thể 8 fix pack 361)
Check Java version bằng lệnh java -version trong phần Terminal