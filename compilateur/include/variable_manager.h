#ifndef DCC_VARIABLE_MANAGER_H_
#define DCC_VARIABLE_MANAGER_H_

typedef unsigned char address;

/**
 * Créer une nouvelle variable, sans vérifier si elle existe déjà.
 * @param name le nom de la variable
 */
void var_create_force(char *name);

/**
 * Permet d'obtenir l'adresse d'une variable, sans levé d'erreur si elle n'existe pas.
 * @param name le nom de la variable
 * @return l'adresse de la variable ou -1 si elle n'existe pas
 */
short var_get_force(char *name);

/**
 * Créer une nouvelle variable, si elle n'existe pas déjà.
 * Leve une erreur si la variable existe déjà.
 * @param name le nom de la variable
 * @return l'adresse de la variable
 */
address var_create(char *name);

/**
 * Permet d'obtenir l'adresse d'une variable, en levant une erreur si elle n'existe pas.
 * @param name le nom de la variable
 * @return l'adresse de la variable
 */
address var_get(char *name);

/**
 * Ajoute une nouvelle variable sur la pile temporaire.
 * @return l'adresse de la variable
 */
address temp_push();

/**
 * Retire la dernière variable de la pile temporaire.
 * @return l'adresse de la variable
 */
address temp_pop();

/**
 * Ajoute un niveau de visibilité.
 * Les variables créées après cette fonction auront le nouveau niveau de visibilité.
 * @see remove_visibility
 */
void add_visibility();

/**
 * Retire un niveau de visibilité.
 * Les variables créées après cette fonction auront le niveau de visibilité précédent.
 * Les variables créées avant cette fonction seront supprimées si leur niveau de visibilité est supérieur,
 * elle ne peuvent plus etre utilisée ou doivent être recréées, et ce même si la visibilité est rétablie.
 * @see add_visibility
 */
void remove_visibility();

#endif