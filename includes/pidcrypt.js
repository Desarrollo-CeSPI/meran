 // Copyright (c) 2009 pidder <www.pidder.com>
 // Permission to use, copy, modify, and/or distribute this software for any
 // purpose with or without fee is hereby granted, provided that the above
 // copyright notice and this permission notice appear in all copies.
 //
 // THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 // WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 // MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 // ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 // WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 // ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 // OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* pidCrypt is pidders JavaScript Crypto Library - www.pidder.com/pidcrypt
 * Version 0.01, 02/2009
 *
 * pidCrypt is a combination of different JavaScript functions for client side
 * encryption technologies with enhancements for openssl compatibility cast into
 * a modular class concept.
 *
 * Client side encryption is a must have for developing host proof applications:
 * There must be no knowledge of the clear text data at the server side, all
 * data is enrycpted prior to being submitted to the server.
 * Client side encryption is mandatory for protecting the privacy of the users.
 * "Dont't trust us, check our source code!"
 *
 * "As a cryptography and computer security expert, I have never understood
 * the current fuss about the open source software movement. In the
 * cryptography world, we consider open source necessary for good security;
 * we have for decades. Public security is always more secure than proprietary
 * security. It's true for cryptographic algorithms, security protocols, and
 * security source code. For us, open source isn't just a business model;
 * it's smart engineering practice."
 * Bruce Schneier, Crypto-Gram 1999/09/15
 * copied form keepassx site - keepassx is a cross plattform password manager
 *
 * pidCrypt comes with modules under different licenses and copyright terms.
 * Make sure that you read and respect the individual module license conditions
 * before using it.
 *
 * The pidCrypt base library contains:
 * 1. pidcrypt.js
 *    class pidCrypt: the base class of the library
 * 2. pidcrypt_util.js
 *    base64 en-/decoding as new methods of the JavaScript String class
 *    UTF8 en-/decoding as new methods of the JavaScript String class
 *    String/HexString conversions as new methods of the JavaScript String class
 *
 * The pidCrypt v0.01 modules and the original authors (see files for detailed
 * copyright and license terms) are:
 *
 * - md5.js:      MD5 (Message-Digest Algorithm), www.webtoolkit.info
 * - aes_core.js: AES (Advanced Encryption Standard ) Core algorithm, B. Poettering
 * - aes-ctr.js:  AES CTR (Counter) Mode, Chis Veness
 * - aes-cbc.js:  AES CBC (Cipher Block Chaining) Mode, pidder
 * - jsbn.js:     BigInteger for JavaScript, Tom Wu
 * - prng.js:     PRNG (Pseudo-Random Number Generator), Tom Wu
 * - rng.js:      Random Numbers, Tom Wu
 * - rsa.js:      RSA (Rivest, Shamir, Adleman Algorithm), Tom Wu
 * - oids.js:     oids (Object Identifiers found in ASN.1), Peter Gutmann
 * - asn1.js:     ASN1 (Abstract Syntax Notation One) parser, Lapo Luchini
 * - sha256.js    SHA-256 hashing, Angel Marin 
 * - sha2.js:     SHA-384 and SHA-512 hashing, Brian Turek
 *
 * IMPORTANT:
 * Please report any bugs at http://sourceforge.net/projects/pidcrypt/
 * Vist http://www.pidder.com/pidcrypt for online demo an documentation
 */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

function pidCrypt(){
  //TODO: better radomness!
  function getRandomBytes(len){
    if(!len) len = 8;
    var bytes = new Array(len);
    var field = [];
    for(var i=0;i<256;i++) field[i] = i;
    for(i=0;i<bytes.length;i++)
      bytes[i] = field[Math.floor(Math.random()*field.length)];
    return bytes
  }

  this.setDefaults = function(){
     this.params.nBits = 256;
  //salt should always be a Hex String e.g. AD0E76FF6535AD...
     this.params.salt = byteArray2String(getRandomBytes(8)).convertToHex();
     this.params.blockSize = 16;
     this.params.UTF8 = true;
     this.params.A0_PAD = true;
  }

  this.debug = true;
  this.params = {};
  //setting default values for params
  this.params.dataIn = '';
  this.params.dataOut = '';
  this.params.decryptIn = '';
  this.params.decryptOut = '';
  this.params.encryptIn = '';
  this.params.encryptOut = '';
  //key should always be a Hex String e.g. AD0E76FF6535AD...
  this.params.key = '';
  //iv should always be a Hex String e.g. AD0E76FF6535AD...
  this.params.iv = '';
  this.params.clear = true;
  this.setDefaults();
  this.errors = '';
  this.warnings = '';
  this.infos = '';
  this.debugMsg = '';
  //set and get methods for base class
  this.setParams = function(pObj){
    if(!pObj) pObj = {};
    for(var p in pObj)
      this.params[p] = pObj[p];
  }
  this.getParams = function(){
    return this.params;
  }
  this.getParam = function(p){
    return this.params[p] || '';
  }
  this.clearParams = function(){
      this.params= {};
  }
  this.getNBits = function(){
    return this.params.nBits;
  }
  this.getOutput = function(){
    return this.params.dataOut;
  }
  this.setError = function(str){
    this.error = str;
  }
  this.appendError = function(str){
    this.errors += str;
    return '';
  }
  this.getErrors = function(){
    return this.errors;
  }
  this.isError = function(){
    if(this.errors.length>0)
      return true;
    return false
  }
  this.appendInfo = function(str){
    this.infos += str;
    return '';
  }
  this.getInfos = function()
  {
    return this.infos;
  }
  this.setDebug = function(flag){
    this.debug = flag;
  }
  this.appendDebug = function(str)
  {
    this.debugMsg += str;
    return '';
  }
  this.isDebug = function(){
    return this.debug;
  }
  this.getAllMessages = function(options){
    var defaults = {lf:'\n',
                    clr_mes: false,
                    verbose: 15//verbose level bits = 1111
        };
    if(!options) options = defaults;
    for(var d in defaults)
      if(typeof(options[d]) == 'undefined') options[d] = defaults[d];
    var mes = '';
    var tmp = '';
    for(var p in this.params){
      switch(p){
        case 'encryptOut':
          tmp = this.params[p].toString().toByteArray();
          tmp = tmp.join().fragment(64, options.lf)
          break;
        case 'key': 
        case 'iv':
          tmp = this.params[p].formatHex(48);
          break;
        default:
          tmp = this.params[p].toString().fragment(64, options.lf);
      }  
      mes += '<p><b>'+p+'</b>:<pre>' + tmp + '</pre></p>';
    }  
    if(this.debug) mes += 'debug: ' + this.debug + options.lf;
    if(this.errors.length>0 && ((options.verbose & 1) == 1)) mes += 'Errors:' + options.lf + this.errors + options.lf;
    if(this.warnings.length>0 && ((options.verbose & 2) == 2)) mes += 'Warnings:' +options.lf + this.warnings + options.lf;
    if(this.infos.length>0 && ((options.verbose & 4) == 4)) mes += 'Infos:' +options.lf+ this.infos + options.lf;
    if(this.debug && ((options.verbose & 8) == 8)) mes += 'Debug messages:' +options.lf+ this.debugMsg + options.lf;
    if(options.clr_mes)
      this.errors = this.infos = this.warnings = this.debug = '';
    return mes;
  }
  this.getRandomBytes = function(len){
    return getRandomBytes(len);
  }
  //TODO warnings
}
