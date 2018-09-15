Shader "PostProcess/CRTDiffuse"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MaskTex ("Mask Texture", 2D) = "white" {}
        _maskBlend ("Mask Blending", Float) = 0.5
        _maskSize ("Mask Size", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img // vert_img is the stardard "empty" vertex function
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _MaskTex;

			fixed _maskBlend;
			fixed _maskSize;
			
            // v2f_img is the standard input structure provided
			fixed4 frag(v2f_img i) : COLOR {
                fixed4 base = tex2D(_MainTex, i.uv);
                fixed4 mask = tex2D(_MaskTex, i.uv * _maskSize);
                return lerp(base, mask, _maskBlend);
			}
			ENDCG
		}
	}
}
