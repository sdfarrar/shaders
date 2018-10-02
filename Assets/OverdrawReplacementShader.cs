using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class OverdrawReplacementShader : MonoBehaviour {

    public Shader ReplacementShader;
    public Color OverdrawColor;

    void OnValidate() {
        Shader.SetGlobalColor("_OverdrawColor", OverdrawColor);
    }
	
    void OnEnable() {
        if(ReplacementShader==null){return;}
        GetComponent<Camera>().SetReplacementShader(ReplacementShader, ""); // have everything use the same subshader
    }
}
