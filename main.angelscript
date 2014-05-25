/*
 Hello world!
*/

#include "eth_util.angelscript"

int id = 1;

void main()
{
	LoadScene("scenes/First.esc", "setup", "run");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void setup() {
	//id = AddEntity("Player.ent", vector3(540, 600, 0), 0);
	id = AddEntity("Player.ent", vector3(540, 540, 20), 0);
	SeekEntity(id).Scale(vector2(0.5f,0.5f));
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
	if ((input.KeyDown(K_A) or input.KeyDown(K_LEFT)) and thisEntity.GetPositionX() > 144) {
		thisEntity.AddToPositionX(-5.0);
	}
	if ((input.KeyDown(K_D) or input.KeyDown(K_RIGHT)) and thisEntity.GetPositionX() < 872) {
		thisEntity.AddToPositionX(5.0);
	}
}

class Object {

	Object(){}
}

class TreeNode : Object {

      array<Object> children(3);
      int numChildren = 0; 
	  string stage;


	  TreeNode(string stage) {
		this.stage = stage;
	  }	
	  

      void addChild(Object newChild) {
      	   children[numChildren] = newChild;
		   numChildren++; 
      }

      void removeChild(int index) {
	       for(int i = index; i < numChildren - 1; i++) {
	   	        children[i] = children[i+1];
	       }		   
	       numChildren--;
      }

      Object getChild(int index) {
      	   return children[index];
      }	

}	   