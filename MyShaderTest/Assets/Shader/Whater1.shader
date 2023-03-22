Shader "Unlit/Whater1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoismalTex("Noismal Texture",2D) = "white" {}
        _Mix("Mix",Range(0,1)) = 0.5
        _Speed("Speed",Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _NoismalTex;
            float _Speed;
            float _Mix;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 distuv = float2(i.uv.x + _Time.x * _Speed, i.uv.y + _Time.x * _Speed);
                float2 disp = tex2D(_NoismalTex,distuv).xy;
                disp = ((disp *2) -1) * _Mix;
                float4 col = tex2D(_MainTex,i.uv + disp);
                return col;
            }
            ENDCG
        }
    }
}
