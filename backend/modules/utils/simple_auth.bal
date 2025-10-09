// Basic authentication utility with simple hash
import ballerina/crypto;

// Simple password hashing
public function simpleHashPassword(string password) returns string {
    byte[]|crypto:Error hashedBytes = crypto:hashSha256(password.toBytes());
    if hashedBytes is crypto:Error {
        return password; // Fallback for development only
    }
    return hashedBytes.toBase64();
}

// Simple password verification
public function simpleVerifyPassword(string password, string storedHash) returns boolean {
    string currentHash = simpleHashPassword(password);
    return currentHash == storedHash;
}
