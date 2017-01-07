.PHONY: clean run

snake2: snake2.asm
	nasm snake2.asm

run2: snake2
	qemu-system-x86_64 -drive format=raw,file=snake2

snake: snake.asm
	nasm snake.asm

run: snake
	qemu-system-x86_64 -drive format=raw,file=snake

clean:
	rm -f snake snake2
