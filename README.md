# Simple-RSA-Encryption-Script-in-Bash
Pimple implementation of RSA encryption and decryption in a Bash script. Since Bash is not designed for complex mathematical operations, 
this script uses external tools like bc (a command-line calculator) to handle modular arithmetic and large numbers.


### RSA Encryption Script in Bash
--- 
#### **The Script**

#### **Explanation of the Script**

##### **1. Key Generation**
- The script generates two prime numbers `p` and `q` (hardcoded as 61 and 53 for simplicity).
- It calculates:
  - `n = p * q` (used in both public and private keys).
  - `phi = (p - 1) * (q - 1)` (Euler's totient function).
- It selects `e` (public exponent) such that `1 < e < phi` and `gcd(e, phi) = 1`.
- It calculates `d` (private exponent) as the modular inverse of `e` modulo `phi`.

##### **2. Encryption**
- Each character in the plaintext message is converted to its ASCII value using `printf "%d"`.
- The ASCII value is raised to the power of `e` and reduced modulo `n` using `bc`.
- The resulting numbers form the encrypted message.

##### **3. Decryption**
- Each number in the encrypted message is raised to the power of `d` and reduced modulo `n` using `bc`.
- The resulting numbers are converted back to characters using `printf`.

##### **4. User Interaction**
- The script provides a menu with three options:
  1. Generate RSA keys.
  2. Encrypt a message.
  3. Decrypt a message.

---

#### **Example Execution**

1. **Generate Keys**:
   ```
   Public Key: (7, 3233)
   Private Key: (2753, 3233)
   ```

2. **Encrypt a Message**:
   Input: `"HELLO"`
   Output: `Encrypted Message: 2081 2182 2172 2172 2118`

3. **Decrypt a Message**:
   Input: `2081 2182 2172 2172 2118`
   Output: `Decrypted Message: HELLO`

---

#### **Notes**
- **Limitations**:
  - This script is for educational purposes and uses small prime numbers for simplicity.
  - It does not include padding schemes (e.g., OAEP), which are essential for secure RSA encryption.
- **Dependencies**:
  - The script requires `bc` for handling modular arithmetic with large numbers.
- **Security**:
  - In real-world applications, much larger prime numbers are used to ensure security.


