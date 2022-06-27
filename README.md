![Flutter](	https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
# BabyBlockchain
Демонстраційний веб-застосунок реалізовано у фрейморці Flutter, для емуляції backend-ресурсів використовується Firebase Firestore. Для підвищення зручності перевірки завдання стисло опишемо архітектуру проекту:
- Майже весь "смисловий" код знаходиться у фолдері [/lib](https://github.com/chinazys1001/baby_blockchain/tree/master/lib). Інші файли - це, здебільшого, platform-specific код або конфігуратори використовуваних Flutter/Firebase ресурсів. Єдине, що може бути серед них корисним - файл [pubspec.yaml](https://github.com/chinazys1001/baby_blockchain/blob/master/pubspec.yaml). Там можна знайти повний список використовуваних сторонніх бібліотек, він знакодиться у розділі "dependencies". З документацією цих бібліотек можна ознайомитися на сайті [pub.dev](https://pub.dev).
- У фолдері [/lib](https://github.com/chinazys1001/baby_blockchain/tree/master/lib) знаходяться файли [main.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/main.dart) (стандартно, це entry point виконання програмного коду, не має "ідейної" складової), [constants.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/constants.dart) (перелік використовуваних константних значень) та фолдери стандартних архітектурних леєрів ([/data_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/data_layer), [/domain_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/domain_layer), [/presentation_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/presentation_layer)). В [data_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/data_layer) знаходиться програмний код для взаємодії з бекенд-ресурсами, у нашому випадку специфічний для Firebase, в [presentation_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/presentation_layer)) міститься код для конфігурації UI, специфічний для використовуваного фреймворку Flutter. Обидва розглянуті леєри, вочовидь, не несуть дослідницької цінності.
- А ось [domain_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/domain_layer) - це те, що є найбільш важливим в контексті розглянутої задачі. В ньому описана вся бізнес-логіка застосунку, у нашому випадку - впровадження блокчейну та усіх пов'язаних класів/методів/об'єктів. Весь код написано на dart (ця мова програмування наслідує синтаксис C++). Детальні відомості по реалізації кожного класу наведені нижче.
## Клас Token
#### [token.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/key_pair.dart)
Єдиний 
О
## Клас KeyPair
#### [key_pair.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/key_pair.dart)
Для створення ключової пари використовується Elliptic Curve Cryptography. Опис використовуваної реалізації алгоритму генерації ключової пари наведено в [документації](https://pub.dev/packages/crypton).
Об'єкти:
- publicKey - публічний ключ пари. Використовується як індентифікатор для класу Account та для верифікації цифрового підпису. Значення публічного ключа використовується при верифікації роботом токена, який буде надсилатися йому при підключенні.
- privateKey - приватний ключ пари. Використовується для генерації цифрового підпису. Значення приватного ключа використовується для генерації токена, який буде надсилатися роботу при підключенні.
Методи:
- genKeyPair() - виконує випадкову генерацію ключової пари. Використовується при створенні нового акаунту.
- printKeyPair() - для тестування.
- toString() - для тестування.
## Клас Signature
#### [signature.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/signature.dart)
Для створення цифрового підпису та його перевірки використовується Elliptic Curve Cryptography. Опис використовуваної реалізації алгоритму генерації цифрового підпису та його верифікації наведено в [документації](https://pub.dev/packages/crypton).
Методи:
- signData(operation, privateKey) - генерує цифровий підпис для операцій. Використовується як верифікаційний токен,який надсилається при підключенні до робота та при створенні операції передачі прав власності на робота між акаунтами.
- verifySignature(signature, operation, publicKey) - перевіряє цифровий підпис операції. Використовується для валідації операцій у блокчейні. Аналог цього методу використовується програмним забезпеченням роботу при перевірці верифікаційного токена.
## Клас Account
//TODO
## Клас Operation
//TODO
## Клас Transaction
//TODO
## Клас Hash
Для гешування даних використовується алгоритм SHA-2 (256-bit версія). Опис використовуваної реалізації алгоритму SHA-256 наведено в [документації](https://pub.dev/packages/crypto).
#### [hash.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/hash.dart)
Методи:
- toSHA256(input) - виконує гешування вхідних даних.
- matches(value, hash) - перевіряє, чи є значення hash результатом гешування значення value.
## Клас Block
//TODO
## Клас Blockchain
//TODO