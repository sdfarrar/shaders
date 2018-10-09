Shader "Custom/Water"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//_SecondaryTex ("Texture", 2D) = "white" {}
		//_Blend ("Blend Amount", Range(0,1)) = 0
        _Amplitude("Amplitude", Range(0, 5)) = 1
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			//sampler2D _SecondaryTex;
            float _Amplitude;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
               
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float displacement = (
                      sin(worldPos.z + _Time.w)
                    + sin(o.uv + _Time.y)
                    + sin(o.uv + _Time.w + .5)
                    + sin(worldPos.x + _Time.x - .128)
                    ) * _Amplitude;
                
                o.vertex.y += clamp(displacement*.3, -1, 0);

				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
                return col;
			}
			ENDCG
		}
	}
}
