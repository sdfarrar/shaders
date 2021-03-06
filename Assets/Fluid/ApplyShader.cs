﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyShader : MonoBehaviour {

	public Texture InitialTexture;
	public RenderTexture Texture;

	public Material Material;
	public float Interval = 1;

	private RenderTexture buffer;
	private Coroutine handle;

	void Start() {
		Graphics.Blit(InitialTexture, Texture);
		//buffer = new RenderTexture(Texture.width, Texture.height, Texture.depth, Texture.format);
		buffer = new RenderTexture(Texture);

        Material.SetFloat("_Pixels", InitialTexture.width); // assuming square texture
		handle = StartCoroutine(UpdateTexture());
	}
	
	private IEnumerator UpdateTexture() {
		while(true){
			Graphics.Blit(Texture, buffer, Material);
			Graphics.Blit(buffer, Texture);
			yield return new WaitForSeconds(Interval);
		}
	}
}
