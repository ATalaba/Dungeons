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
	AddEntity("Player.ent", vector3(540, 540, 20), 0);
}

void run() {
}

void ETHCallback_Player(ETHEntity@ thisEntity) {
ETHInput@ input = GetInputHandle();
	if ((input.KeyDown(K_W) or input.KeyDown(K_UP)) and thisEntity.GetPositionY() > 150) {
		thisEntity.AddToPositionY(-5.0);
	}
	if ((input.KeyDown(K_S) or input.KeyDown(K_DOWN)) and thisEntity.GetPositionY() < 660) {
		thisEntity.AddToPositionY(5.0);
	}
	if ((input.KeyDown(K_A) or input.KeyDown(K_LEFT)) and thisEntity.GetPositionX() > 160) {
		thisEntity.AddToPositionX(-5.0);
	}
	if ((input.KeyDown(K_D) or input.KeyDown(K_RIGHT)) and thisEntity.GetPositionX() < 920) {
		thisEntity.AddToPositionX(5.0);
	}
}