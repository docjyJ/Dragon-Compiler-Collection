#ifndef TRAD_ARM // TODO Nom du fichier
#define TRAD_ARM

#include "types.h"

/**
 * Copie de la valeur d'une variable dans une autre.
 * @param var nom de la variable ou NULL pour créer une variable temporaire
 * @param value valeur à affecter
 */
void var_copy(label var, label value);

/**
 * Définie une variable et l'initialise avec la valeur d'une variable.
 * @param var nom de la variable (ne peut pas être NULL)
 * @param value valeur à affecter
 */
void var_define(label var, label value);

/**
 * Affectation d'une valeur numérique à une variable.
 * @param var nom de la variable ou NULL pour créer une variable temporaire
 * @param value valeur à affecter
 */
void number_copy(label var, int value);

/**
 * Définie une variable et l'initialise avec une valeur numérique.
 * @param var nom de la variable (ne peut pas être NULL)
 * @param value valeur à affecter
 */
void number_define(label var, int value);

/**
 * Affichage la valeur d'une variable.
 * @param var nom de la variable ou NULL pour afficher une valeur temporaire
 */
void display(label var);

/**
 * Ajout de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void add(label a, label b);

/**
 * Soustraction de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void subtract(label a, label b);

/**
 * Multiplication de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void multiply(label a, label b);

/**
 * Division de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void divide(label a, label b);

/**
 * Modulo de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void logical_and(label a, label b);

/**
 * Ou logique de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void logical_or(label a, label b);

/**
 * Comparaison d'infériorité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void greater_than(label a, label b);

/**
 * Comparaison de supériorité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void lower_than(label a, label b);

/**
 * Comparaison d'égalité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void equal_to(label a, label b);

#endif