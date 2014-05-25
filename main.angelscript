/*
 Hello world!
*/

#include "eth_util.angelscript"

int id = 1;
ETHEntityArray Doors;
ETHEntityArray Guardians;
ETHEntityArray Money;
ETHEntityArray Scrolls;
ETHEntityArray NiceScrolls;
bool reading = false;
int Moneys = 0;

void main()
{
	LoadScene("scenes/First.esc", "setup", "run");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void setup() {
	id = AddEntity("Player.ent", vector3(540, 600, 20), 0);
	//SeekEntity(id).Scale(vector2(0.5f,0.5f));
	/*ETHEntity@ door = SeekEntity("door.ent");
	Doors.Insert(door);*/
	GetEntityArray("door.ent", Doors);
	GetEntityArray("guardian1.ent", Guardians);
	GetEntityArray("guardian2.ent", Guardians);
	GetEntityArray("guardian3.ent", Guardians);
	GetEntityArray("guardian4.ent", Guardians);
	GetEntityArray("coins.ent", Money);
	GetEntityArray("Scroll.ent", Scrolls);
}

void run() {	
DrawText(vector2(30, 700), "You have " + Moneys + " Gold", "Verdana14_shadow.fnt", ARGB(250, 255, 255, 255));
}

void ETHCallback_Player(ETHEntity@ thisEntity) {
ETHInput@ input = GetInputHandle();
	if ((input.KeyDown(K_W) or input.KeyDown(K_UP)) and thisEntity.GetPositionY() > 150 and !reading) {
		thisEntity.AddToPositionY(-5.0);
		thisEntity.SetSprite("entities\\PlayerForward" + (((GetTime() / 150) % 3) + 1) + ".png"); 
	}
	if ((input.KeyDown(K_S) or input.KeyDown(K_DOWN)) and thisEntity.GetPositionY() < 660 and !reading) {
		thisEntity.AddToPositionY(5.0);
		thisEntity.SetSprite("entities\\PlayerBack" + (((GetTime() / 150) % 3) + 1) + ".png");
	}
	if ((input.KeyDown(K_A) or input.KeyDown(K_LEFT)) and thisEntity.GetPositionX() > 144 and !reading) {
		thisEntity.AddToPositionX(-5.0);
		thisEntity.SetSprite("entities\\PlayerLeft" + (((GetTime() / 150) % 3) + 1) + ".png");
	}
	if ((input.KeyDown(K_D) or input.KeyDown(K_RIGHT)) and thisEntity.GetPositionX() < 872 and !reading) {
		thisEntity.AddToPositionX(5.0);
		print (Doors.Size());
		thisEntity.SetSprite("entities\\PlayerRight" + (((GetTime() / 150) % 3) + 1) + ".png");
	}
	if (input.KeyDown(K_SPACE)) {
		reading = false;
		for (int p = 0; p < NiceScrolls.Size(); p++) {
			DeleteEntity(NiceScrolls[p]);
			NiceScrolls.RemoveDeadEntities();
		}
		for (int i = 0; i < Doors.Size(); i++) {
			if ((thisEntity.GetPositionY() <= 155 or thisEntity.GetPositionY() > 655) and distance(vector2(thisEntity.GetPositionX(), 0), vector2(Doors[i].GetPositionX(),0)) <= 64) {
				if (Doors[i].GetInt("Unlocked") == 0) {
				LoadScene("scenes\\" + Doors[i].GetString("Stage") + ".esc", "setup", "run");
				Doors.clear();
				Guardians.clear();
				Scrolls.clear();
				Money.clear();
				}
			}
		}
	}
	for (int j = 0; j < Guardians.Size(); j++) {
		if(distance(thisEntity.GetPositionXY(), Guardians[j].GetPositionXY()) < 128) {
			DrawText(vector2(Guardians[j].GetPositionX() - (Guardians[j].GetString("Message").length() * 3.4), Guardians[j].GetPositionY() - 70), Guardians[j].GetString("Message"), "Verdana14_shadow.fnt", ARGB(250, 255, 255, 255));
		}
		if(distance(thisEntity.GetPositionXY(), Guardians[j].GetPositionXY()) < 128 and Moneys >= 100 and input.KeyDown(K_SPACE) and Guardians[j].GetInt("MoneyGiven") == 2 and Guardians[j].GetEntityName() == "guardian4.ent") {
			Moneys -= 100;
			Guardians[j].SetInt("MoneyGiven", 1);
			for (int kl = 0; kl < Doors.Size(); kl++) {
				Doors[kl].SetInt("Unlocked", 0);
			}
		}
	}
	for (int k = 0; k < Money.Size(); k++) {
		if(distance(thisEntity.GetPositionXY(), Money[k].GetPositionXY()) < 64) {
			DeleteEntity(Money[0]);
			Money.RemoveDeadEntities();
			Moneys += 100;
		}
	}
	for (int m = 0; m < Scrolls.Size(); m++) {
		if(distance(thisEntity.GetPositionXY(), Scrolls[m].GetPositionXY()) < 64) {
			print (Scrolls[m].GetString("Name"));
			AddEntity("Scroll" + Scrolls[m].GetString("Name") + ".ent", vector3(508, 420 /*Blaze it*/, 100), 0);
			GetEntityArray("Scroll" + Scrolls[m].GetString("Name") + ".ent", NiceScrolls);
			thisEntity.SetPosition(vector3(thisEntity.GetPositionX(), thisEntity.GetPositionY() + 30, 20));
			reading = true;
			
		}
	}
}
