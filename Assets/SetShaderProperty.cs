using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SetShaderProperty : MonoBehaviour {

    public Material Material;
    public string PropertyName;
    public Transform Player;

	void Update() {
		if(Player==null || Material==null){ return; }
		Material.SetVector(PropertyName, Player.position);
	}
}
