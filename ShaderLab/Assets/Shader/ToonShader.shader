Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "while" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon

        #pragma target 3.0

        sampler2D _RampTex;

        half4 LightingToon (SurfaceOutput s, half3 lightDir,half3 viewDir, half atten) 
        {
            //half3 h = normalize(lightDir + viewDir);
            half diff  = max(0,dot(s.Normal,lightDir));
            half h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex,rh).rgb;
            //diff = floor(diff / 0.3);
            float spec = pow(rh,48);
            spec = smoothstep(0.005, 0.1,spec);
            //spec = floor(spec / 0.3);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * (ramp));
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
