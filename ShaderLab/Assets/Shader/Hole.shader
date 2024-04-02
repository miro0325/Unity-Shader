Shader "Custom/Hole"
{
    Properties
    {
        _MainTex ("Diffuse", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }
        LOD 200

        ColorMask 0
        ZWrite off

        Stencil 
        {
            Ref 1
            Comp always
            Pass replace
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

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
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
