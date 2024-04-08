#ifndef DCC_INSTRUCTION_SET_H_
#define DCC_INSTRUCTION_SET_H_

#include "app.h"

/**
 * Affichage la valeur d'une variable.
 * `print(i)`
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void display(label i);

/**
 * Affectation d'une valeur numérique à une variable.
 * `o = c`
 * @param o le nom de la variable d'entrée ou NULL pour créer un temporaire
 * @param c une constante numérique
 */
void number_copy(label o, address c);

/**
 * Affectation d'une valeur numérique à une variable, tout en ajoutant cette variable au symbole définie.
 * `int o = c`
 * @param o le nom de la variable d'entrée qui sera définie, ne peut pas être NULL
 * @param c une constante numérique
 */
void number_define(label o, address c);

/**
 * Copie de la valeur d'une variable dans une autre.
 * `o = i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void var_copy(label o, label i);

/**
 * Copie de la valeur d'une variable dans une autre, tout en ajoutant cette variable au symbole définie.
 * `int o = i`
 * @param o le nom de la variable de sortie qui sera définie, ne peut pas être NULL
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void var_define(label o, label i);

/**
 * Négation d'une variable et le stock dans une autre.
 * `o = -i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void negate(label o, label i);

/**
 * Ajout de deux variables et le stock dans une autre.
 * `o = i1 + i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void add(label o, label i1, label i2);

/**
 * Soustraction de deux variables et le stock dans une autre.
 * `o = i1 - i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void subtract(label o, label i1, label i2);

/**
 * Multiplication de deux variables et le stock dans une autre.
 * `o = i1 * i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void multiply(label o, label i1, label i2);


/**
 * Division de deux variables et le stock dans une autre.
 * `o = i1 / i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void divide(label o, label i1, label i2);

/**
 * Modulo de deux variables et le stock dans une autre.
 * `o = i1 % i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void modulo(label o, label i1, label i2);

/**
 * Opération logique ET de deux variables et le stock dans une autre.
 * `o = i1 & i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void logical_and(label o, label i1, label i2);

/**
 * Opération logique OU de deux variables et le stock dans une autre.
 * `o = i1 | i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void logical_or(label o, label i1, label i2);

/**
 * Opération logique XOR de deux variables et le stock dans une autre.
 * `o = i1 ^ i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void logical_xor(label o, label i1, label i2);

/**
 * Opération logique NON d'une variables et le stock dans une autre.
 * `o = !i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void logical_not(label o, label i);

/**
 * Comparaison de supériorité stricte de deux variables et le stock dans une autre.
 * `o = i1 > i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void greater_than(label o, label i1, label i2);

/**
 * Comparaison d'infériorité stricte de deux variables et le stock dans une autre.
 * `o = i1 < i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void lower_than(label o, label i1, label i2);

/**
 * Comparaison d'égalité de deux variables et le stock dans une autre.
 * `o = i1 == i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void equal_to(label o, label i1, label i2);

/**
 * Permet de sauter à une adresse d'exécution spécifique.
 * `jump(c)`
 * @param c l'adresse de saut
 */
void jump(address c);

/**
 * Permet de sauter à une adresse d'exécution spécifique si une condition est vérifiée.
 * `if (i) jump(c)`
 * @param i le nom de la variable de condition ou NULL pour obtenir un temporaire
 * @param c l'adresse de saut
 */
void branch(label i, address c);

/**
 * Permet d'ajouter un vide qui pourra être compléter plus tard pendant l'analyse.
 * @see jump_before
 * @see branch_before
 */
address padding_for_later();

/**
 * Permet de sauter à une adresse d'exécution spécifique.
 * Cette fonction permet d'écrire cette instruction dans une adresse passée.
 * `jump(c)`
 * @param line l'adresse à écrire
 * @param c l'adresse de saut
 * @see padding_for_later
 */
void jump_before(address line, address c);

/**
 * Permet de sauter à une adresse d'exécution spécifique si une condition est vérifiée.
 * Cette fonction permet d'écrire cette instruction dans une adresse passée.
 * `if (i) jump(c)`
 * @param line l'adresse à écrire
 * @param i le nom de la variable de condition ou NULL pour obtenir un temporaire
 * @param c l'adresse de saut
 * @see padding_for_later
 */
void branch_before(address line, label i, address c);


/**
 * Permet d'ajouté cheque token dans un buffer pour pour afficher le code source en commentaire.
 * @param token le texte à ajouter
 * @param length la longueur du commentaire
 * @param line le numéro de ligne de l'instruction
 */
void append_hint_buffer(char *token, int length, int line);

#endif
