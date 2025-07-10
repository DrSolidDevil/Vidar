## [1.0.3-beta](https://github.com/DrSolidDevil/Vidar/compare/v1.0.2-beta...v1.0.3-beta) (2025-07-10)

> No real changes for the end user; upgrading is not necessary.

### Other Changes
* Change license from 3-Clause BSD to Mozilla Public License Version 2.0 [`87bed3f`](https://github.com/DrSolidDevil/Vidar/commit/87bed3ffa831e00e8a6e235bb8129a0292bd92b6)
* Added version validation for pushing to main. [`c259588`](https://github.com/DrSolidDevil/Vidar/commit/c2595885e4b817f1c397bba621fef352911f4322)

<br>

## [1.0.2-beta](https://github.com/DrSolidDevil/Vidar/compare/v1.0.1-beta...v1.0.2-beta) (2025-07-09)

> Very minor changes relating to some refactoring and logging. No real changes for the end user; upgrading is not necessary.

### Other Changes
* Made encryption error messages public and made message_bar.dart use these when checking for specific error type in switch. [`8315d69`](https://github.com/DrSolidDevil/Vidar/commit/8315d69f60a2fafc2e6bf924f12d846cb2b6dd71)
* Added info to log in encryptMessage when no key exists, informing if it is allowed or not. [`de0478d`](https://github.com/DrSolidDevil/Vidar/commit/de0478d16ce98aff72281f64a752e21ae1ebad4e)

<br>

## [1.0.1-beta](https://github.com/DrSolidDevil/Vidar/compare/v1.0.0-beta...v1.0.1-beta) (2025-07-08)

> Minor patch relating to editing existing contacts and errors shown in the message bar.

### Bug Fixes
* Fixed error widget from message bar not adapting to changes in viewinsets (i.e. keyboard). [`c9bc4b9`](https://github.com/DrSolidDevil/Vidar/commit/c9bc4b91c5e586df7a33b3244028f5fb398a0780)
* Fixed displaying of error widget when transitioning from keyboard being up to it being down or vice versa. [`c9bc4b9`](https://github.com/DrSolidDevil/Vidar/commit/c9bc4b91c5e586df7a33b3244028f5fb398a0780)

### Other Changes
* If a user forgets to enter a plus sign before the phone number it automatically adds it. [`a5f4980`](https://github.com/DrSolidDevil/Vidar/commit/a5f49804b6a098089a340949bb560215330c184d)
* Editing existing contact's details is now subject to a check of contact information invalidity. [`a5f4980`](https://github.com/DrSolidDevil/Vidar/commit/a5f49804b6a098089a340949bb560215330c184d)
* Display time for errors related to sending messages and the message bar is extended to 15 seconds. [`c9bc4b9`](https://github.com/DrSolidDevil/Vidar/commit/c9bc4b91c5e586df7a33b3244028f5fb398a0780)

<br>

## [1.0.0-beta](https://github.com/DrSolidDevil/Vidar/compare/v0.1.0...v1.0.0-beta) (2025-07-07)

> This release marks a major milestone in Vidar's development. While still in beta, it introduces a wide range of new features, performance improvements, and changes that bring Vidar closer to a stable 1.0 release.

### Breaking Changes
* Made key storage encrypted using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage). [`489d3af`](https://github.com/DrSolidDevil/Vidar/commit/489d3af688163e74ca035663ed842b2bfb712288)
* APK package name renamed from `com.vidar.vidar` to `com.drsoliddevil.vidar`. This may affect upgrades and backups. [`2bd9cae`](https://github.com/DrSolidDevil/Vidar/commit/2bd9caee388cdc80218a83908ac7a4872d05ba76)


### New Features
* Ability to delete contacts from contact list by holding on the contact badge (i.e. long press). [`42f5681`](https://github.com/DrSolidDevil/Vidar/commit/42f5681ca3140c1b021c72dd6f3ace0f87726775)
* Loading screen while you load a conversation. [`be5e0b9`](https://github.com/DrSolidDevil/Vidar/commit/be5e0b9ed0bfbda1ea01014b00c7d297ae541368)
* Ability to wipe all keys with one button (in settings). [`cd466ea`](https://github.com/DrSolidDevil/Vidar/commit/cd466eae30f804ad5e1afd9be6bf734699660792)
* System for logging with ability to export logs. [`33d1972`](https://github.com/DrSolidDevil/Vidar/commit/33d1972c4e7393860a19a2b2aeaba958f69adf05) [`95f4a7d`](https://github.com/DrSolidDevil/Vidar/commit/95f4a7d1c01fa282bfedc02500ecb9c5671cac4b) [`089dcd9`](https://github.com/DrSolidDevil/Vidar/commit/089dcd91ab6d52647888ae1b0517081770d5c0db) [`004c51d`](https://github.com/DrSolidDevil/Vidar/commit/004c51df68b2e33748c43915bf9c3ddf243931cf)

### Bug Fixes
* Fixed phone number parsing only applying to new contact. [`becca8a`](https://github.com/DrSolidDevil/Vidar/commit/becca8ae7f94f8f66ec7b237769b882df456182b)
* Fixed SmsReceiver and SmsNotifier. [`7a6ede2`](https://github.com/DrSolidDevil/Vidar/commit/7a6ede25e8e04196d0c9d22ebe719049de034468) [`579a46d`](https://github.com/DrSolidDevil/Vidar/commit/579a46dcd5919782e3bcd2879661af8df5a12ac9) [`6629316`](https://github.com/DrSolidDevil/Vidar/commit/662931697ed4070d22bb80950e0ece5e3e92613f)

### Performance Improvements
* _generateRandomChar or _generateUniqueRandomInt does not need to create a new instance of Random every time they are called (if a Random object is provided via parameters). [`e9f8355`](https://github.com/DrSolidDevil/Vidar/commit/e9f8355e9fa0eb0b6e730b97a989697091351775)
* decryptMessage does not need to create a new instance of AesGcm every time they are called (if a AesGcm object is provided via parameters). [`d47ebb8`](https://github.com/DrSolidDevil/Vidar/commit/d47ebb825653ad99f183cd4d90a22098c5c1f326)

### Other Changes
* Rewritten readme. [`5e33c19`](https://github.com/DrSolidDevil/Vidar/commit/5e33c19f4a9d61d294e678f68249639c5fc8a1d9)
* Created a security policy. [`6c8dd32`](https://github.com/DrSolidDevil/Vidar/commit/6c8dd326d5da617fcbe9fbeeaf285fc0350e7313) [`ff7afa0`](https://github.com/DrSolidDevil/Vidar/commit/ff7afa0ba4fc3cb1611047bc20544eba36d41d3f) [`1c30221`](https://github.com/DrSolidDevil/Vidar/commit/1c30221b5e9b201a743ef783e44fb19b8309cdf4)
* Created code of conduct (Contributor Covenant). [`f66ca46`](https://github.com/DrSolidDevil/Vidar/commit/f66ca46bc11f667c8541678ca7fab1f92c1a8f62) [`db2e83e`](https://github.com/DrSolidDevil/Vidar/commit/db2e83e6698d18eec29f9574c3f27d71437006dc)
* Created workflows for building APK on new release and running linter before merge into main. [`fb4d988`](https://github.com/DrSolidDevil/Vidar/commit/fb4d988dc35944fd2930a07adc2ddfc99786d1a8)
* Removed web-related code & files. [`130f03e`](https://github.com/DrSolidDevil/Vidar/commit/130f03e70e743318a50a2f20e76bc56aa48f8c40)
* Messages with STATUS_FAILED will now be displayed as "MESSAGE_FAILED" in the conversation. [`bccae1c`](https://github.com/DrSolidDevil/Vidar/commit/bccae1c571472ed84238cc6db06b68db8efad7e7)
* Message bar clears when a message is sent (without error). [`554e62c`](https://github.com/DrSolidDevil/Vidar/commit/554e62ce03b908a71b1fef1d3345a85133af89d4)
* Chat updates when you send a message. [`110b2e2`](https://github.com/DrSolidDevil/Vidar/commit/110b2e2611224218c3e3028205e279d0c7dffbd4)
* Buttons redesigned using TextButton. [`f3de296`](https://github.com/DrSolidDevil/Vidar/commit/f3de29691a4ff1e054f6e90d1916c6bcce236432)
* Minor visual enhancements [`2540ad7`](https://github.com/DrSolidDevil/Vidar/commit/2540ad751c03dce39885fbb5b36551a3325a0962) [`fe025ee`](https://github.com/DrSolidDevil/Vidar/commit/fe025ee8cec4edd8eeb5ee0be77886747678fa97) [`454ce0c`](https://github.com/DrSolidDevil/Vidar/commit/454ce0cae7b3ddf7dfe74cbdf3344d227671de74)
* Fixed typos. [`34a7a4a`](https://github.com/DrSolidDevil/Vidar/commit/34a7a4a4f2857c363fb0c5ee51c665a92f4a73c0) [`cd820ed`](https://github.com/DrSolidDevil/Vidar/commit/cd820edfd1927d5be5ad7bafcd83491c53deb695) [`f9fd354`](https://github.com/DrSolidDevil/Vidar/commit/f9fd3546b8b302165e051aacad63081b6504f579 )

