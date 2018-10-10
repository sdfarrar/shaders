using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class ScrollTexture : MonoBehaviour {

    public float ScrollX = 0.5f;
    public float ScrollY = 0.5f;
    public string TextureName = "_MainTex";

    private Material material;

	void Start () {
		material = GetComponent<Renderer>().material;
	}
	
	void Update () {
		float offsetX = Time.time * ScrollX;
		float offsetY = Time.time * ScrollY;
        material.SetTextureOffset(TextureName, new Vector2(offsetX, offsetY));
	}
}
