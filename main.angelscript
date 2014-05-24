/*
 Hello world!
*/

#include "eth_util.angelscript"

//int id = 1;

void main()
{
	LoadScene("scenes/First.esc", "setup", "run");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void setup() {
	//id = AddEntity("Player.ent", vector3(540, 600, 0), 0);
	AddEntity("Player.ent", vector3(540, 700, 20), 0);
}

void run() {
}

void ETHCallback_Player(ETHEntity@ thisEntity) {
ETHInput@ input = GetInputHandle();
	if (input.KeyDown(K_W)) {
		thisEntity.AddToPositionY(-5.0);
	}
	if (input.KeyDown(K_S)) {
		thisEntity.AddToPositionY(5.0);
	}
	if (input.KeyDown(K_A)) {
		thisEntity.AddToPositionX(-5.0);
	}
	if (input.KeyDown(K_D)) {
		thisEntity.AddToPositionX(5.0);
	}
}