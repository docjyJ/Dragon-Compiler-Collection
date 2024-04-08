#ifndef DCC_ERROR_MEMORY_H_
#define DCC_ERROR_MEMORY_H_

#include "app.h"

/**
 * Convertit une chaîne de caractères en nombre.
 * Génère une erreur si la conversion échoue.
 * @param s la chaîne de caractères à convertir
 * @param base la base du nombre
 * @return le nombre converti
 * @see strtoul
 */
unsigned long parse_number(const char *s, int base);

/**
 * Alloue un espace mémoire pour copier une chaîne de caractères.
 * Génère une erreur si l'allocation échoue.
 * @param s la chaîne de caractères à copier
 * @return un pointeur vers l'espace mémoire alloué
 * @see asprintf
 */
char *copy_alloc(const char *s);

/**
 * Alloue un espace mémoire pour une chaîne de caractères formatée.
 * Génère une erreur si l'allocation échoue.
 * @param fmt le format de la chaîne de caractères
 * @return un pointeur vers l'espace mémoire alloué
 * @see vasprintf
 */
char *printf_alloc(const char *fmt, ...);

/**
 * Alloue un espace mémoire de taille fixe.
 * Génère une erreur si l'allocation échoue.
 * @param size la taille de l'espace mémoire à allouer
 * @return un pointeur vers l'espace mémoire alloué
 * @see malloc
 */
void *empty_alloc(long unsigned int size);

#endif
