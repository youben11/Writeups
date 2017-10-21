
|Challenge |
|------------|
|It's the developer's first mobile application.hey are trying their hand at storing secrets securely. Could one of them be the flag? (150 pts)|

|file|
|-------------|
|[pinstore.apk](https://github.com/youben11/BSides-San-Francisco-CTF-2017/blob/master/pinstore.apk)|


We start by : unzip pinstore.apk 
then convert the classes.dex file to jar by using : d2j-dex2jar classes.dex
we have now to extract the jar file and decompile all class file using javadecompiler

we can start by reading MainActivity.java : we have to enter a pin which will be compared to the pin provided by 
DatabaseUtilities.fetchpin(), so we read the DatabaseUtilities.java and find this interesting line : 

Cusror cursor = db.rawQuery("SELECT pin FROM pinDB" , null);

we search for a database file and find  assets/pinlock.db

[youben@youben assets]$ sqlite3 pinlock.db 

SQLite version 3.14.2 2016-09-12 18:50:49

Enter ".help" for usage hints.

sqlite> SELECT pin FROM pinDB;

d8531a519b3d4dfebece0259f90b466a23efc57b

we can easily find the pin by searching on google 7498

we can also read assets/README:

v1.0:
- Pin database with hashed pins

v1.1:
- Added AES support for secret

v1.2:
- Derive key from pin
[To-do: switch to the new database]

So now we know that we have to switch to the new db

after reading SecretDisplay.java and CryptoUtilities.java we know that the app is reading a secret from the databases and
using an algorithm to decrypt it, but we have two secret and two algorithm and all what we need to do is switching to 
the second secret and algorithm.

we convert the classes.dex to a smali to patches it

[youben@youben pinstore]$ baksmali classes.dex

we modify SecretDisplay.smali : 

const-string v7, "v1" --> const-string v7, "v2" // (line 74) to switch to the second algorithm

and modify the DatabaseUtilities.smali : 

const-string v1, "SELECT entry FROM secretsDBv1" --> const-string v1, "SELECT entry FROM secretsDBv2" //(line 315) to switch to the second table and get the second secret

we can now rebuild the app :

[youben@youben pinstore]$ smali out/ -o classes.dex

[youben@youben patches]$ ls

AndroidManifest.xml  assets  classes.dex  res  resources.arsc // (the new classes.dex)

[youben@youben patches]$ jar -cvf myapp.apk *
//(use you keystore to sign the jar)

[youben@youben patches]$ adb install myapp.apk 

[100%] /data/local/tmp/myapp.apk

pkg: /data/local/tmp/myapp.apk

Success

run the app, enter the pin ... you can see the flag.
