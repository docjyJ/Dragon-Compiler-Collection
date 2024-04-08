#ifndef DCC_BRANCH_MANAGER_H_
#define DCC_BRANCH_MANAGER_H_

#include "app.h"

/**
 * Permet de démarrer une nouvelle branche avec un saut conditionnel.
 * @param cond l'adresse de la condition
 */
void start_if(label cond);

/**
 * Permet de démarrer un bloc qui sera sauté si la condition précédente à été vérifiée.
 */
void start_else();

/**
 * Permet de démarrer un bloc qui pourra reboucler au niveau de l'appel ultérieurement.
 */
void start_loop();

/**
 * Permet de terminer une branche, quelque soit son type.
 */
void end_branch();


#endif
