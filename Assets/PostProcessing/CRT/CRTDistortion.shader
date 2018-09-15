Shader "PostProcess/CRTDistortion"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_DisplacementTex ("Displacement Texture", 2D) = "white" {}
        _Strength ("Strength", Range(0,0.15)) = 0.085
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
			uniform sampler2D _DisplacementTex;

			fixed _Strength;
			
            // v2f_img is the standard input structure provided
			float4 frag(v2f_img i) : COLOR {
				half2 n = tex2D(_DisplacementTex, i.uv);
				half2 d = n * 2 - 1;
				i.uv += d * _Strength;
				i.uv = saturate(i.uv);

				float4 c = tex2D(_MainTex, i.uv);
				return c;
			}
			ENDCG
		}
	}
}
