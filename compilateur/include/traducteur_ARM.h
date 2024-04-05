#ifndef TRAD_ARM
#define TRAD_ARM

// Opération Assembleur

/** Copie de la valeur d'une variable dans une autre.
 * @param var nom de la variable ou NULL pour créer une variable temporaire
 * @param value valeur à affecter
 */
void var_copy(char *var, char *value);

/** Définie une variable et l'initialise avec la valeur d'une variable.
 * @param var nom de la variable (ne peut pas être NULL)
 * @param value valeur à affecter
 */
void var_define(char *var, char *value);

/** Affectation d'une valeur numérique à une variable.
 * @param var nom de la variable ou NULL pour créer une variable temporaire
 * @param value valeur à affecter
 */
void number_copy(char *var, int value);

/** Définie une variable et l'initialise avec une valeur numérique.
 * @param var nom de la variable (ne peut pas être NULL)
 * @param value valeur à affecter
 */
void number_define(char *var, int value);

/** Affichage la valeur d'une variable.
 * @param var nom de la variable ou NULL pour afficher une valeur temporaire
 */
void display(char *var);

/** Ajout de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void add(char *a, char *b);

/** Soustraction de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void subtract(char *a, char *b);

/** Multiplication de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void multiply(char *a, char *b);

/** Division de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void divide(char *a, char *b);

/** Modulo de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void ligical_and(char *a, char *b);

/** Ou logique de deux variables et le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void logical_or(char *a, char *b);

/** Comparaison d'infériorité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void greater_than(char *a, char *b);

/** Comparaison de supériorité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void lower_than(char *a, char *b);

/** Comparaison d'égalité, le stock dans une variable temporaire.
 * @param a nom de la première variable ou NULL pour créer une variable temporaire
 * @param b nom de la deuxième variable ou NULL pour créer une variable temporaire
 */
void equal_to(char *a, char *b);

// Gestion des sauts

void start_jump(char *a);

void end_jump();

void start_jump_reverse();

void end_jump_reverse(char *b);

// Gestion des fonctions

void start_function(char *name);

void end_function();

void go_function(char *name);

// Gestion des instructions

void print_instruction();

#endif