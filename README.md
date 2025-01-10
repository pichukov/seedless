<div align="left">
  <img height="120" src="https://raw.githubusercontent.com/pichukov/PublicAssets/master/Seedless/seedless_banner.png">
</div>

# Seedless application 🚀

<div align="left">
  <img height="400" src="https://raw.githubusercontent.com/pichukov/PublicAssets/master/Seedless/seedless_screens.png">
</div>

This repository provides:

- An **iOS application** implementing the algorithm, enabling users to encode and decode seed phrases directly on their mobile devices. The application is built without relying on external libraries, ensuring simplicity and making it easy to audit for vulnerabilities.

- A **Python script** for encoding and decoding seed phrases

---

# Why do you need to Encode Seed Phrases? 🤔

Seed phrases (mnemonic phrases) are vital in cryptographic systems, such as cryptocurrency wallets, because they act as a **master key** to access and recover funds. Storing these phrases securely is critical, and this algorithm provides a way to enhance security and obfuscate.

### **Obfuscation**

- Raw seed phrases are plaintext and highly readable to anyone with access, making them vulnerable if exposed.
- A Base64 string, while not encrypted, provides a layer of **obfuscation** that can deter casual observers from immediately recognizing it as a seed phrase.

---

# 🌟 Algorithm Explanation: Encoding and Decoding Seed Words 🌟

This application is designed to encode a list of seed words (**BIP39 mnemonic format**) into a compact Base64-encoded string and decode it back to the original words. It supports **12-word** and **24-word seed phrases**. 🚀

---

## **1. Base64 Character Set 🧩**

The Base64 encoding system uses the following 64-character set:

```
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/
```

Each character represents a 6-bit binary value, making Base64 an efficient way to encode binary data as text. 💡

---

## **2. Encoding Seed Words 🔐**

### **Steps:**

1. **Map Words to Indices:**

   - Each seed word is located in a predefined word list (e.g., **BIP39 word list**).
   - Example:
     - Word list: `["apple", "banana", "cherry"]`
     - Seed words: `["banana", "apple"]`
     - Indices: `[1, 0]`

2. **Convert Indices to Binary:**

   - Convert each index into an 11-bit binary string. The **BIP39 format** uses 11-bit chunks because it supports up to \( 2^{11} = 2048 \) words.
   - Example:
     - Indices: `[1, 0]`
     - Binary: `["00000000001", "00000000000"]`

3. **Concatenate Binary Strings:**

   - Combine the binary strings into one continuous binary string.
   - Example:
     - Binary: `["00000000001", "00000000000"]`
     - Concatenated: `"0000000000100000000000"`

4. **Split into 6-Bit Chunks:**

   - Break the binary string into chunks of 6 bits (as Base64 represents 6 bits per character).
   - Example:
     - Concatenated: `"0000000000100000000000"`
     - Chunks: `["000000", "000010", "000000", "000000"]`

5. **Map Chunks to Base64 Characters:**
   - Convert each 6-bit chunk into a decimal value and map it to the corresponding Base64 character.
   - Example:
     - Chunks: `["000000", "000010", "000000", "000000"]`
     - Decimal: `[0, 2, 0, 0]`
     - Base64: `["A", "C", "A", "A"]`
   - Final encoded string: `"ACAA"`

---

## **3. Decoding Base64 String 🔓**

### **Steps:**

1. **Map Base64 Characters to Binary:**

   - Each Base64 character is converted to its corresponding 6-bit binary representation.
   - Example:
     - Base64 string: `"ACAA"`
     - Characters: `["A", "C", "A", "A"]`
     - Binary: `["000000", "000010", "000000", "000000"]`

2. **Concatenate Binary Strings:**

   - Combine the binary strings into one continuous binary string.
   - Example:
     - Binary: `["000000", "000010", "000000", "000000"]`
     - Concatenated: `"0000000000100000000000"`

3. **Split into 11-Bit Chunks:**

   - Divide the binary string into 11-bit chunks, as each chunk corresponds to one seed word.
   - Example:
     - Concatenated: `"0000000000100000000000"`
     - Chunks: `["00000000001", "00000000000"]`

4. **Convert Binary to Indices:**

   - Convert each 11-bit binary chunk into a decimal index.
   - Example:
     - Chunks: `["00000000001", "00000000000"]`
     - Indices: `[1, 0]`

5. **Map Indices to Words:**
   - Map the indices back to the corresponding seed words in the word list.
   - Example:
     - Indices: `[1, 0]`
     - Word list: `["apple", "banana", "cherry"]`
     - Seed words: `["banana", "apple"]`

---

## **4. Supports 12 and 24 Word Phrases ✅**

The application is designed to handle **12-word** and **24-word seed phrases**, commonly used in BIP39. Each seed phrase is encoded as a continuous binary string and processed efficiently to ensure compatibility with mnemonic phrase standards.

### Example:

- **12-word seed phrase** generates \( 12 \times 11 = 132 \) bits, split into 6-bit chunks for Base64 encoding.
- **24-word seed phrase** generates \( 24 \times 11 = 264 \) bits, handled similarly.
