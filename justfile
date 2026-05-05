set_file := "src/main.c"
output := "main"

program:
    @echo "Join Grup Biar Bisa Ngobrol Sama Atmin dan member lainya"
    @echo "[>] link komunitas : https://t.me/+NlHuKTzhZbRkMTJl"
    @echo "[>] Saluran: https://whatsapp.com/channel/0029VbAuMhOJP20yKWguw61k"
    @cp -r src/app.py ./app.o
    @python app.o

run: program
