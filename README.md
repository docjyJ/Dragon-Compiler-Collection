# Dragon Compiler Collection

## Démarage rapide

Pour tester la syntaxe d'un fichier C:

Déplacér le ficher `my-test.c` dans le dossier `test/` et lancer la commande `make my-test-test`.

Pour importé un programme C en VHDL:

TODO

## IO

Le projet sur une carte BASYS3 pocède 2 canaux d'enrée et 2 canaux de sortie.

Ils sont défini via la rangé de led et de switch de la carte.
Le bouton haut permet le reset de la carte.
Le bouton gauche permet d'afficher l'entrée en hexadécimal sur l'afficheur 7 segments (par défault la sortie est afficher).

_À la base on voulait mettre un troisème canal pour une comunications série / RS232 via les pins RX et TX de la carte.
Par manque de temps ça n'a pu aboutir._

## Outils et Commeandes pour la compilation

### Dragon Compiler Collection

Dragon Compiler Collection est l'outil de compilation du code C vers la cible DragonUnit FPGA.

_Enfin collection est un grand mot pour il n'y a qu'un seul compilateur. Il se sent un peut seul le pauvre..._

Usage : `dcc [-?] [-a] [-o FILE] [-s] [-?] [INPUT_FILE]`

| Argument             | Description                                                                                           |
| -------------------- | ----------------------------------------------------------------------------------------------------- |
| -? --help --usage    | Affiche l'aide.                                                                                       |
| -a --asm             | Sortie en assembleur au lieux d'un binaire.                                                           |
| -oFILE --output=FILE | Fichier de sortie, par défaut la sortie standard.                                                     |
| -s --hint-srcs       | Affiche les sources entre les instructions assembleur. Ne fonctionne pas pour la compilation binaire. |
| INPUT_FILE           | Fichier d'entrée, par défaut l'entrée standard.                                                       |

### QEMU Latias

QEMU Latias est la machine virtuelle à privilégier pour l'éxécution des fichier assembleur généré par DCC.

> [!WARNING]
> QUEMU Latias ne prend en charge que les fichier assembleur généré par DCC.
> Les fichier binaire ne sont pas supporté.

Usage : `qemu-latias [-h] [-i MAX_ITER] [-d] [-r CSV_RAM] file`

| Argument               | Description                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------ |
| -h --help              | Affiche l'aide.                                                                                              |
| -i INT --max-iter INT  | Nombre maximum d'itérations, un entier pour prévenir les boucle infinie, par défault 1024.                   |
| -d --debug             | Active le mode debug, affiche plus d'information dans la sortie standard.                                    |
| -r FILE --csv-ram FILE | Fichier CSV détallant l'éxécution tick par tick avec l'instruction en cours et l'état complet de la mémoire. |
| file                   | Fichier assembleur éxécuter.                                                                                 |

### Makefile

Voici les différentes cibles du Makefile pour le compilateur.

| Fichier       | Description                                 |
| ------------- | ------------------------------------------- |
| `src/%.tab.c` | Fichier généré par Bison.                   |
| `src/%.yy.c`  | Fichier généré par Flex.                    |
| `src/%.o`     | Fichier objet.                              |
| `dcc`         | Exécutable.                                 |
| `dcc.debug`   | Exécutable de débug.                        |
| `%.out`       | Fichier de test compiler par gcc (le vrai). |
| `%.s`         | Fichier de test assembleur.                 |

| Commande              | Description                                                           |
| --------------------- | --------------------------------------------------------------------- |
| clean full-clean      | Supprime les fichiers généré par le Makefile.                         |
| %-open-diag open-diag | Ouvre le diagnostic de gramaire.                                      |
| %-rapport rapport     | Génère un rapport de gramaire et le graph de l'automate               |
| %-test test           | Test le fichier %.out et %.s, ça permet de challenger DCC face à GCC. |
| %-emulate emulate     | Éxécute le fichier %.s avec QEMU Latias.                              |

> [!INFO]
> Les commandes peuvent être préfixé ou non du non du fichier (yacc pour les raport et test pour les émulations).
> Sans préfixe tout les fichier sont concerné.

### Rapido Build VHDL

Pour générer une constate programme le script rapido peut être utilisé.

Usage : cat input.c | ./rapido.sh > outputfile.vhd

## Jeux d'instruction

Légende :

- :red_circle: Registre de sortie
- :large_blue_diamond: Registre d'entrée
- :green_square: Donnée hardcode
- :no_entry_sign: Sans effet

| Nom                            | Id   | 31-24 | 23-16                 | 15-8                    | 7-0                     |
|--------------------------------|------|-------|-----------------------|-------------------------|-------------------------|
|                                | NOP  | `00`  | :no_entry_sign:       | :no_entry_sign:         | :no_entry_sign:         |
| Addition                       | ADD  | `01`  | :red_circle: A+B      | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Multiplication                 | MUL  | `02`  | :red_circle: A\*B     | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Soustraction                   | SUB  | `03`  | :red_circle: A-B      | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Division                       | DIV  | `04`  | :red_circle: A/B      | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Copie                          | COP  | `05`  | :red_circle: A        | :no_entry_sign:         | :large_blue_diamond: A  |
| Affectation                    | AFC  | `06`  | :red_circle: A        | :green_square: A        | :no_entry_sign:         |
| Saut                           | JMP  | `07`  | :no_entry_sign:       | :green_square: @        | :no_entry_sign:         |
| Branchement                    | JMF  | `08`  | :no_entry_sign:       | :green_square: @        | :large_blue_diamond: 0? |
| Inférieur                      | INF  | `09`  | :red_circle: A < B    | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Supérieur                      | SUP  | `0A`  | :red_circle: A &gt; B | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Eguale                         | EQU  | `0B`  | :red_circle: A == B   | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Écriture                       | PRI  | `0C`  | :no_entry_sign:       | :green_square: PORT     | :large_blue_diamond: IN |
|                                |      | `0D`  |                       |                         |                         |
|                                |      | `0E`  |                       |                         |                         |
|                                |      | `0F`  |                       |                         |                         |
| Chargement                     | LOD  | `10`  | :red_circle: << @     | :no_entry_sign:         | :large_blue_diamond: @  |
| Sauvegarde                     | STR  | `11`  | :no_entry_sign:       | :large_blue_diamond: IN | :large_blue_diamond: @  |
| Saut (version registre)        | JMPR | `12`  | :no_entry_sign:       | :no_entry_sign:         | :large_blue_diamond: @  |
| Branchement (version registre) | JMFR | `13`  | :no_entry_sign:       | :large_blue_diamond: 0? | :large_blue_diamond: @  |
| Lecture                        | RED  | `14`  | :red_circle: OUT      | :green_square: PORT     | :no_entry_sign:         |
|                                |      | `15`  |                       |                         |                         |
|                                |      | `16`  |                       |                         |                         |
|                                |      | `17`  |                       |                         |                         |
| Négation                       | NEG  | `18`  | :red_circle: -A       | :no_entry_sign:         | :large_blue_diamond: A  |
| Reste                          | MOD  | `19`  | :red_circle: A % B    | :large_blue_diamond: A  | :large_blue_diamond: B  |
|                                |      | `1A`  |                       |                         |                         |
|                                |      | `1B`  |                       |                         |                         |
|                                |      | `1C`  |                       |                         |                         |
|                                |      | `1D`  |                       |                         |                         |
|                                |      | `1E`  |                       |                         |                         |
|                                |      | `1F`  |                       |                         |                         |
| Et bit à bit                   | AND  | `20`  | :red_circle: A & B    | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Ou bit à bit                   | OR   | `21`  | :red_circle: A \| B   | :large_blue_diamond: A  | :large_blue_diamond: B  |
| Non bit à bit                  | NOT  | `22`  | :red_circle: ~A       | :no_entry_sign:         | :large_blue_diamond: A  |
| Ou exclusif bit à bit          | XOR  | `23`  | :red_circle: A ^ B    | :large_blue_diamond: A  | :large_blue_diamond: B  |
|                                |      | `24`  |                       |                         |                         |
|                                |      | `25`  |                       |                         |                         |
|                                |      | `26`  |                       |                         |                         |
|                                |      | `27`  |                       |                         |                         |
|                                |      | `28`  |                       |                         |                         |
|                                |      | `29`  |                       |                         |                         |
|                                |      | `2A`  |                       |                         |                         |
|                                |      | `2B`  |                       |                         |                         |
|                                |      | `2C`  |                       |                         |                         |
|                                |      | `2D`  |                       |                         |                         |
|                                |      | `2E`  |                       |                         |                         |
|                                |      | `2F`  |                       |                         |                         |
|                                |      | `30`  |                       |                         |                         |
|                                |      | `31`  |                       |                         |                         |
|                                |      | `36`  |                       |                         |                         |
|                                |      | `37`  |                       |                         |                         |
|                                |      | `38`  |                       |                         |                         |
|                                |      | `39`  |                       |                         |                         |
|                                |      | `3A`  |                       |                         |                         |
|                                |      | `3B`  |                       |                         |                         |
|                                |      | `3C`  |                       |                         |                         |
|                                |      | `3D`  |                       |                         |                         |
|                                |      | `3E`  |                       |                         |                         |
|                                |      | `3F`  |                       |                         |                         |
