#include <malloc.h>
#include <string.h>
#include "memory.h"
#include "stack.variable.h"

typedef struct {
    char *nom;
    address visibility;
} symbole;

symbole var_stak[MAX_ADDRESS];

address var_head = 1;
address visibility = 0;
address global = 0;
address offset_function = 0;

address nb_declaration() {
    return var_head;
}

address nb_global() {
    return global;
}

address get_visibility(){
    return visibility;
}

int find_var(label name, address *out) {
    int i;
    if (strlen(name) == 0)
        i = -1;
    else if(name[0]=='$'){
        var_stak[0].visibility = 0; //TODO : trouver une solution pour les variables globals
        *out = (address) 0;
        return 1;
    }
    else
        for (i = var_head; i >= 0 && (var_stak[i].nom == NULL || strcmp(var_stak[i].nom, name) != 0); i--);

    if (i > 0) {
        if (out != NULL) *out = (address) i;
        return 1;
    } else if (i == 0 && strcmp(var_stak[i].nom, name) == 0){
        if (out != NULL) *out = (address) i;
        return 1;
    } else {
        return -1;
    }
}

void var_create(label name) {
    if (var_head == 0xFF)
        yyerror("not enough memory");

    address add;

    int index = find_var(name, &add);
    if (var_stak[add].visibility== visibility && index!=-1 )
        yyerror(printf_alloc("<%s> already exist", name));

    var_stak[var_head].nom = copy_alloc(name);
    var_stak[var_head].visibility = visibility;
    var_head++;

    if (visibility == 0){
        global++;
    }
}

memory_address tab_alloc(address length) {
    memory_address out = {var_head, 0};

    if (visibility != 0) {
        out.value =out.value - offset_function;
        out.isLocal = 1;
    }
    int max = var_head + length;

    while (var_head < max) {
        var_stak[var_head].nom = NULL;
        var_stak[var_head].visibility = visibility;
        var_head++;
    }

    return out;
}

memory_address var_get(label name) {
    address add;
    if (find_var(name, &add)==-1)
        yyerror(printf_alloc("<%s> does not exist", name));

    memory_address out = {add, 0};
    if (var_stak[add].visibility != 0) {
        out.value =  out.value - offset_function ;
        out.isLocal = 1;
    }
    return out;
}


address temp_push() {
    if (var_head == 0xFF) yyerror("not enough memory");
    var_head++;
    address out =var_head  - offset_function -1;

    return  out;
}

address temp_pop() {
    if (var_head == 0x00) yyerror("il n'y a pas de variable");
    var_head --;
    address out =var_head  - offset_function ;
    return out ;
}

memory_address var_get_or_temp_push(label name) {
    memory_address out;

    if (name != NULL){
        out = var_get(name);
    } else {
        out.value = temp_push();

        if(visibility>=1) out.isLocal = 1; // on peut avoir des temps globaux
        else             out.isLocal = 0;
    }

    return out;
}

memory_address var_get_or_temp_pop(label name) {
    memory_address out;

    if (name != NULL){
        out = var_get(name);
    } else {
        out.value = temp_pop();

        if(visibility>=1) out.isLocal = 1; // on peut avoir des temps globaux
        else             out.isLocal = 0;
    }

    return out;

}

void add_visibility() {
    if (visibility == MAX_ADDRESS / 2 - 1) yyerror("can't add visibility level");
    if (visibility == 0) offset_function = var_head;
    // dans le rpincipe on peut pas déclarer une fonction dans une autre fonction
    // donc si et seulement si la visibilité augmente et qu'on est pas déja dans une fonction, ondéclare une fonction
    visibility++;
}

void remove_visibility() {
    if (visibility == 0) yyerror("can't remove visibility level");
    if (visibility == 1) offset_function = 0;
    visibility--;

     // on pense aussi à remove les quelque temps qui pourrais rester
     // même si en théorie ceux-ci n'arrive jamais

    while (var_head > 0 && (var_stak[var_head - 1].visibility > visibility || var_stak[var_head - 1].nom==NULL )) {
        var_head--;
        free(var_stak[var_head].nom);
        var_stak[var_head].nom = NULL;
        var_stak[var_head].visibility = 0;
    }
}
