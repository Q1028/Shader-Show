Shader "Unlit/SinShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SubTex("SubTex",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Back
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

            struct v2f//就是Vert to frag
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;//如果是TRANSFORM_TEX就需要这个语句

            v2f vert (appdata v)                                  //计算或改变顶点操作在这里操作
            {
                v2f o;
                float dist = distance(v.vertex.xyz,float3(0,0,0));//模型的顶点坐标
                float h = sin(dist*2 + _Time.z)/3;                //sin(相位距离*2+时间值*2)，计算出正弦曲线，及振幅，也就是高度
                o.vertex = mul(unity_ObjectToWorld,v.vertex);     //将顶点坐标转到世界坐标
                o.vertex.y = h;                                   //顶点的y轴 = 振幅
                o.vertex = mul(unity_ObjectToWorld,o.vertex);     //再将新的世界坐标转到世界坐标
                o.vertex = UnityObjectToClipPos(o.vertex);        //再把顶点坐标转换到试图坐标下
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);              //计算真正的纹理坐标
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);
                return col;
            }
            ENDCG
        }
    }
}
