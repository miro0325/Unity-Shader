Shader "Custom/CustomLight"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf CustomLight

        #pragma target 3.0

        half4 LightingCustomLight (SurfaceOutput s, half3 lightDir, half atten) 
        {
            half NdotL = dot(s.Normal, lightDir);
            //NdotL = floor(NdotL / 0.3);
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

      
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
