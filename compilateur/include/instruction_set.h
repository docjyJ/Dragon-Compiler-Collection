#ifndef DCC_INSTRUCTION_SET_H_
#define DCC_INSTRUCTION_SET_H_

#include "types.h"

extern const op_code op_add;
extern const op_code op_multiply;
extern const op_code op_subtract;
extern const op_code op_divide;
extern const op_code op_copy;
extern const op_code op_define;
extern const op_code op_jump;
extern const op_code op_conditional_jump;
extern const op_code op_lower_than;
extern const op_code op_greater_than;
extern const op_code op_equal_to;
extern const op_code op_display;

extern const op_code op_logical_and;
extern const op_code op_logical_or;

/**
 * Permet de créer une instruction avec une constante.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param c la constante
 */
inst op_c(address line, op_code code, address c);

/**
 * Permet de créer une instruction avec une variable d'entré.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param i la variable d'entrée (si NULL, une variable sera récupérée)
 */
inst op_i(address line, op_code code, label i);

/**
 * Permet de créer une instruction avec une variable de sortie et une constante.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param o la variable de sortie (si NULL, une variable temporaire sera créée)
 * @param c la constante
 */
inst op_oc(address line, op_code code, label o, address c);

/**
 * Permet de créer une instruction avec une variable d'enrée et une constante.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param i la variable d'entrée (si NULL, une variable sera récupérée)
 * @param c la constante
 */
inst op_ic(address line, op_code code, label i, address c);

/**
 * Permet de créer une instruction avec une variable de sortie et une variable d'entrée.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param o la variable de sortie (si NULL, une variable temporaire sera créée)
 * @param i la variable d'entrée (si NULL, une variable sera récupérée)
 */
inst op_oi(address line, op_code code, label o, label i);

/**
 * Permet de créer une instruction avec deux variables d'entrée et une variable de sortie.
 * @param line le numéro de la ligne
 * @param code le code de l'instruction
 * @param o la variable de sortie (si NULL, une variable temporaire sera créée)
 * @param i1 la première variable d'entrée (si NULL, une variable sera récupérée)
 * @param i2 la deuxième variable d'entrée (si NULL, une variable sera récupérée)
 */
inst op_oii(address line, op_code code, label result, label i1, label i2);

#endif
