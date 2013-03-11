
<script src="/includes/sha1.js" type="text/javascript"></script>  
<script src="/includes/pidcrypt.js" type="text/javascript"></script>  
<script src="/includes/pidcrypt_util.js" type="text/javascript"></script> 
<script src="/includes/md5.js" type="text/javascript"></script>
<script src="/includes/md5_cbc.js" type="text/javascript"></script>
<script src="/includes/aes_core.js" type="text/javascript"></script>
<script src="/includes/aes_cbc.js" type="text/javascript"></script>  


<script type="text/javascript">

function encriptar(texto_a_encriptar, key){
// AESEncryptCtr(plaintext, password, nBits)
//  * @param ciphertext source text to be encrypted
//  * @param password   the password to use to generate a key
//  * @param nBits      number of bits to be used in the key (128, 192, or 256)
// function AESDecryptCtr(ciphertext, password, nBits) 

//     var key= b64_sha256(b64_md5(key));
//     key = 'nEEhnZwM8ZdiFYYZpcixWnOUmCG57lvr6ksUJuiMXpo';
    var aes = new pidCrypt.AES.CBC();
    //encrypt the plaintext and returns the encrypted text
    //parameters: plaintext(String), password(String) and options
    var crypted = aes.encryptText(texto_a_encriptar, key, {nBits: 256});
    
    return crypted;
}

function desencriptar(texto_a_desencriptar, key){
    var aes = new pidCrypt.AES.CBC();
    var plain = aes.decryptText(texto_a_desencriptar, key, {nBits: 256, UTF8: false});

    return plain;
}

</script>