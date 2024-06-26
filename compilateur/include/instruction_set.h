#ifndef DCC_INSTRUCTION_SET_H_
#define DCC_INSTRUCTION_SET_H_

#include "app.h"

/**
 * Affichage la valeur d'une variable.
 * `print(cnl) << i`
 * @param chn le canal d'affichage
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void display(address cnl, label i);

/**
 * Lecture d'une valeur numérique.
 * `read(cnl) > 0`
 * @param cnl le canal de lecture
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 */
void get_input(address cnl, label o);

/**
 * Affectation d'une valeur numérique à une variable.
 * `o = c`
 * @param o le nom de la variable d'entrée ou NULL pour créer un temporaire
 * @param c une constante numérique
 */
void number_copy(label o, number c);

/**
 * Affectation d'une valeur numérique à une variable, tout en ajoutant cette variable au symbole définie.
 * `int o = c`
 * @param o le nom de la variable d'entrée qui sera définie, ne peut pas être NULL
 * @param c une constante numérique
 */
void number_define(label o, number c);

/**
 * Affectation d'une valeur numérique à une variable, tout en ajoutant cette variable au symbole définie.
 * `int o = c`
 * @param o le nom de la variable d'entrée qui sera définie, ne peut pas être NULL
 * @param c une constante numérique
 * @param addr la ligne d'ajout au code
 */
void number_copy_after(label o, number c, address addr);

/**
 * Affectation d'une valeur numérique à une variable, tout en ajoutant cette variable au symbole définie.
 * `int o[c]`
 * @param o le nom de la variable d'entrée qui sera définie, ne peut pas être NULL
 * @param c une constante numérique
 */
void tab_define(label o, address length);

/**
 * Copie de la valeur d'une variable dans une autre.
 * `o = i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void var_copy(label o, label i);

/**
 * Copie de l'adresse d'une variable dans un emplacement mémoire.
 * `*o = i`
 * @param o l'adresse de la variable de sortie
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void var_copy_address_local(address o, label i);

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
 * Opération bit à bit ET de deux variables et le stock dans une autre.
 * `o = i1 & i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void bitwise_and(label o, label i1, label i2);

/**
 * Opération bit à bit OU de deux variables et le stock dans une autre.
 * `o = i1 | i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void bitwise_or(label o, label i1, label i2);

/**
 * Opération bit à bit XOR de deux variables et le stock dans une autre.
 * `o = i1 ^ i2`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i1 le nom de la première variable d'entrée ou NULL pour obtenir un temporaire
 * @param i2 le nom de la deuxième variable d'entrée ou NULL pour obtenir un temporaire
 */
void bitwise_xor(label o, label i1, label i2);

/**
 * Opération bit à bit NON d'une variable et le stock dans une autre.
 * `o = ~i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void bitwise_not(label o, label i);

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
 * Permet de sauter à une adresse d'exécution spécifique.
 * `jump(c)`
 * @param c l'adresse de saut en mémoire
 */
void jump_mem(label c);

/**
 * Permet de sauter à une adresse d'exécution spécifique si une condition est vérifiée.
 * `if (i) jump(c)`
 * @param i le nom de la variable de condition ou NULL pour obtenir un temporaire
 * @param c l'adresse de saut
 */
void branch(label i, address c);

/**
 * Permet de sauter à une adresse d'exécution spécifique si une condition est vérifiée.
 * `if (i) jump(c)`
 * @param i le nom de la variable de condition ou NULL pour obtenir un temporaire
 * @param c l'adresse de saut en mémoire
 */
void branch_mem(label i, label c);

/**
 * Permet d'ajouter un vide qui pourra être compléter plus tard pendant l'analyse.
 * @see jump_before
 */
address padding_for_later_jump();

/**
 * Permet d'ajouter un vide qui pourra être compléter plus tard pendant l'analyse.
 * Et prépare le registre pour la condition.
 * @param i
 * @see branch_before
 */
address padding_for_later_branch(label i);

/**
 * Permet de sauter à une adresse d'exécution spécifique.
 * Cette fonction permet d'écrire cette instruction dans une adresse passée.
 * `jump(a)`
 * @param l l'adresse à écrire
 * @param a l'adresse de saut
 * @see padding_for_later_jump
 */
void jump_before(address l, address a);

/**
 * Permet de sauter à une adresse d'exécution spécifique si une condition est vérifiée.
 * Cette fonction permet d'écrire cette instruction dans une adresse passée.
 * `if (i) jump(a-o)`
 * @param l l'adresse à écrire
 * @param a l'adresse de saut
 * @param o un décalage
 * @see padding_for_later_branch
 */
void branch_before(address l, address a, address o);

/**
 * Permet de charger la valeur d'une adresse dans une variable avec un décalage.
 * `o = *(i + c)`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 * @param c le nom de la variable de décalage ou NULL pour obtenir un temporaire
 */
void load_offset(label o, label i, label c);

/**
 * Permet de charger la valeur d'une adresse dans une variable sans décalage.
 * `o = *i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void load(label o, label i);

/**
 * Permet de stocker une variable dans une adresse avec un décalage.
 * `*(o + c) = i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 * @param c le nom de la variable de décalage ou NULL pour obtenir un temporaire
 */
void store_offset(label o, label i, label c);

/**
 * Permet de stocker une variable dans une adresse sans décalage.
 * `*o = i`
 * @param o le nom de la variable de sortie ou NULL pour créer un temporaire
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void store(label o, label i);

/**
 * Permet de return une variable et de flush la mémoire.
 *
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void return_label(label i);

/**
 * Permet d'ajouté cheque token dans un buffer pour pour afficher le code source en commentaire.
 * @param token le texte à ajouter
 * @param length la longueur du commentaire
 * @param line le numéro de ligne de l'instruction
 */
void append_hint_buffer(char *token, int length, int line);

void switch_tmp();

/**
 * Permet d'obtenir l'adresse d'une variable.
 * @param r le registre de destination
 * @param i le nom de la variable d'entrée ou NULL pour obtenir un temporaire
 */
void var_to_address(label o, label i);

/**
 * Permet de réserver un bloc de mémoire.
 * @param c la taille du bloc
 */
void alloc_stack(address c);

/**
 * Permet de libérer un bloc de mémoire.
 * @param c la taille du bloc
 */
void free_stack(address c);

/**
 * Permet de réserver un bloc de mémoire plus tot.
 * @param line la ligne d'ajout au code
 * @param c la taille du bloc
 */
void alloc_stack_before(address line, address c);

#endif
