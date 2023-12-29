Shader "TAPro/RayTracingCard"
{
    Properties
    {
        [Space(50)]
        [HDR]_FrameTint("_FrameTint ",Color)= (1,1,1,1)
        _Frame("Frame",2D) = "Black"{}
        
        [Space(50)]
        [HDR]_ParallaxMapTint("_ParallaxMapTint ",Color)= (1,1,1,1)
        _ParallaxMap("Parallax Map",2D) = "Black"{}
        _Depth("Depth",Float) = 0
        
        [Space(50)]
        [HDR]_ParallaxMap2Tint("_ParallaxMap2Tint ",Color)= (1,1,1,1)
        _ParallaxMap2("Parallax Map 2",2D) = "Black"{}
        _Depth2("Depth 2",Float) = 0
        
        [Space(50)]
        [HDR]_ParallaxMap3Tint("_ParallaxMap3Tint ",Color)= (1,1,1,1)
        _ParallaxMap3("Parallax Map 3",2D) = "Black"{}
        _Depth3("Depth 3",Float) = 0
        
        
        
        
        [Space(50)]
        [HDR]_ParallaxMap4Tint("_ParallaxMap4Tint ",Color)= (1,1,1,1)
        _ParallaxMap4("Parallax Map 4",2D) = "Black"{}
        _Depth4("Depth 4",Float) = 0
        
        [Space(50)]
        [HDR]_ParallaxMap5Tint("_ParallaxMap5Tint ",Color)= (1,1,1,1)
        _ParallaxMap5("Parallax Map 5",2D) = "Black"{}
        _Depth5("Depth 5",Float) = 0
        
        [Space(50)]
        [HDR]_P2NoiseTint("_P2NoiseTint ",Color)= (1,1,1,1)
        _P2NoiseMap("_P2NoiseMap",2D) = "White"{}
        _P2NoiseMapVec(" _P2NoiseMapVec",Vector) = (1,1,1,1)
        
        [Space(50)]
        [HDR]_P3NoiseTint("_P3NoiseTint ",Color)= (1,1,1,1)
        _P3NoiseMap("_P3NoiseMap",2D) = "White"{}
        _P3NoiseMapVec(" _P3NoiseMapVec",Vector) = (1,1,1,1)
        
        [Space(50)]
        [HDR]_P4NoiseTint("_P4NoiseTint ",Color)= (1,1,1,1)
        _P4NoiseMap("_P4NoiseMap",2D) = "White"{}
        _P4NoiseMapVec(" _P4NoiseMapVec",Vector) = (1,1,1,1)
        
        
        
        [Space(50)]
        [HDR]_BackgroundTint("_Background Tint",Color)= (1,1,1,1)
        _BackgroundMap("_Background Map",2D) = "Black"{}
//      _BackgroundDepth("_BackgroundDepth",Float) = 0
        
        [Space(50)]
        _StartRainbowColor("_StartRainbowColor",2D) = "Black"{}
        _HSVSaturation("_HSVSaturation",float)=0
        _HSVValue("_HSVValue",float) = 0
    	_HSVNoise("_HSVNoise",float) = 0
    	_HSVPow("_HSVPow",Vector) = (0,0,0,0)
    	_StarMin("_StarMin",float) = 0
        
        [Toggle] _EnableColorfulBackground("RainbowColorOn",Float) = 0
        [HDR]_RainbowMapTint("_RainbowMapTint Tint",Color)= (1,1,1,1)
        _RainbowMap("RainbowMap Map",2D) = "White"{}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase" "Queue" = "Geometry"}
       

        Pass
        {
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _CloudTex;

            sampler2D _ParallaxMap,_HeightMap;float4 _ParallaxMap_ST;float _Depth;
            sampler2D _ParallaxMap2,_HeightMap2;float4 _ParallaxMap2_ST;float _Depth2;
            sampler2D _ParallaxMap3,_HeightMap3;float4 _ParallaxMap3_ST;float _Depth3;
            sampler2D _ParallaxMap4,_HeightMap4;float4 _ParallaxMap4_ST;float _Depth4;
            sampler2D _ParallaxMap5,_HeightMap5;float4 _ParallaxMap5_ST;float _Depth5;

            sampler2D _Frame;float4 _Frame_ST;
            
            float _UVScale;
            float4 _ParallaxMapTint,_ParallaxMap2Tint,_FrameTint;
            float4 _ParallaxMap4Tint;
            float4 _ParallaxMap5Tint;

            //背景层流光
            float4 _P2NoiseTint,_P2NoiseMapVec;
            float4 _P4NoiseTint,_P4NoiseMapVec;
            float4 _P5NoiseTint,_P5NoiseMapVec;
            sampler2D _P2NoiseMap;
            sampler2D _P3NoiseMap;
            sampler2D _P4NoiseMap;

            //背面层
            sampler2D  _BackgroundMap;
            float4 _BackgroundTint;
            float4 _BackgroundMap_ST;
            float _EnableColorfulBackground;

            sampler2D _StartRainbowColor;
            float4 _StartRainbowColor_ST;
            float _HSVSaturation;
            float _HSVValue;
            float _HSVNoise;
            float _StarMin;
            float4 _HSVPow;
            
            
            float4 _RainbowMapTint,_RainbowMap_ST;
            sampler2D _RainbowMap;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 tangent :TANGENT;
                float3 normal : NORMAL;
                float4 vertexColor : COLOR;
            };

            struct V2FData
            {
                float4 pos : SV_POSITION; // 必须命名为pos ，因为 TRANSFER_VERTEX_TO_FRAGMENT 是这么命名的，为了正确地获取到Shadow
                float2 uv : TEXCOORD0;
                float3 tangent : TEXCOORD1;
                float3 bitangent : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 posWS : TEXCOORD4;
                float3 localPosition : TEXCOORD5;
                float3 localNormal : TEXCOORD6;
                float4 vertexColor : TEXCOORD7;
                float2 uv2 : TEXCOORD8;
            };

            V2FData vert(MeshData v)
            {
                V2FData o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.uv2 = v.uv2;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWS = mul(unity_ObjectToWorld, v.vertex);
                o.localPosition = v.vertex.xyz;
                o.tangent = UnityObjectToWorldDir(v.tangent);
                o.bitangent = cross(o.normal, o.tangent) * v.tangent.w;
                o.localNormal = v.normal;
                o.vertexColor = v.vertexColor;

                return o;
            }
            float4 ParallaxMapping(sampler2D ParallaxMap, float depth , float2 uv, float4 ParallaxMap_ST, float3 viewTS)
            {
                uv = uv*ParallaxMap_ST.xy + ParallaxMap_ST.zw;
                
                float cosTheta = dot(viewTS,float3(0,0,1));
                float viewTSLength = depth / cosTheta;
                float3 startPoint = float3(uv,0);
                float3 endPoint = startPoint + viewTS*viewTSLength;
                float4 parallax = tex2D(ParallaxMap,saturate( endPoint.xy));
                return parallax;
            }

            float4 ParallaxMappingOutUV(sampler2D ParallaxMap, float depth , float2 uv, float4 ParallaxMap_ST, float3 viewTS,out float2 ParallaxUV)
            {
                uv = uv*ParallaxMap_ST.xy + ParallaxMap_ST.zw;
                
                float cosTheta = dot(viewTS,float3(0,0,1));
                float viewTSLength = depth / cosTheta;
                float3 startPoint = float3(uv,0);
                float3 endPoint = startPoint + viewTS*viewTSLength;
                float4 parallax = tex2D(ParallaxMap,saturate( endPoint.xy));
                ParallaxUV= endPoint.xy;
                return parallax;
            }
            float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			
			float3 HsvToRgb( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}

            //VFace 是背面的关键字
            //用法：bool backFace:VFace
            float4 frag(V2FData input,float backFace:VFace) : SV_Target
            {
                float3 T = normalize(input.tangent);
                float3 N = normalize(input.normal);
                //float3 B = normalize( cross(N,T));
                float3 B = normalize(input.bitangent);
                float3 L = normalize(UnityWorldSpaceLightDir(input.posWS.xyz));
                float3 V = normalize(UnityWorldSpaceViewDir(input.posWS.xyz));
                float2 uv = input.uv;


            	// start on back
                
				
                float3 ViewDir = UnityWorldSpaceViewDir(input.posWS);
				float simplePerlin3D1 = snoise( ( input.posWS + ( ViewDir * 0.1 ) )*10.0 );
				simplePerlin3D1 = simplePerlin3D1*0.5 + 0.5;
				float2 uv_StartRainbowColor = input.uv.xy * _StartRainbowColor_ST.xy + _StartRainbowColor_ST.zw;
				float3 hsvTorgb13 = HsvToRgb( float3(tex2D( _StartRainbowColor, uv_StartRainbowColor ).r,_HSVSaturation,_HSVValue) );
				
				
				float4 StarColor = float4( ( ( pow( simplePerlin3D1 , _HSVPow.x ) * _HSVPow.y ) * hsvTorgb13 ) , 0.0 );
				StarColor = min(StarColor,_StarMin);
				

                	
                
                //非0为真
                
                //背面层
                if(backFace<0)
                {
                    float2 revertUV = float2(1-uv.x,uv.y);
                    float2 backMapUV = revertUV*_BackgroundMap_ST.xy + _BackgroundMap_ST.zw;
                    float4 backMap = tex2D(_BackgroundMap,backMapUV)*_BackgroundTint;
                    float4 back = backMap;
                    
                    if(_EnableColorfulBackground)
                    {
                        //反面的法线翻转一下
                        N = -N;
                        float3 H = normalize(V + L  + V + T*0.3);
                        // float3 H = normalize( V + L );
                        float nh = saturate( dot(N,H) );

                        float4 rainbow2 = HsvToRgb(float3(uv.y*5.5 + nh*3,1,1)).xyzz;

                        float4 rainbow = tex2D(_RainbowMap,uv*_RainbowMap_ST.xy+_RainbowMap_ST.zw)*2 + rainbow2;
                        
                        float lum = Luminance(backMap);
                        float mask = abs(sin(nh*10*3.14));
                        
                        back = backMap+(1-backMap)*StarColor + mask * pow(nh,300) *128*rainbow*lum ;

                    	


                    	
                    }
                    return back;
                }
             
                
                //TBN:将世界空间转到切线空间
                float3x3 TBN = float3x3(T,B,N);
                
                //将V转到深度空间
                float3 viewTS = mul(TBN,V);

                //计算图片1 的深度坐标
                float4 p1 = ParallaxMapping(_ParallaxMap, _Depth,uv,_ParallaxMap_ST,viewTS) * _ParallaxMapTint;
                //return _Depth;
                
                //计算图片2 的深度坐标
                float2 parallaxUVP2;
                float4 p2 = ParallaxMappingOutUV(_ParallaxMap2, _Depth2,uv,_ParallaxMap2_ST,viewTS,parallaxUVP2) ;

                //p2流光
                float noise = tex2D(_P2NoiseMap,parallaxUVP2 + float2(0,_Time.x*0.8) );
                float noise2 = tex2D(_P2NoiseMap,parallaxUVP2.yx - float2(_Time.x,_Time.x*0.9) );
                
                noise = pow(noise*noise2,_P2NoiseMapVec.x) * _P2NoiseMapVec.y;
                //可优化
                p2 = p2 *(1+ noise * ( Luminance(p2) > (2.0 / 256.0) ) ) * _ParallaxMap2Tint;

                float2 parallaxUVP3;
                float4 p3 = ParallaxMappingOutUV(_ParallaxMap3, _Depth3,uv,_ParallaxMap3_ST,viewTS,parallaxUVP3) ;

                //p2流光
                float noise3 = tex2D(_P3NoiseMap,parallaxUVP3 + float2(0,_Time.x*0.8) );
                float noise4 = tex2D(_P3NoiseMap,parallaxUVP3.yx - float2(_Time.x,_Time.x*0.9) );


                float2 parallaxUVP4;
                float4 p4 = ParallaxMappingOutUV(_ParallaxMap4, _Depth4,uv,_ParallaxMap4_ST,viewTS,parallaxUVP4);
                float noise5 = tex2D(_P2NoiseMap,parallaxUVP2 + float2(0,_Time.x*0.8) );
                float noise6 = tex2D(_P2NoiseMap,parallaxUVP2.yx - float2(_Time.x,_Time.x*0.9) );
                
                noise5 = pow(noise5*noise6,_P2NoiseMapVec.x) * _P2NoiseMapVec.y;
                float3 H = normalize( V + L );
                float NH = saturate(dot(N,H));
                float4 rainbow = HsvToRgb(float3(uv.y*3 + NH*5,1,1)).xyzz;
                
                rainbow += tex2D(_RainbowMap,uv*_RainbowMap_ST.xy+_RainbowMap_ST.zw)*2;
                float mask = abs(sin(NH)*10*3.14);
                p4 = p4 *(1+ noise5 * ( Luminance(p4) > (1.0 / 256.0) ) ) * _ParallaxMap4Tint*rainbow;
                //return p4;
                //计算图片2 的深度坐标
                float2 parallaxUVP5;
                float4 p5 = ParallaxMappingOutUV(_ParallaxMap5, _Depth5,uv,_ParallaxMap5_ST,viewTS,parallaxUVP5) ;


                
             
                //p2流光
                float noise7 = tex2D(_P2NoiseMap,parallaxUVP5 + float2(0,_Time.x*0.8) );
                float noise8 = tex2D(_P2NoiseMap,parallaxUVP5.yx - float2(_Time.x,_Time.x*0.9) );
                
                noise7 = pow(noise7*noise8,_P2NoiseMapVec.x) * _P5NoiseMapVec.y;
                //可优化
                p5 = p5 *(1+ noise7 * ( Luminance(p5) > (2.0 / 256.0) ) ) * _ParallaxMap2Tint;


                
                //采样画框,不需要计算出视差
                float4 frame = tex2D(_Frame,uv*_Frame_ST.xy+_Frame_ST.zw);
                
                //画框流光
                frame = frame + ( frame)* pow(sin( uv.y + _Time.y*0.5),4) *0.5;
                
                //通过Alpah蒙版进行融合,图片1 在 图片2的上面
                float4 color = lerp(p1,p5,p5.a);
                color = lerp(p3,color,color.a);
                color = lerp(p4,color,color.a);
                float4 color1 = lerp(p2,p4,p4.a);
                color = lerp(color1,color,color.a);


                
                //通过Alpah蒙版进行融合,相框在最碗面
                float alpha = Luminance(frame.rgb);
                
                color = lerp(color,frame*_FrameTint,alpha);
                // color = color + frame*10;
                
                return color;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}