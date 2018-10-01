// https://youtu.be/Tjl8jP5Nuvc?t=304

// This shader should be placed in the ReplacementShader component script that is on the main camera
// It also needs objects to have a color drawn to them rather than a texture
// TODO replace stage material with dissolve, add elements around it with color materials

Shader "Custom/ShowDepth"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
                float depth : DEPTH;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            fixed4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.depth = -UnityObjectToViewPos(v.vertex).z * _ProjectionParams.w;
                //o.depth = -mul(UNITY_MATRIX_MV, v.vertex).z * _ProjectionParams.w;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float invert = 1 - i.depth;
				return fixed4(invert, invert, invert, 1) * _Color;
			}
			ENDCG
		}
	}
}
