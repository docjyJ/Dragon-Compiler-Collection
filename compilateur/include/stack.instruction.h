#ifndef DCC_INSTRUCTION_STACK_H_
#define DCC_INSTRUCTION_STACK_H_

#include "types.h"

/**
 * Permet d'ajouter une instruction à la pile d'instructions.
 * @param line l'instruction à ajouter
 */
void add_instruction(inst line);

/**
 * Permet de récupérer le nombre d'instructions.
 * @return le nombre d'instructions
 */
address get_instruction_count();

/**
 * Permet de renseigner une instruction à un index donné.
 * Cette fonction est utilisée pour compléter une instruction vide.
 * @param line l'instruction à ajouter
 * @param index l'index de l'instruction
 * @see add_instruction_padding
 */
void set_instruction(inst line, address index);

/**
 * Permet d'afficher toutes les instructions non encore affichées.
 */
void print_instruction();

/**
 * Permet d'ajouter un commentaire dans le fichier assembleur.
 * C'est utilisé pour afficher le code source entre les instructions.
 * @param hint le commentaire à ajouter
 */
void add_hint(char *hint);

#endif
