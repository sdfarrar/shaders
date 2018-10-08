using System;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class MaterialRegion : MonoBehaviour {

	public static event Action<MaterialRegion> OnRegionEntered = delegate {};

	public Material TargetMaterial;

	private new BoxCollider collider;

	void Start() {
		collider = GetComponent<BoxCollider>();
	}
	
	void OnTriggerEntere(Collider other){
		if(!other.gameObject.CompareTag("Player")){ return; }

		OnRegionEntered(this);
	}

}
