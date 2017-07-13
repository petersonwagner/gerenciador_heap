exec: heap.s
	gcc -m64 heap.s teste.c -o exec

clean:
	rm exec