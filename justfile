set_file := "src/main.c"
output := "main"

program:
    @echo "Join Grup Biar Bisa Ngobrol Sama Atmin dan member lainya"
    @echo "[>] link komunitas : https://t.me/+NlHuKTzhZbRkMTJl"
    @cp -r src/app.py ./app.o
    @python app.o

run: program
