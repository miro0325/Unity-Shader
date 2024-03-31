Shader "Custom/Blend"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        //Blend DstColor Zero
        Pass 
        {
            SetTexture [_MainTex] { combine texture }
        }
    }
    FallBack "Diffuse"
}
