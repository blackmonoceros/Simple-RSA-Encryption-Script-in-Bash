#!/bin/bash

# Function to calculate the greatest common divisor (GCD)
gcd() {
    local a=$1
    local b=$2
    while [ $b -ne 0 ]; do
        local temp=$b
        b=$((a % b))
        a=$temp
    done
    echo $a
}

# Function to calculate modular inverse using the Extended Euclidean Algorithm
mod_inverse() {
    local e=$1
    local phi=$2
    local a=$phi
    local b=$e
    local x0=0
    local x1=1

    while [ $b -ne 0 ]; do
        local q=$((a / b))
        local temp=$b
        b=$((a % b))
        a=$temp

        local temp=$x1
        x1=$((x0 - q * x1))
        x0=$temp
    done

    if [ $x0 -lt 0 ]; then
        x0=$((x0 + phi))
    fi

    echo $x0
}

# Function to generate RSA keys
generate_keys() {
    local p=61  # First prime number
    local q=53  # Second prime number
    local n=$((p * q))
    local phi=$(((p - 1) * (q - 1)))

    # Choose e such that 1 < e < phi and gcd(e, phi) = 1
    local e=3
    while [ $(gcd $e $phi) -ne 1 ]; do
        e=$((e + 2))
    done

    # Calculate d (modular inverse of e mod phi)
    local d=$(mod_inverse $e $phi)

    echo "Public Key: ($e, $n)"
    echo "Private Key: ($d, $n)"
    echo "$e $d $n" > keys.txt
}

# Function to encrypt a message
encrypt() {
    local e=$1
    local n=$2
    local message=$3
    local encrypted=""

    for ((i = 0; i < ${#message}; i++)); do
        local char=$(printf "%d" "'${message:$i:1}")
        local cipher=$(echo "$char^$e % $n" | bc)
        encrypted+="$cipher "
    done

    echo "Encrypted Message: $encrypted"
    echo $encrypted > encrypted.txt
}

# Function to decrypt a message
decrypt() {
    local d=$1
    local n=$2
    local encrypted_message=$3
    local decrypted=""

    for cipher in $encrypted_message; do
        local char=$(echo "$cipher^$d % $n" | bc)
        decrypted+=$(printf "\\$(printf "%03o" $char)")
    done

    echo "Decrypted Message: $decrypted"
}

# Main script logic
echo "RSA Encryption in Bash"
echo "1. Generate Keys"
echo "2. Encrypt a Message"
echo "3. Decrypt a Message"
read -p "Choose an option: " option

case $option in
    1)
        generate_keys
        ;;
    2)
        if [ ! -f keys.txt ]; then
            echo "Keys not found. Generate keys first."
            exit 1
        fi
        read -p "Enter the message to encrypt: " message
        read e n < <(awk '{print $1, $3}' keys.txt)
        encrypt $e $n "$message"
        ;;
    3)
        if [ ! -f keys.txt ] || [ ! -f encrypted.txt ]; then
            echo "Keys or encrypted message not found. Generate keys and encrypt a message first."
            exit 1
        fi
        read d n < <(awk '{print $2, $3}' keys.txt)
        encrypted_message=$(cat encrypted.txt)
        decrypt $d $n "$encrypted_message"
        ;;
    *)
        echo "Invalid option."
        ;;
esac