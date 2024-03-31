Shader "Custom/StandardPBR"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _MetallicTex ("Metallic (R)",2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue" = "Geometry" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MetallicTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MetallicTex;
        };

        half _Metallic;
        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = _Color.rgb;
            o.Metallic = _Metallic;
            //o.Specular = _Metallic;
            o.Smoothness = tex2D(_MetallicTex,IN.uv_MetallicTex).r;
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
