using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class SetTextureRegion : MonoBehaviour {

	public static event Action<SetTextureRegion> OnRegionEntered = delegate { };

	public RenderTexture TargetTexture;

	private new BoxCollider collider;

	// Use this for initialization
	void Start () {
		collider = GetComponent<BoxCollider>();
	}
	
	void OnTriggerEnter(Collider other) {
		if(!other.gameObject.CompareTag("Player")){ return ; }

		OnRegionEntered(this);
		
	}

}
