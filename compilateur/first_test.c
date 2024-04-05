int a = 4;

void g (){
    int c = 1;
}

void main () {

    int b = 2 ;
    int c = 3 + (4 + b);
    b = a * 2;
    a = b - 3 * 2;
    c = a / (a + a * b);
    a = b = c = 3;

    g();

    int e = 0xEE, t = 1, h = 2;

    if (1){
        a = 1;
    }

    if (0){
        a = 0;
    }

    int f = 0xFF;

    c = 10;

    while(c==1){
        c=c-1;
    }

    do {
        c=c+1 ;
    } while(c);
}
