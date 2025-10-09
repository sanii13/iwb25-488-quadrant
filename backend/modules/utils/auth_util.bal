import ballerina/crypto;
import ballerina/random;

// Utility functions for authentication and security

// Generate a secure password hash using SHA256 with salt
public function hashPassword(string password) returns string|error {
    // Generate a salt
    string salt = check generateSalt();
    
    // Combine password with salt and hash
    string saltedPassword = password + salt;
    byte[]|crypto:Error hashedBytes = crypto:hashSha256(saltedPassword.toBytes());
    if hashedBytes is crypto:Error {
        return hashedBytes;
    }
    string hash = hashedBytes.toBase64();
    
    // Return salt + hash for verification later
    return salt + ":" + hash;
}

// Verify password against stored hash
public function verifyPassword(string password, string storedHash) returns boolean|error {
    // Split stored hash to get salt and hash
    string[] parts = [];
    string delimiter = ":";
    string temp = storedHash;
    int? indexResult = temp.indexOf(delimiter);
    if indexResult is () {
        return false;
    }
    int index = indexResult;
    parts.push(temp.substring(0, index));
    parts.push(temp.substring(index + 1));
    
    if parts.length() != 2 {
        return false;
    }
    
    string salt = parts[0];
    string originalHash = parts[1];
    
    // Hash the provided password with the same salt
    string saltedPassword = password + salt;
    byte[]|crypto:Error hashedBytes = crypto:hashSha256(saltedPassword.toBytes());
    if hashedBytes is crypto:Error {
        return hashedBytes;
    }
    string newHash = hashedBytes.toBase64();
    
    // Compare hashes
    return newHash == originalHash;
}

// Generate a random salt
function generateSalt() returns string|error {
    byte[] randomBytes = [];
    int i = 0;
    while i < 16 {
        int randomInt = check random:createIntInRange(0, 255);
        randomBytes.push(<byte>randomInt);
        i = i + 1;
    }
    return randomBytes.toBase64();
}
