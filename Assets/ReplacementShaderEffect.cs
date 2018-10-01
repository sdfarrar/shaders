using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShaderEffect : MonoBehaviour {

    public Shader ReplacementShader;

    void OnEnable() {
        if(ReplacementShader==null){ return; }
        GetComponent<Camera>().SetReplacementShader(ReplacementShader, "RenderType");
    }
	
    void OnDisable() {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
