﻿/*
 Hello world!
*/

#include "eth_util.angelscript"

int id = 1;
int ad = 1;
ETHEntityArray Doors;
ETHEntityArray Guardians;
ETHEntityArray Money;
ETHEntityArray Scrolls;
ETHEntityArray NiceScrolls;
bool reading = false;
bool musicCheck = false;
bool closeMusicCheck = false;
int Moneys = 0;
int orig_time = 0;
bool gold1 = false;
bool gold2 = false;
int monsterDist = 5;
bool dead = false;
float a = 0;

void main()
{
	LoadScene("scenes/First.esc", "setup", "run");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void setup() {

	for (int q = 0; q < Doors.Size(); q++) {
		DeleteEntity(Doors[q]);
	}
	Doors.RemoveDeadEntities();
					
	Guardians.clear();
	Scrolls.clear();
	Money.clear();


	if(monsterDist > 0) {
		id = AddEntity("Player.ent", vector3(540, 600, 20), 0);
	} else {
		dead = true;
	}
	
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
	if (musicCheck == false and monsterDist > 1) {
	   LoadMusic("song.mp3");
	   SetSampleVolume("song.mp3", 1.0f);
	   LoopSample("song.mp3", true);
	   PlaySample("song.mp3");
	   musicCheck = true;
	}
	if (closeMusicCheck == false and monsterDist <= 1) {
		LoadMusic("song3.mp3");
		SetSampleVolume("song3.mp3", 1.0f);
		LoopSample("song3.mp3", true);
		PlaySample("song3.mp3");
		closeMusicCheck = true;
	}
	
	
}

void Death() {
	ad = AddEntity("Death.ent", vector3(508, 130, 20), 0);
	/*orig_time = GetTime();
	if ((GetTime() -  orig_time)/4000 <= 1) {
		background.SetAlpha((GetTime() -  orig_time)/4000);
		DrawText(vector2(300, 300), "You Died" , "Verdana14_shadow.fnt", ARGB((GetTime() -  orig_time), 255, 255, 255));
	}*/
	if (a < 1) {
		a += 0.01;
	}
	SeekEntity(ad).SetAlpha(a);
	print (SeekEntity(ad).GetAlpha());
}


void run() {	
	DrawText(vector2(30, 700), "You have " + Moneys + " Gold", "Verdana14_shadow.fnt", ARGB(250, 255, 255, 255));

	if (Money.size() == 1) {
		if((Doors[0].GetString("Stage") == "Third" and gold1) or (Doors[0].GetString("Stage") == "Fourth" and gold2)){
			DeleteEntity(Money[0]);
			Money.RemoveDeadEntities();
		}
	}
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
	if (input.KeyDown(K_P)) {
		monsterDist = 1;
	}
	if ((input.KeyDown(K_A) or input.KeyDown(K_LEFT)) and thisEntity.GetPositionX() > 144 and !reading) {
		thisEntity.AddToPositionX(-5.0);
		thisEntity.SetSprite("entities\\PlayerLeft" + (((GetTime() / 150) % 3) + 1) + ".png");
	}
	if ((input.KeyDown(K_D) or input.KeyDown(K_RIGHT)) and thisEntity.GetPositionX() < 872 and !reading) {
		thisEntity.AddToPositionX(5.0);
		thisEntity.SetSprite("entities\\PlayerRight" + (((GetTime() / 150) % 3) + 1) + ".png");
	}
	if (input.KeyDown(K_SPACE)) {
		reading = false;
		for (int p = 0; p < NiceScrolls.Size(); p++) {
			DeleteEntity(NiceScrolls[p]);
			NiceScrolls.RemoveDeadEntities();
		}
		for (int i = 0; i < Doors.Size(); i++) {
			if ((thisEntity.GetPositionY() <= 155 or thisEntity.GetPositionY() > 655) and distance(thisEntity.GetPositionXY(), Doors[i].GetPositionXY()) <= 150) {
				if (Doors[i].GetInt("Unlocked") == 0) {
					if(thisEntity.GetPositionY() > 655 and monsterDist > 1) {
						LoadScene("scenes\\" + Doors[i].GetString("Stage") + ".esc", "setup", "run");			
						monsterDist--;
					} else if(thisEntity.GetPositionY() > 655 and monsterDist == 1) {
						LoadScene("scenes\\Death.esc", "", "Death");
			        } else {
						LoadScene("scenes\\" + Doors[i].GetString("Stage") + ".esc", "setup", "run");
					}
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
			
			if(SeekEntity("door.ent").GetString("Stage") == "Third") {
			    gold1 = true;
			} else {
			    gold2 = true;
			}
		}
	}
	for (int m = 0; m < Scrolls.Size(); m++) {
		if(distance(thisEntity.GetPositionXY(), Scrolls[m].GetPositionXY()) < 30) {
			AddEntity("Scroll" + Scrolls[m].GetString("Name") + ".ent", vector3(508, 420 /*Blaze it*/, 100), 0);
			GetEntityArray("Scroll" + Scrolls[m].GetString("Name") + ".ent", NiceScrolls);
			thisEntity.SetPosition(vector3(thisEntity.GetPositionX(), thisEntity.GetPositionY() + 30, 20));
			reading = true;
			
		}
	}
}
