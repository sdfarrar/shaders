using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyPlayerPosition : MonoBehaviour {

    public List<Transform> PlayerPositions;

	void Update() {
        CopyActivePlayerPosition();
	}

    private void CopyActivePlayerPosition(){
		foreach(Transform t in PlayerPositions){
            if(!t.gameObject.activeSelf){ continue; }
            transform.position = t.position;
            return;
        }
    }
}
