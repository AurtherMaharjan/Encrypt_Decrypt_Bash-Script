#!/bin/bash

figlet encrypt to decrypt
tool(){
echo "Enter 'e' if you want to encrypt, 'd' to decryption and 'q' to quit"
read input

if [[ $input == "q" ]]; then 
        echo -n "Quitting the program ."
        sleep 1
        echo -n "."
        sleep 1
        echo "."
        echo "Thank you!!"
        sleep 1
        exit

elif [[ $input == "e" ]]; then
        function exist_create(){
        echo "Enter 'f' if the file exists and 'c' if you want to create a file."
        read file_exist_create
        if [[ $file_exist_create == 'c' ]]; then
                echo -n "Name the file: "
                read file
                echo "Input the content of the file."
                read file_content
                echo "$file_content" > $file
        elif [[ $file_exist_create == 'f' ]]; then
                echo -n "Enter the existing file name: "
                read file
                if [ -f "$file" ]; then
                        echo "The content in your file: "
                        cat $file
                else
                        echo "Can't find '$file'. "
                        exist_create
                fi

        else
                echo "Incorrect input.!!"
                sleep 1
                exist_create
        fi
        }
        exist_create
        echo -n "Name the file where you want to store the encrypted content: "
        read encrypted
        sleep 1
        encrypting(){
                echo -n "Do you want to use asymmetric key encryption or symmetric key encryption [a/s]: "
                read encr
                if [[ $encr == 'a' ]]; then
                        echo "Encrypting the file"
                        openssl genrsa -out privatekey 1024 >& /dev/null
                        openssl rsa -in privatekey -out publickey -pubout >& /dev/null
                        openssl pkeyutl -encrypt -in $file -inkey publickey -pubin -out $encrypted
                        echo "Encryption process completed successfully."
                        sleep 1
                        echo "Back to the home..."
                        sleep 1
                        tool

                elif [[ $encr == 's' ]]; then
                        echo -n "Enter a desired password: "
                        stty -echo
                        read password
                        stty echo
                        echo ""
                        echo  "What algorithm do you want to encrypt the file with?"
                        echo "aes-256-cbc" > enc_algorithm.txt
                        echo "aes-192-ecb" >> enc_algorithm.txt
                        echo "des-cbc" >> enc_algorithm.txt
                        echo "bf-cbc" >> enc_algorithm.txt
                        echo "seed" >> enc_algorithm.txt
                        cat -n enc_algorithm.txt
                        read in_algorithm
                        nu=$(sed -n $in_algorithm"p" enc_algorithm.txt)
                        openssl enc -$nu -in $file -out $encrypted -k $password >& /dev/null
                        echo "Encryption successfull."
                        sleep 1
                        echo "Back to the home.."
                        sleep 1
                        tool
                else
                        echo "Wrong input format!!"
                        sleep 1
                        encrypting

                fi
        }
        encrypting
elif [[ $input == 'd' ]]; then
        function decrypting(){
                echo "Which file do you want to decrypt? "
                read file_to_decr
                if [ -f "$file_to_decr" ];then
                        sleep 1
                else
                        echo "File not found .."
                        echo "Make sure you enter the correct file."
                        decrypting
                fi

                echo "In which file do you want the decrypted file to be stored? "
                read decr_file
                sleep 1
                echo -n "Enter 'a' if asymmetric key is used while encryption and 's' if symmetric key is used: "
                read encr_key
                if [[ $encr_key == 'a' ]]; then
                        openssl pkeyutl -decrypt -in $file_to_decr -out $decr_file -inkey privatekey 
                        sleep 1
                        echo "Reading the content of the decrypted data,"
                        sleep 1
                        cat $decr_file
                        function to_rerun(){
                        echo -n "Do you want to re-run the program? [y/q]: "
                        read rerun
                        if [[ $rerun == "y" ]]; then
                                tool
                        elif [[ $rerun == "q" ]]; then
                                figlet Thank You
                                exit
                        else
                                echo -n "Didn't quite get you.. "
                                to_return
                        fi
                }

                elif [[ $encr_key == 's' ]]; then
                        echo -n "Enter the password: "
                        stty -echo
                        read password
                        stty echo
                        echo "" 
                        echo "Which algorithm was used during encryption? "
                        cat -n enc_algrthm.txt
                        read in_algrthm
                        nu=$(sed -n $in_algrthm"p" enc_algrthm.txt)
                        openssl $nu -d -in $file_to_decr -out $decr_file -k $password >& /dev/null
                        sleep 1

                        echo "Reading the content of the decrypted file."
                        cat $decr_file
                        function to_rerun(){
                        echo -n "Do you want to re-run the program? [y/q]: "
                        read rerun
                        if [[ $rerun == "y" ]]; then
                                tool
                        elif [[ $rerun == "q" ]]; then
                                figlet Thank You
                                exit
                        else
                                echo -n "Didn't quite get you.. "
                                to_return
                        fi
                }

                fi
        }
        decrypting
fi
}
tool
