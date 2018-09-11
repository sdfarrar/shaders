Shader "Intro/Properties"
{
	Properties
	{
		_MyTexture ("My Texture", 2D) = "white" {}
        _MyNormalMap ("My normal map", 2D) = "bump" {} // Gray

        _MyInt ("My integer", Int) = 2
        _MyFloat ("My float", Float) = 1.5
        _MyRange ("My range", Range(0.0, 1.0)) = 0.5

        _MyColor ("My color", Color) = (1, 0, 0, 1) // (R, G, B, A)
        _MyVector ("My Vector4", Vector) = (0, 0, 0, 0) // (x, y, z, w)

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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MyTexture;
            sampler2D _MyNormalMap;

            int _MyInt;
            float _MyFloat;
            float _MyRange;

            half4 _MyColor;
            half4 _MyVector;
			
			float4 _MyTexture_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MyTexture);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MyTexture, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
