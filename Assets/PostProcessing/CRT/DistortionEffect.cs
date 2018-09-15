using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DistortionEffect : MonoBehaviour {

	public Material Material;
	[Range(0, 0.15f)]
	public float Strength;

	// Postprocess the image
	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Material.SetFloat("_Strength", Strength);
		Graphics.Blit(src, dest, Material);
	}
}
