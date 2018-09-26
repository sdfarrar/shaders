Shader "Hidden/GameOfLife"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Pixels ("Pixel Size", Float) = 256
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

            // 1. Any live cell with fewer than two live neighbors dies, as if by under population.
            // 2. Any live cell with two or three live neighbors lives on to the next generation.
            // 3. Any live cell with more than three live neighbors dies, as if by overpopulation.
            // 4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.


            static int2 rule[9] =
            {
                int2(0,0),
                int2(0,0),
                int2(1,0),	// 2 neighours = survive
                int2(0,1),	// 3 neighours = born
                int2(0,0),
                int2(0,0),
                int2(0,0),
                int2(0,0),
                int2(0,0),
            };

			float4 frag (v2f_img i) : COLOR {
                half actualPixels = _Pixels - 1;
                // Cell Center
                fixed2 uv = round(i.uv * actualPixels) / actualPixels;
                half s = 1 / actualPixels; // distance between 2 cells

                //Grid-like Notation //TODO attempt to convert to this
                //#define ARRAY(T,X,Y) (tex2D((T), uv + fixed2(s*(X), s*(Y))))
                //float cc = ARRAY(_MainText, 0, 0).a; // F[x+0, y+0]: Center Center

                // This cell
                float3 cc = tex2D(_MainTex, uv); // Center Center == uv

                // Neighbor cells
                float tl = tex2D(_MainTex, uv + fixed2(+s, -s)).r;  // Top Left
                float tc = tex2D(_MainTex, uv + fixed2(+s,  0)).r;  // Top Center
                float tr = tex2D(_MainTex, uv + fixed2(+s, +s)).r;  // Top Right
                float cl = tex2D(_MainTex, uv + fixed2( 0, -s)).r;  // Center Left 
                float cr = tex2D(_MainTex, uv + fixed2( 0, +s)).r;  // Center Right
                float bl = tex2D(_MainTex, uv + fixed2(-s, -s)).r;  // Bottom Left
                float bc = tex2D(_MainTex, uv + fixed2(-s,  0)).r;  // Bottom Center
                float br = tex2D(_MainTex, uv + fixed2(-s, +s)).r;  // Bottom Right

                float count = tl + tc + tr + cl + cr + bl + bc + br;

                int2 r = rule[count];
                int status = cc.r * r.x + r.y;

                // Degrade blue and green channels as a cell lives longer making become red
                float red = status;
                float green = (cc.r==1 && status==1) ? cc.g*0.9 : status;
                float blue = (cc.r==1 && status==1) ? cc.b*0.9 : status;

                return float4(red, green, blue, 1);
			}

			ENDCG
		}
	}
}
