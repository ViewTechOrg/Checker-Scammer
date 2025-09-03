set_file := "src/main.c"
output := "main"

program:
    @echo "Join Grup Biar Bisa Ngobrol Sama Atmin dan member lainya"
    @echo "[>] link komunitas : https://t.me/+NlHuKTzhZbRkMTJl"
    @gcc -Wall -O2 -lcrypt -o {{output}} {{set_file}}
    @./{{output}}

run: program
