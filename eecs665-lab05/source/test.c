int funca( int a, int b ) {
    funce();
    return a * b;
}

int funcb( int b ) {
    funcd();
    return funca( b, b );
}

int funcc( int a, int b ) {
    int c;
    int d;
    while( funca( 25, 30 ) ) {
        
    }
}

int funcd() {
    int x;
    int y;
    funce( 4 );
    y << 2;
    if ( funcd() < 100 ) {
        return 1;
    }
    
    return 0;
}

int funce( int x ) {
    return x;
}


int main( int argc, char *argv[] ) {
    int a;
    int b;

    funca( 2, 10 );
    funcb( 5 );

    if( argc <= 2 ) {
        funcc( 0, 1 );
    }
    else {
        funcd();
    }

    return a + b;
}
