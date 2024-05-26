# Ersten Pfad zum Lesen der Datei definieren
input_file_path = r"C:\Users\Jonatan\Desktop\VISHCI\Database\initdb\data\title.principals.tsv"

# Dateipfad zum Speichern der modifizierten Datei definieren
output_file_path = r"C:\Users\Jonatan\Desktop\VISHCI\Database\initdb\data\title.principals.tsv"

# Datei im Lesemodus öffnen und den Inhalt in einer Variablen speichern
with open(input_file_path, 'r', encoding='utf-8') as x:
    s = x.read().replace('"', ' ')

# Datei im Schreibmodus öffnen und den modifizierten Inhalt schreiben
with open(output_file_path, 'w', encoding='utf-8') as x:
    x.write(s)
