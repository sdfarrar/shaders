using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CRTEffect : MonoBehaviour {

	public Material Material;

	// Postprocess the image
	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest, Material);
	}

}
