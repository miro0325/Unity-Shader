Shader "Custom/TextureBlend"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DecalTex ("Decal Texture", 2D) = "white" {}
        [Toggle]_ShowDecal ("Show Decal",float) = 0
       
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _DecalTex;
        float _ShowDecal;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DecalTex;
        };

        fixed4 _Color;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 a = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 b = tex2D (_DecalTex, IN.uv_MainTex) * _Color;
            b *= _ShowDecal;   
            o.Albedo = b.r > 0.9 ? b.rgb : a.rgb;
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
