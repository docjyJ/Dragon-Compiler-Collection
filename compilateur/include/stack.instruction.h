#ifndef DCC_INSTRUCTION_STACK_H_
#define DCC_INSTRUCTION_STACK_H_

#include "types.h"

/**
 * Permet d'ajouter une instruction à la pile d'instructions.
 * @param line l'instruction à ajouter
 */
void add_instruction(inst line);

/**
 * Permet d'ajouter un vide qui pourra être complèter plus tard pendant l'analyse.
 *@see set_instruction
 */
void add_instruction_padding();

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
 * Permet d'ajouter un commentaire à une instruction.
 * C'est utilisé pour afficher le code source entre les instructions.
 * @param hint le commentaire à ajouter
 * @param length la longueur du commentaire
 * @param line le numéro de ligne de l'instruction
 */
void add_hint(char *hint, int length, int line);

#endif
