Shader "Hidden/Smoke"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Pixels ("Pixel Size", Int) = 256
        _Dissipation ("Dissipation Rate", Range(0, 1)) = 0.5
        _Minimum ("Minimum Flow", Range(0, 1)) = 0.1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert (appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
            int _Pixels;
            float _Dissipation, _Minimum;

			fixed4 frag (v2f i) : COLOR {
                // Cell Center
                fixed2 uv = round(i.uv * _Pixels) / _Pixels;
                half s = 1 / _Pixels; // distance between 2 cells

                //Grid-like Notation
                //#define ARRAY(T,X,Y) (tex2D((T), uv + fixed2(s*(X), s*(Y))))
                //float cc = ARRAY(_MainText, 0, 0).a; // F[x+0, y+0]: Center Center

                //Neighbor cells
                float cl = tex2D(_MainTex, uv + fixed2(-s,  0)).a; // F[x-1, y  ]: Center Left
                float tc = tex2D(_MainTex, uv + fixed2( 0, -s)).a; // F[x  , y-1]: Top Center
                float cc = tex2D(_MainTex, uv + fixed2( 0,  0)).a; // F[x  , y  ]: Center Center
                float bc = tex2D(_MainTex, uv + fixed2( 0, +s)).a; // F[x  , y+1]: Bottom Center
                float cr = tex2D(_MainTex, uv + fixed2(+s,  0)).a; // F[x+1, y  ]: Center Right

                // Diffusion step
                float factor = _Dissipation * (0.25f * (cl+tc+bc+cr) - cc);
                // Minimum flow
                if(factor >= -_Minimum && factor < 0.0){
                    factor = -_Minimum;
                }
                //factor = (factor >= _Minimum && factor < 0.0) ? -_Minimum : factor;
                cc += factor;
                return float4(1,1,1,cc);
			}

			ENDCG
		}
	}
}
