#Sudo_root
#youben

Secret project 300pts :

Yesterday Bill was murdered , we know from his friend that he
was working on a secret project but nobody knows what is it (thats why its secret xD )
the police did some forensics and found this interesting file , but they couldn't go deeper.
Can you ?

We have a big directory which i can't upload so i will focus more on the reversing part.

After doing some forensic and extract the content of userdata-qemu.img, we can find com.th3jackers.th3jand-1.apk
it seems to be the application intended to be reversed

<img src="https://github.com/youben11/MCTF-2017/blob/master/terminal_ls.png" />

this time i used [jadx](https://github.com/skylot/jadx) to reverse the [apk](https://github.com/youben11/MCTF-2017/blob/master/com.th3jackers.th3jand-1.apk)

<img src="https://github.com/youben11/MCTF-2017/blob/master/code_onClick.png"/>

we know now that the format of the flag is :
+ "th3jackers{" +
+ String.valueOf(this.edittext.getText()).substring(0, 6) +
+ String.valueOf(new Random().nextInt(10)) +
+ cksum() +
+ String.valueOf(TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis())) + "}"

at this moment we don't know 3 things :

1. String.valueOf(this.edittext.getText()).substring(0, 6) + String.valuesOf(new Random().nextInt())
2. cksum()
3. timestamp to use (String.valueOf(TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis())))

we will discuss each of this point :

1. we can see in the xml file of the layout that the imputType is set to:

   android:inputType="number|numberSigned|numberDecimal|numberPassword|phone"
   
   so all we have to do is brute force 7 decimal digit that gives 10000000 try which is possible to do in few minutes
   
2. cksum() return the CRC of the entry("classes.dex") in the zipfile of com.th3jackers.th3jand-1.apk
  we can get it with some code:
  
  <img src="https://github.com/youben11/MCTF-2017/blob/master/code_crc.png"/>
  
  <img src="https://github.com/youben11/MCTF-2017/blob/master/terminal_crc.png"/>
  
3. we can get the timestamp by getting the timestamp of the userdata-qemu/data/com.th3jackers.th3jand-1.apk/files/enc_flag 
<img src="https://github.com/youben11/MCTF-2017/blob/master/terminal_timestamp.png"/>
  
We can now run a brute-force to get the flag

We get the md5(flag) from "enc_flag" file
  
  <img src="https://github.com/youben11/MCTF-2017/blob/master/code_bf.png"/>
  
  <img src="https://github.com/youben11/MCTF-2017/blob/master/terminal_bf.png"/>
  
  I hope you enjoy it :)
  
