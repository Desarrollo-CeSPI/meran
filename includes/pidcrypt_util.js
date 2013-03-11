 /*----------------------------------------------------------------------------*/
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
/*----------------------------------------------------------------------------*/
/*  (c) Chris Veness 2005-2008
* You are welcome to re-use these scripts [without any warranty express or
* implied] provided you retain my copyright notice and when possible a link to
* my website (under a LGPL license). §ection numbers relate the code back to
* sections in the standard.
/*----------------------------------------------------------------------------*/
/* Helper methods (base64 conversion etc.) needed for different operations in
 * encryption.

/*----------------------------------------------------------------------------*/
/* Intance methods extanding the String object                                */
/*----------------------------------------------------------------------------*/
/**
 * Encode string into Base64, as defined by RFC 4648 [http://tools.ietf.org/html/rfc4648]
 * As per RFC 4648, no newlines are added.
 *
 * @param utf8encode optional parameter, if set to true Unicode string is
 *                   encoded into UTF-8 before conversion to base64;
 *                   otherwise string is assumed to be 8-bit characters
 * @return coded     base64-encoded string
 */
String.prototype.encodeBase64 = function(utf8encode) {  // http://tools.ietf.org/html/rfc4648
  var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  utf8encode =  (typeof utf8encode == 'undefined') ? false : utf8encode;
  var o1, o2, o3, bits, h1, h2, h3, h4, e=[], pad = '', c, plain, coded;
  var debug = this.toByteArray();
//  alert(debug.slice(debug.length-10));

  plain = utf8encode ? this.encodeUTF8() : this;

  c = plain.length % 3;  // pad string to length of multiple of 3
  if (c > 0) { while (c++ < 3) { pad += '='; plain += '\0'; } }
  // note: doing padding here saves us doing special-case packing for trailing 1 or 2 chars

  for (c=0; c<plain.length; c+=3) {  // pack three octets into four hexets
    o1 = plain.charCodeAt(c);
    o2 = plain.charCodeAt(c+1);
    o3 = plain.charCodeAt(c+2);

    bits = o1<<16 | o2<<8 | o3;

    h1 = bits>>18 & 0x3f;
    h2 = bits>>12 & 0x3f;
    h3 = bits>>6 & 0x3f;
    h4 = bits & 0x3f;

    // use hextets to index into b64 string
    e[c/3] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
  }
  coded = e.join('');  // join() is far faster than repeated string concatenation

  // replace 'A's from padded nulls with '='s
  coded = coded.slice(0, coded.length-pad.length) + pad;
  return coded;
}

/**
 * Decode string from Base64, as defined by RFC 4648 [http://tools.ietf.org/html/rfc4648]
 * As per RFC 4648, newlines are not catered for.
 *
 * @param utf8decode optional parameter, if set to true UTF-8 string is decoded
 *                   back into Unicode after conversion from base64
 * @return           decoded string
 */
String.prototype.decodeBase64 = function(utf8decode) {
  var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  utf8decode =  (typeof utf8decode == 'undefined') ? false : utf8decode;
  var o1, o2, o3, h1, h2, h3, h4, bits, d=[], plain, coded;

  //alert(this.slice(this.length-10).toByteArray());

  coded = utf8decode ? this.decodeUTF8() : this;

  for (var c=0; c<coded.length; c+=4) {  // unpack four hexets into three octets
    h1 = b64.indexOf(coded.charAt(c));
    h2 = b64.indexOf(coded.charAt(c+1));
    h3 = b64.indexOf(coded.charAt(c+2));
    h4 = b64.indexOf(coded.charAt(c+3));

    bits = h1<<18 | h2<<12 | h3<<6 | h4;

    o1 = bits>>>16 & 0xff;
    o2 = bits>>>8 & 0xff;
    o3 = bits & 0xff;

    d[c/4] = String.fromCharCode(o1, o2, o3);
    // check for padding
    if (h4 == 0x40) d[c/4] = String.fromCharCode(o1, o2);
    if (h3 == 0x40) d[c/4] = String.fromCharCode(o1);
  }
  plain = d.join('');  // join() is far faster than repeated string concatenation

  plain = utf8decode ? plain.decodeUTF8() : plain
//  plain = plain.substr(0,plain.length-4)
  var debug = plain.toByteArray();
  return plain;
}

/**
 * Encode multi-byte Unicode string into utf-8 multiple single-byte characters
 * (BMP / basic multilingual plane only)
 *
 * Chars in range U+0080 - U+07FF are encoded in 2 chars, U+0800 - U+FFFF in 3 chars
 *
 * @return encoded string
 */
String.prototype.encodeUTF8 = function() {
  // use regular expressions & String.replace callback function for better efficiency
  // than procedural approaches
  var str = this.replace(
      /[\u0080-\u07ff]/g,  // U+0080 - U+07FF => 2 bytes 110yyyyy, 10zzzzzz
      function(c) {
        var cc = c.charCodeAt(0);
        return String.fromCharCode(0xc0 | cc>>6, 0x80 | cc&0x3f); }
    );
  str = str.replace(
      /[\u0800-\uffff]/g,  // U+0800 - U+FFFF => 3 bytes 1110xxxx, 10yyyyyy, 10zzzzzz
      function(c) {
        var cc = c.charCodeAt(0);
        return String.fromCharCode(0xe0 | cc>>12, 0x80 | cc>>6&0x3F, 0x80 | cc&0x3f); }
    );
  return str;
}

/**
 * Decode utf-8 encoded string back into multi-byte Unicode characters
 *
 * @return decoded string
 */
String.prototype.decodeUTF8 = function() {
  var str = this.replace(
      /[\u00c0-\u00df][\u0080-\u00bf]/g,                 // 2-byte chars
      function(c) {  // (note parentheses for precence)
        var cc = (c.charCodeAt(0)&0x1f)<<6 | c.charCodeAt(1)&0x3f;
        return String.fromCharCode(cc); }
    );
  str = str.replace(
      /[\u00e0-\u00ef][\u0080-\u00bf][\u0080-\u00bf]/g,  // 3-byte chars
      function(c) {  // (note parentheses for precence)
        var cc = ((c.charCodeAt(0)&0x0f)<<12) | ((c.charCodeAt(1)&0x3f)<<6) | ( c.charCodeAt(2)&0x3f);
        return String.fromCharCode(cc); }
    );
  return str;
}

/**
 * Converts a string into a hexadecimal string
 * returns the characters of a string to their hexadecimal charcode equivalent
 * Works only on byte chars with charcode < 256. All others chars are converted
 * into "xx"
 *
 * @return hex string e.g. "hello world" => "68656c6c6f20776f726c64"
 */
String.prototype.convertToHex = function() {
  var hs ='';
  var hv ='';
  for (var i=0; i<this.length; i++) {
    hv = this.charCodeAt(i).toString(16);
    hs += (hv.length == 1) ? '0'+hv : hv;
  }
  return hs;
}

/**
 * Converts a hex string into a string
 * returns the characters of a hex string to their char of charcode
 *
 * @return hex string e.g. "68656c6c6f20776f726c64" => "hello world"
 */
String.prototype.convertFromHex = function(){
  var s = "";
  for(var i= 0;i<this.length;i+=2){
    s += String.fromCharCode(parseInt(this.substring(i,i+2),16));
  }
  return s
}

/**
 * strips off all linefeeds from a string
 * returns the the strong without line feeds
 *
 * @return string
 */
String.prototype.stripLineFeeds = function(){
//  var re = RegExp(String.fromCharCode(13),'g');//\r
//  var re = RegExp(String.fromCharCode(10),'g');//\n
  var s = '';
  s = this.replace(/\n/g,'');
  s = s.replace(/\r/g,'');
  return s;
}

/**
 * Converts a string into an array of char code bytes
 * returns the characters of a hex string to their char of charcode
 *
 * @return hex string e.g. "68656c6c6f20776f726c64" => "hello world"
 */
 String.prototype.toByteArray = function(){
  var ba = [];
  for(var i=0;i<this.length;i++)
     ba[i] = this.charCodeAt(i);

  return ba;
}


/**
 * Fragmentize a string into lines adding a line feed (lf) every length
 * characters
 *
 * @return string e.g. length=3 "abcdefghi" => "abc\ndef\nghi\n"
 */
String.prototype.fragment = function(length,lf){
  if(!length || length>=this.length) return this;
  if(!lf) lf = '\n'
  var tmp='';
  for(var i=0;i<this.length;i+=length)
    tmp += this.substr(i,length) + lf;
  return tmp;
}

/**
 * Formats a hex string in two lower case chars + : and lines of given length
 * characters
 *
 * @return string e.g. "68656C6C6F20" => "68:65:6c:6c:6f:20:\n"
*/
String.prototype.formatHex = function(length){
    if(!length) length = 45;
    var str='';
    var j = 0;
    var hex = this.toLowerCase();
    for(var i=0;i<hex.length;i+=2)
      str += hex.substr(i,2) +':';
    hex = str.fragment(length);

  return hex;
}


/*----------------------------------------------------------------------------*/
/* End of intance methods of the String object                                */
/*----------------------------------------------------------------------------*/

function byteArray2String(b){
//  var out ='';
  var s = '';
  for(var i=0;i<b.length;i++){
     s += String.fromCharCode(b[i]);
//     out += b[i]+':';
  }
//  alert(out);
  return s;
}
