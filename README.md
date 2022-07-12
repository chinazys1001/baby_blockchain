![Flutter](	https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
# BabyBlockchain
Демонстраційний веб-застосунок реалізовано у фрейморці Flutter, для емуляції backend-ресурсів використовується Firebase Firestore. Для підвищення зручності перевірки завдання стисло охарактеризуємо загальну архітектуру проекту:
- Майже весь "смисловий" код знаходиться у фолдері [/lib](https://github.com/chinazys1001/baby_blockchain/tree/master/lib). Інші файли - це, здебільшого, platform-specific код або конфігуратори використовуваних Flutter/Firebase ресурсів. Єдине, що може бути серед них корисним - файл [pubspec.yaml](https://github.com/chinazys1001/baby_blockchain/blob/master/pubspec.yaml). Там можна знайти повний список використовуваних сторонніх бібліотек, він знакодиться у розділі "dependencies". З документацією цих бібліотек можна ознайомитися на сайті [pub.dev](https://pub.dev).
- У фолдері [/lib](https://github.com/chinazys1001/baby_blockchain/tree/master/lib) знаходяться файли [main.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/main.dart) (стандартно, це entry point виконання програмного коду, не має "ідейної" складової), [constants.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/constants.dart) (перелік використовуваних константних значень) та фолдери стандартних архітектурних леєрів ([/data_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/data_layer), [/domain_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/domain_layer), [/presentation_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/presentation_layer)). В [data_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/data_layer) знаходиться програмний код для взаємодії з бекенд-ресурсами, у нашому випадку специфічний для Firebase, в [presentation_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/presentation_layer)) міститься код для конфігурації UI, специфічний для використовуваного фреймворку Flutter. Обидва розглянуті леєри, вочовидь, не несуть дослідницької цінності.
- А ось в [domain_layer](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/domain_layer) знаходиться код, що є найбільш важливим в контексті розглянутої задачі. В ньому описана вся бізнес-логіка застосунку, у нашому випадку - впровадження блокчейну та усіх пов'язаних класів/методів/об'єктів. Весь код написано на dart (ця мова програмування належить до C-family). Детальні відомості щодо реалізації та використання кожного класу наведені нижче.

## Клас KeyPair
#### [key_pair.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/key_pair.dart)
Для створення ключової пари використовується Elliptic Curve Cryptography. Опис використовуваної реалізації алгоритму генерації ключової пари наведено в [документації](https://pub.dev/packages/crypton).

Об'єкти:
- __ECPublicKey__ *publicKey* - публічний ключ пари. Використовується як індентифікатор для акаунту та для верифікації цифрового підпису. Значення публічного ключа використовується при верифікації роботом токена, який буде надсилатися йому при підключенні. Для зручності значення публічного ключа кодується за base64.
- __ECPrivateKey__ *privateKey* - приватний ключ пари. Використовується для генерації цифрового підпису. Значення приватного ключа використовується для генерації токена, який буде надсилатися роботу при підключенні. Для зручності значення приватного ключа кодується за base64. В рамках практичного завдання обов'язки по безпечному зберіганню приватного ключа делегуються користувачу, який буде користуватися цим приватним ключем для входу в [користувацький додаток](https://baby-blockchain.web.app). Приватний ключ НЕ зберігається та НЕ відновлюється блокчейном.

Методи:
- __public static KeyPair__ *genKeyPair()* - виконує випадкову генерацію ключової пари. Використовується при створенні нового акаунту.
- __public static KeyPair__ *getKeyPairFromPrivateKey(*__ECPrivateKey__ *privateKey)* - функція отримання ключової пари по даному приватному ключу. Використовується при вході до акаунту.
- __public void__ *printKeyPair()* - для тестування.

## Клас Signature
#### [signature.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/signature.dart)
Для створення цифрового підпису та його перевірки використовується Elliptic Curve Cryptography. Опис використовуваної реалізації алгоритму генерації цифрового підпису та його верифікації наведено в [документації](https://pub.dev/packages/crypton).

Методи:
- __public static Uint8List__ *signData(*__String__ *data,* __ECPrivateKey__ *privateKey)* - генерує цифровий підпис для операцій. Використовується при створенні операції передачі прав власності на робота між акаунтами та як верифікаційний токен, який надсилається при підключенні до робота.
- __public static bool__ *verifySignature(*__Uint8List__ *signature,* __String__ *data,* __ECPublicKey__ *publicKey)* - перевіряє цифровий підпис операції. Використовується для валідації операцій у блокчейні. Клон цього методу використовується програмним забезпеченням роботу при перевірці верифікаційного токена.

## Клас Account
#### [account.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/account.dart)
Об'єкти:
- __String__ *accountID* - унікальний ідентифікатор, адреса акаунту у системі. Його значення співпадає з public key акаунту.
- __KeyPair__ *keyPair* - ключова пара акаунту. Відповідно до [Terms of Reference](https://github.com/chinazys1001/distributed_lab_workshop/tree/main/BabyBlockchain#%D0%B0%D0%BA%D0%B0%D1%83%D0%BD%D1%82), кожен акаунт має рівно одну ключову пару. Використання акаунтом ключової пари [описано вище](https://github.com/chinazys1001/baby_blockchain#%D0%BA%D0%BB%D0%B0%D1%81-keypair).
- __Robot__[] *robots* - "баланс" акаунту (об'єкти класу __Robot__, якими володіє даний акаунт).

Методи:
- __public satic Account__ *genAccount()* - функція створення нового акаунту: генерація ключової пари акаунту(реалізується класом KeyPair) та пустого списку robots. Новий акаунт додається до __*robotDatabase*__.
- __public static Account__ *tryToSignInToAccount(*__ECPrivateKey__ *privateKey)* - функція входу до акаунту. "Under the hood" за вказаним при вході приватним ключем отримується відповідна ключова пара. Звідси отримується id акаунту (public key ключової пари. За id акаунту перевіряється наявність даного акаунту в __*robotDatabase*__. Якщо наявність акаунту підтверджується, то список robots синхронізується з __*robotDatabase*__ і користувач заходить в застосунок. В іншому випадку користувачеві повідомляється про помилку у введеному private key.
- __public void__ *addRobot(*__Robot__ *robot)* - функція додавання права власності на даного робота до акаунту. Використовується при здійсненні операції отримання прав власності.
- __public void__ *removeRobot(*__Robot__ *robot)* - функція виключення права власності на даного робота списку robots акаунту. Використовується при здійсненні операції передачі прав власності.
- __public Operation__ *createOperation(*__Account__ *receiver,* __String__ *robotID)* - функція створення операції передачі прав власності на робота з даним *robotID*, яким володіє даний акаунт, до акаунту *receiver*. Функціонал створення операції реалізується класом __Operation__.
- __public Uint8List__ *signData(*__String__ *data)* - функція створення цифрового підпису вхідних даних акаунтом. Використовується при підключенні до робота (генерації верифікаційного токену) та при продажі (операцію передачі прав власності підписує акаунт-продавець). Функціонал цифрового підпису реалізується класом __Signature__.
- __void__ *printRobots()* - для тестування.
- __void__ *printAccount()* - для тестування.

Оператори:
- **operator ==**_(other)_ - оператор порівняння двох акаунтів. Два акаунта вважаються однаковими, якщо їх ID співпадають.

## Клас Operation
#### [operation.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/operation.dart)
Об'єкти:
- __Account__ *sender* - акаунт, який володіє роботом та хоче передати його акаунту *receiver*.
- __Account__ *receiver* - акаунт, на який передається право володіння на робота.
- __String__ *robotID* - ідентифікатор робота, яким володіє акаунт *sender* та права власності на якого в результаті операції передаються акаунту *receiver*.
- __Uint8List__ *senderSignature* - цифровий підпис операції акаунтом *sender*.

Методи:
- __public static Operation__ *createOperation(*__Account__ *sender,* __Account__ *receiver,* __String__ *robotID)* - функція створення операції передачі робота з даним *robotID* від акаунту *sender* до акаунту *receiver*. Кожна сторена операція має цифровий підпис, здіснений акаунтом *sender*.
- __public static bool__ *verifyOperation(*__Operation__ *operation)* - функція верифікації даної операції. Перевіряється валідність цифрового підпису операції акаунтом *sender* та факт володіння акаунтом *sender* роботом зі вказаним *robotID*. 
- __void__ *printOperation()* - для тестування.

## Клас Transaction
#### [transaction.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/transaction.dart)
Об'єкти:
- __String__ *transactionID* - хеш-значення від усіх полів транзакції.
- __Operation__ *operation* - операція даної транзакції. Виходячи зі специфіки системи, кожна транзакція завжди має рівно одну операцію, адже цінність (право власності на робота), яка передається в результаті транзакції, є неділимою - неможливо, наприклад, передати 20% роботу акаунту А, 50% акаунту В, а останні 30% повернути собі. Тому в результаті транзакції здійснюється єдина операція передачі дискретної цінності - права власності на робота від акаунту *sender* до акаунту *receiver*.
- __int__ *nonce* - в якості поля *nonce* операції використовується nonce аканту sender. Nonce аканту - це загальна кількість операцій, ініційованих даним акаунтом (<=> кількість операцій, в яких даний акаунт був sender-акаунтом). Тобто, при кожній спробі здійсненні операції акаунтом значення його nonce інкрементується. Таким чином, не може існувати двох транзакцій з однаковими операціями та однаковими значеннями nonce. Як наслідок, не може існувати двох транзакцій з однаковими ID. Користуючись цим фактом, валідатори перевіряють транзакції та блокують спроби "подвійної трати".   

Методи:
- __public static Transaction__ *createTransaction(*__Operation__ *operation)* - функція створення транзакції для даної операції. *Nonce* транзакції = nonce акаунту sender даної операції. *transactionID* транзакції = хеш-значення від *operation* та *nonce*.

Оператори:
- **operator ==**_(other)_ - оператор порівняння двох транзакцій. Дві транзакції вважаються однаковими, якщо їх ID співпадають.

## Клас Hash
#### [hash.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/hash.dart)
Для гешування даних використовується алгоритм SHA-2 (256-bit версія). Опис використовуваної реалізації алгоритму SHA-256 наведено в [документації](https://pub.dev/packages/crypto).
Методи:
- __public static String__ *toSHA256(*__String__ *input)* - виконує гешування вхідних даних.
- __public static bool__ *matches(*__String__ *value,* __String__ *hash)* - перевіряє, чи є значення *hash* результатом гешування значення *value*.

## Клас Block
//TODO

## Клас Blockchain
//TODO

## Клас Robot
#### [robot.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/robot.dart)
Об'єкти:
- __String__ *robotID* - унікальний ідентифікатор роботу.
- __String__ *ownerID* - ID акаунту-власника даного роботу. 
- __String__ *robotName* - характеристика роботу. В повноцінній реалізації, вочовидь, кожен робот матиме багато параметрів, які можна буде налаштовувати в застосунку. В якості мінімального прикладу кожен робот матиме єдину характеристику - своє умовне ім'я. Воно завжди є різним серед роботів, які мають однакового власника, але не є унікальним загально (тобто роботи двох різних акаунтів можуть мати однакові імена).
- __bool__ *isTestMode* - дорівнює True, якщо даного робота було створено у тестувальному режимі.

Методи:
- __public static Robot__ *generateRandomRobot(*__String__ *ownerID,* *{bool* __isTestMode__ *= true})* - функція генерації випадкового робота та присвоєння його акаунту з даним *ownerID* (як правило, ця функція використовується при тестуванні). Для створення роботу генерується випадковий ID та ім'я. Для генерації *robotID* використовується хеш від пари *ownerID* - nonce відповідного акаунту (при додаванні роботу до акаунту nonce завжди інкрементується, тому поєднання ID акаунту та nonce акаунту можна вважати унікальним). Для генерації *robotName* обирається випадкове ім'я зі списку [randomRobotNames]("https://github.com/chinazys1001/baby_blockchain/blob/master/lib/constants.dart") та при необхідності додається суфікс (наприклад, якщо так трапилось, що випадкове ім'я - Taras, та даний акаунт вже володіє роботом на ім'я Taras, то до цього ім'я додається унікальний суфікс - отримуємо Taras-2, і так далі за аналогією). 
- __public void__ *requestConnection()* - псевдо-функція підключення до роботу. На її прикладі показано реальний процес генерації токену, псевдо-код надсилання цього токену роботу та обробки відповідей робота. Поки що ці роботи існують тільки в уявленні, тому цей метод є суто демонстраційним.
- __public Map__ *toMap()* - використовується для зручного парсингу інформації про робота в robotDatabase.
- __public Robot[]__ *fromList(*__List__ *robotList)* - використовується для зручного розпарсингу списку даних по роботах з robotDatabase в сет роботів.
- __public void__ *printRobot()* - для тестування.

Оператори:
- **operator ==**_(other)_ - оператор порівняння двох роботів. Два робота вважаються однаковими, якщо їх ID співпадають.

## VerificationalToken
#### [verificational_token.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/verificational_token.dart)
Методи:
- __public static Uint8List__ *generate(*__Account__ *account,* __String__ *robotID)* - функція генерації верифікаційного токена. На вхід отримує об'єкт класу __Account__, з якого треба створити запит на підключення, та ID робота, якому треба надіслати верифікаційний токен для підключення. Токен - це значення цифрового підпису даного *robotID* (фактично, ID роботу - це меседж) даним акаунтом (див. метод *signData* класу __Account__). Робот вже "знає" свій ID та public key свого власника, тому може здіснити перевірку надісланої сігнатури (див. метод *verifySignature* класу __Signature__. Таким чином, перевірка роботом цього токена покаже, чи знає надсилач цього токену privateKey акаунту-власника цього роботу <=> чи поступив цей запрос на підключення від реального власника цього роботу.