Shader "Custom/Diffuse Distance" {
	Properties {
		_Tint ("Tint", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Center ("Center", Vector) = (0,0,0,0)
        _Radius ("Radius", Float) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		struct Input {
            float2 uv_MainTex; // gathers UV data from _MainTex. naming matters here
            float3 worldPos; // world position of the point
		};

        sampler2D _MainTex;
		fixed4 _Tint;
        float3 _Center;
        float _Radius;

		void surf (Input IN, inout SurfaceOutput o) {
            float d = distance(_Center, IN.worldPos);
            float dN = 1 - saturate(d / _Radius);
            dN = step(0.25, dN) * step(dN, 0.3); // replaces if/else below
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * (1-dN) + half3(1,1,1) * dN;
            //if(dN > 0.25 && dN < 0.3){
            //    o.Albedo = half3(1,1,1);
            //}else{
            //    o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Tint;
            //}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
