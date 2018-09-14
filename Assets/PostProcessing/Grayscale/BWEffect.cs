using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BWEffect : MonoBehaviour {

    [Range(0, 1)]
    public float Intensity;
    private Material material;

    void Awake() {
        material = new Material(Shader.Find("Hidden/BWDiffuse"));
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        // Postprocess the image
        if(Intensity==0){
            Graphics.Blit(src, dest);
            return;
        }

        material.SetFloat("_bwBlend", Intensity);
        Graphics.Blit(src, dest, material);
    }

}
