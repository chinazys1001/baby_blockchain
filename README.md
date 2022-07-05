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
- **ECPublicKey** *publicKey* - публічний ключ пари. Використовується як індентифікатор для акаунту та для верифікації цифрового підпису. Значення публічного ключа використовується при верифікації роботом токена, який буде надсилатися йому при підключенні. Для зручності значення публічного ключа кодується за base64.
- **ECPrivateKey** *privateKey* - приватний ключ пари. Використовується для генерації цифрового підпису. Значення приватного ключа використовується для генерації токена, який буде надсилатися роботу при підключенні. Для зручності значення приватного ключа кодується за base64. В рамках практичного завдання обов'язки по безпечному зберіганню приватного ключа делегуються користувачу, який буде користуватися цим приватним ключем для входу в [користувацький додаток](https://baby-blockchain.web.app). Приватний ключ НЕ зберігається та НЕ відновлюється блокчейном.

Методи:
- **public static KeyPair** *genKeyPair()* - виконує випадкову генерацію ключової пари. Використовується при створенні нового акаунту.
- **public static KeyPair** *getKeyPairFromPrivateKey(*__ECPrivateKey__ *privateKey)* - функція отримання ключової пари по даному приватному ключу. Використовується при вході до акаунту.
- **public void** *printKeyPair()* - для тестування.

## Клас Signature
#### [signature.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/signature.dart)
Для створення цифрового підпису та його перевірки використовується Elliptic Curve Cryptography. Опис використовуваної реалізації алгоритму генерації цифрового підпису та його верифікації наведено в [документації](https://pub.dev/packages/crypton).

Методи:
- public static Uint8List signData(String data, ECPrivateKey privateKey) - генерує цифровий підпис для операцій. Використовується при створенні операції передачі прав власності на робота між акаунтами та як верифікаційний токен, який надсилається при підключенні до робота.
- public static bool verifySignature(Uint8List signature, String data, ECPublicKey publicKey) - перевіряє цифровий підпис операції. Використовується для валідації операцій у блокчейні. Клон цього методу використовується програмним забезпеченням роботу при перевірці верифікаційного токена.

## Клас Account
#### [account.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/account.dart)
Об'єкти:
- String accountID - унікальний ідентифікатор, адреса акаунту у системі. Його значення співпадає з public key акаунту.
- KeyPair keyPair - ключова пара акаунту. Відповідно до [Terms of Reference](https://github.com/chinazys1001/distributed_lab_workshop/tree/main/BabyBlockchain#%D0%B0%D0%BA%D0%B0%D1%83%D0%BD%D1%82), кожен акаунт має рівно одну ключову пару. Використання акаунтом ключової пари [описано вище](https://github.com/chinazys1001/baby_blockchain#%D0%BA%D0%BB%D0%B0%D1%81-keypair).
- Set robots - "баланс" акаунту (об'єкти класу Robot, якими володіє даний акаунт).

Методи:
- public static Account genAccount() - функція створення нового акаунту: генерація ключової пари акаунту(реалізується класом KeyPair) та пустого списку robots. Новий акаунт додається до robotDatabase.
- public static Account tryToSignInToAccount(ECPrivateKey privateKey) - функція входу до акаунту. "Under the hood" за вказаним при вході приватним ключем отримується відповідна ключова пара. Звідси отримується id акаунту (public key ключової пари. За id акаунту перевіряється наявність даного акаунту в robotDatabase. Якщо наявність акаунту підтверджується, то список robots синхронізується з robotDatabase і користувач заходить в застосунок. В іншому випадку користувачеві повідомляється про помилку у введеному private key.
- public void addRobot(Robot robot) - функція додавання права власності на даного робота до акаунту. Використовується при здійсненні операції отримання прав власності.
- public void removeRobot(Robot robot) - функція виключення права власності на даного робота списку robots акаунту. Використовується при здійсненні операції передачі прав власності.
- public Operation createOperation(Account buyer, String robotID) - функція створення операції передачі прав власності на робота з даним robotID, яким володіє даний акаунт, до акаунту buyer. Функціонал створення операції реалізується класом Operation.
- public Uint8List signData(String data) - функція створення цифрового підпису вхідних даних акаунтом. Використовується при підключенні до робота (генерації верифікаційного токенуі) та при продажі (операцію передачі прав власності підписує акаунт-продавець). Функціонал цифрового підпису реалізується класом Signature.
- void printRobots() - для тестування.
- void printAccount() - для тестування.

Оператори:
- operator ==(other) - оператор порівняння двох акаунтів. Два акаунта вважаються однаковими, якщо їх ID співпадають.

## Клас Operation
#### [operation.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/operation.dart)
Об'єкти:
- Account seller - акаунт, який володіє роботом та хоче передати його акаунту buyer.
- Account buyer - акаунт, на який передається право володіння на робота.
- String robotID - ідентифікатор робота, яким володіє акаунт seller та права власності на якого в результаті операції передаються акаунту buyer.
- Uint8List sellerSignature - цифровий підпис операції акаунтом seller.

Методи:
- public static Operation createOperation(Account seller, Account buyer, String robotID) - функція створення операції передачі робота з даним ID від акаунту seller до акаунту buyer. Кожна сторена операція має цифровий підпис, здіснений акаунтом seller.
- public static bool verifyOperation(Operation operation) - функція верифікації даної операції. Перевіряється валідність цифрового підпису операції акаунтом seller. 
- void printOperation() - для тестування.

## Клас Transaction
#### [transaction.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/transaction.dart)
Об'єкти:
- String transactionID - хеш-значення від усіх полів транзакції.
- Operation operation - операція даної транзакції. Виходячи зі специфіки системи, кожна транзакція завжди має рівно одну операцію, адже цінність (право власності на робота), яка передається в результаті транзакції, є неділимою - неможливо, наприклад, передати 20% роботу акаунту А, 50% акаунту В, а останні 30% повернути собі. Тому в результаті транзакції здійснюється єдина операція передачі дискретної цінності - права власності на робота від аканту seller до акаунту buyer.
- int nonce - в якості поля nonce операції використовується nonce аканту seller. Nonce аканту - це загальна кількість операцій, ініційованих даним акаунтом (<=> кількість операцій, в яких даний акаунт був seller-акаунтом). Тобто, при кожній спробі здійсненні операції акаунтом значення його nonce інкрементується. Таким чином, не може існувати двох транзакцій з однаковими операціями та однаковими значеннями nonce. Як наслідок, не може існувати двох транзакцій з однаковими ID. Користуючись цим фактом, валідатори перевіряють транзакції та блокують спроби "подвійної трати".   

Методи:
- public static Transaction createTransaction(Operation operation) - функція створення транзакції для даної операції. Nonce транзакції = nonce акаунту seller даної операції. ID транзакції = хеш-значення від operation та nonce.

Оператори:
- operator ==(other) - оператор порівняння двох транзакцій. Дві транзакції вважаються однаковими, якщо їх ID співпадають.

## Клас Hash
#### [hash.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/hash.dart)
Для гешування даних використовується алгоритм SHA-2 (256-bit версія). Опис використовуваної реалізації алгоритму SHA-256 наведено в [документації](https://pub.dev/packages/crypto).
Методи:
- public static String toSHA256(String input) - виконує гешування вхідних даних.
- public static bool matches(String value, String hash) - перевіряє, чи є значення hash результатом гешування значення value.

## Клас Block
//TODO

## Клас Blockchain
//TODO

## Клас Robot
#### [robot.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/robot.dart)
Об'єкти:
- String robotID - унікальний ідентифікатор роботу.
- String ownerID - ID акаунту-власника даного роботу. 
- String robotName - характеристика роботу. В повноцінній реалізації, вочовидь, кожен робот матиме багато параметрів, які можна буде налаштовувати в застосунку. В якості мінімального прикладу кожен робот матиме єдину характеристику - своє умовне ім'я. Воно завжди є різним серед роботів, які мають однакового власника, але не є унікальним загально (тобто роботи двох різних акаунтів можуть мати однакові імена).
- bool isTestMode - дорівнює True, якщо даного робота було створено у тестувальному режимі.

Методи:
- public static Robot generateRandomRobot(String ownerID, {bool isTestMode = true}) - функція генерації випадкового робота та присвоєння його акаунту з даним ownerID (як правило, ця функція використовується при тестуванні). Для створення роботу генерується випадковий ID та ім'я. Для генерації robotID використовується хеш від пари ownerID - nonce відповідного акаунту (при додаванні роботу до акаунту nonce завжди інкрементується, тому поєднання ID акаунту та nonce акаунту можна вважати унікальним). Для генерації robotName обирається випадкове ім'я зі списку randomRobotNames та при необхідності додається суфікс (наприклад, якщо так трапилось, що випадкове ім'я - Taras, та даний акаунт вже володіє роботом на ім'я Taras, то до цього ім'я додається унікальний суфікс - отримуємо Taras-2, і так далі за аналогією). 
- public void requestConnection() - псевдо-функція підключення до роботу. На її прикладі показано реальний процес генерації токену, псевдо-код надсилання цього токену роботу та обробки відповідей робота. Поки що ці роботи існують тільки в уявленні, тому цей метод є суто демонстраційним.
- public Map toMap() - використовується для зручного парсингу інформації про робота в robotDatabase.
- public Set fromList(List robotList) - використовується для зручного розпарсингу списку даних по роботах з robotDatabase в сет роботів.
- public void printRobot() - для тестування.

Оператори:
- operator ==(other) - оператор порівняння двох роботів. Два робота вважаються однаковими, якщо їх ID співпадають.

## VerificationalToken
#### [verificational_token.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/lib/domain_layer/verificational_token.dart)
Методи:
- public static Uint8List generate(Account account, String robotID) - функція генерації верифікаційного токена. На вхід отримує об'єкт класу Account, з якого треба створити запит на підключення, та ID робота, якому треба надіслати верифікаційний токен для підключення. Токен - це значення цифрового підпису даного robotID (умовно кажучи, ID роботу - це меседж) даним акаунтом (див. метод signData класу Account). Робот вже "знає" свій ID та public key свого власника, тому може здіснити перевірку надісланої сігнатури (див. метод verifySignature класу Signature. Таким чином, перевірка роботом цього токена покаже, чи знає надсилач цього токену privateKey акаунту-власника цього роботу <=> чи поступив цей запрос на підключення від реального власника цього роботу.
