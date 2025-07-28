const CryptoJS = require('crypto-js');

const key = CryptoJS.enc.Utf8.parse('your-32-byte-secret-key-here-1234'); // Replace with a secure key

function encrypt(message) {
    return CryptoJS.AES.encrypt(message, key, {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    }).toString();
}

function decrypt(ciphertext) {
    const bytes = CryptoJS.AES.decrypt(ciphertext, key, {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });
    return bytes.toString(CryptoJS.enc.Utf8);
}

module.exports = { encrypt, decrypt };