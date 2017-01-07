.PHONY: clean run

snake: snake.asm
	nasm snake.asm

run: snake
	qemu-system-x86_64 snake

clean:
	rm -f snake
