.PHONY: clean run

snake: snake.asm
	nasm snake.asm

run: snake
	qemu-system-x86_64 -drive format=raw,file=snake

clean:
	rm -f snake
