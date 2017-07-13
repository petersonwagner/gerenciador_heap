#include <stdio.h>

main () {
	void *a,*b,*c,*d;

	iniciaAlocador();

	a=( void * ) alocaMem(100);
	
	 imprime();
	b=( void * ) alocaMem(200);

	 imprime();
	c=( void * ) alocaMem(300);
	 imprime();
	d=( void * ) alocaMem(400);
	 imprime();
	liberaMem(b);
	 imprime(); 
	
	b=( void * ) alocaMem(50);
	 imprime();
	
	liberaMem(c);
	 imprime(); 
	liberaMem(a);
	 imprime();
	liberaMem(b);
	 imprime();
	liberaMem(d);
	 imprime();
}