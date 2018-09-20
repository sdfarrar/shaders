using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOfLife : MonoBehaviour {

	public ComputeShader Compute;
	public Color Color;
	public int Width = 512; 
	public int Height = 512;
	public RenderTexture buf1, buf2; // double buffer
	public Material Material;

	private int kernal;
	private RenderTexture active;

	void Start () {
		kernal = Compute.FindKernel("CSMain");
		buf1 = CreateRenderTexture(Width, Height);
		buf2 = CreateRenderTexture(Width, Height);
		active = buf1;
	}

	private RenderTexture CreateRenderTexture(int width, int height){
		RenderTexture rt = new RenderTexture(Width, Height, 24);
		rt.enableRandomWrite = true;
		rt.Create();
		return rt;
	}
	
	void Update() {
		Compute.SetTexture(kernal, "Result", active); // "Result" matches with variable in compute
		Compute.SetVector("Color", Color);
		Compute.Dispatch(kernal, Width/8, Height/8, 1); // 8,8,1 matches compute shader numthreads

		// Swap buffers
		active = (active==buf1) ? buf2 : buf1;

		Material.SetTexture("_MainTex", active);
	}


}
