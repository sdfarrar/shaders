Shader "Hidden/Smoke"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Pixels ("Pixel Size", Float) = 256
        _Dissipation ("Dissipation Rate", Float) = 0.5
        _Minimum ("Minimum Flow", Range(0.001, 0.1)) = 0.003
		//_Turbulence ("Turbulence", Vector) = (0,0,0,0);
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
            half _Pixels;
            half _Dissipation, _Minimum;
			//half4 _Turbulence;

			float4 frag (v2f_img i) : COLOR {
                // Cell Center
                fixed2 uv = round(i.uv * _Pixels) / _Pixels;
                half s = 1 / _Pixels; // distance between 2 cells

                //Grid-like Notation //TODO attempt to convert to this
                //#define ARRAY(T,X,Y) (tex2D((T), uv + fixed2(s*(X), s*(Y))))
                //float cc = ARRAY(_MainText, 0, 0).a; // F[x+0, y+0]: Center Center

                //Neighbor cells
                float cl = tex2D(_MainTex, uv + fixed2(-s,  0)).a; // F[x-1, y  ]: Center Left
                float tc = tex2D(_MainTex, uv + fixed2( 0, -s)).a; // F[x  , y-1]: Top Center
                float cc = tex2D(_MainTex, uv + fixed2( 0,  0)).a; // F[x  , y  ]: Center Center
                float bc = tex2D(_MainTex, uv + fixed2( 0, +s)).a; // F[x  , y+1]: Bottom Center
                float cr = tex2D(_MainTex, uv + fixed2(+s,  0)).a; // F[x+1, y  ]: Center Right

                // Diffusion step //TODO add variable turbulence
                //float factor = _Dissipation * 0.016 * (0.25f * (cl+tc+bc+cr) - cc);
                //float factor = _Dissipation * 0.016 * ((cl+tc+bc+cr) -4 * cc); // Dissipation:14 Minimum:0.04
                float factor = _Dissipation * 0.016 * ((cl+tc*3+bc+cr) -6 * cc); // Dissipation:8  Minimum:0.04
                // Apply minimum flow
                factor = (factor >= -_Minimum && factor < 0.0) ? -_Minimum : factor;
                cc += factor;
                return float4(1,1,1,1) * cc;
			}

			ENDCG
		}
	}
}
