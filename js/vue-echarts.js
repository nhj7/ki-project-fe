var VueDemi=function(e,t,y){if(e.install)return e;if(!t)return console.error("[vue-demi] no Vue instance found, please be sure to import `vue` before `vue-demi`."),e;if(t.version.slice(0,4)==="2.7."){let a=function(u,v){var f,P={},b={config:t.config,use:t.use.bind(t),mixin:t.mixin.bind(t),component:t.component.bind(t),provide:function(p,O){return P[p]=O,this},directive:function(p,O){return O?(t.directive(p,O),b):t.directive(p)},mount:function(p,O){return f||(f=new t(Object.assign({propsData:v},u,{provide:Object.assign(P,u.provide)})),f.$mount(p,O),f)},unmount:function(){f&&(f.$destroy(),f=void 0)}};return b};var B=a;for(var d in t)e[d]=t[d];e.isVue2=!0,e.isVue3=!1,e.install=function(){},e.Vue=t,e.Vue2=t,e.version=t.version,e.warn=t.util.warn,e.createApp=a}else if(t.version.slice(0,2)==="2.")if(y){for(var d in y)e[d]=y[d];e.isVue2=!0,e.isVue3=!1,e.install=function(){},e.Vue=t,e.Vue2=t,e.version=t.version}else console.error("[vue-demi] no VueCompositionAPI instance found, please be sure to import `@vue/composition-api` before `vue-demi`.");else if(t.version.slice(0,2)==="3."){for(var d in t)e[d]=t[d];e.isVue2=!1,e.isVue3=!0,e.install=function(){},e.Vue=t,e.Vue2=void 0,e.version=t.version,e.set=function(a,u,v){return Array.isArray(a)?(a.length=Math.max(a.length,u),a.splice(u,1,v),v):(a[u]=v,v)},e.del=function(a,u){if(Array.isArray(a)){a.splice(u,1);return}delete a[u]}}else console.error("[vue-demi] Vue version "+t.version+" is unsupported.");return e}(this.VueDemi=this.VueDemi||(typeof VueDemi<"u"?VueDemi:{}),this.Vue||(typeof Vue<"u"?Vue:void 0),this.VueCompositionAPI||(typeof VueCompositionAPI<"u"?VueCompositionAPI:void 0));(function(e,t){typeof exports=="object"&&typeof module<"u"?module.exports=t(require("echarts"),require("vue-demi"),require("echarts/core")):typeof define=="function"&&define.amd?define(["echarts","vue-demi","echarts/core"],t):(e=typeof globalThis<"u"?globalThis:e||self,e.VueECharts=t(e.echarts,e.VueDemi,e.echarts))})(this,function(e,t,y){"use strict";const d=["getWidth","getHeight","getDom","getOption","resize","dispatchAction","convertToPixel","convertFromPixel","containPixel","getDataURL","getConnectedDataURL","appendData","clear","isDisposed","dispose"];function B(n){function c(o){return(...l)=>{if(!n.value)throw new Error("ECharts is not initialized yet.");return n.value[o].apply(n.value,l)}}function r(){const o=Object.create(null);return d.forEach(l=>{o[l]=c(l)}),o}return r()}function a(n,c,r){t.watch([r,n,c],([o,l,h],J,K)=>{let g=null;if(o&&l&&h){const{offsetWidth:M,offsetHeight:S}=o,Y=h===!0?{}:h,{throttle:x=100,onResize:L}=Y;let w=!1;const j=()=>{l.resize(),L?.()},$=x?y.throttle(j,x):j;g=new ResizeObserver(()=>{!w&&(w=!0,o.offsetWidth===M&&o.offsetHeight===S)||$()}),g.observe(o)}K(()=>{g&&(g.disconnect(),g=null)})})}const u={autoresize:[Boolean,Object]},v=/^on[^a-z]/,f=n=>v.test(n);function P(n){const c={};for(const r in n)f(r)||(c[r]=n[r]);return c}function b(n,c){const r=t.isRef(n)?t.unref(n):n;return r&&typeof r=="object"&&"value"in r?r.value||c:r||c}const p="ecLoadingOptions";function O(n,c,r){const o=t.inject(p,{}),l=t.computed(()=>({...b(o,{}),...r?.value}));t.watchEffect(()=>{const h=n.value;h&&(c.value?h.showLoading(l.value):h.hideLoading())})}const X={loading:Boolean,loadingOptions:Object};let A=null;const U="x-vue-echarts";function V(){if(A!=null)return A;if(typeof HTMLElement>"u"||typeof customElements>"u")return A=!1;try{new Function("tag","class EChartsElement extends HTMLElement{__dispose=null;disconnectedCallback(){this.__dispose&&(this.__dispose(),this.__dispose=null)}}customElements.get(tag)==null&&customElements.define(tag,EChartsElement);")(U)}catch{return A=!1}return A=!0}document.head.appendChild(document.createElement("style")).textContent=`x-vue-echarts{display:block;width:100%;height:100%;min-width:0}
`;const D=V();t.Vue2&&t.Vue2.config.ignoredElements.push(U);const q="ecTheme",G="ecInitOptions",W="ecUpdateOptions",F=/(^&?~?!?)native:/;var Z=t.defineComponent({name:"echarts",props:{option:Object,theme:{type:[Object,String]},initOptions:Object,updateOptions:Object,group:String,manualUpdate:Boolean,...u,...X},emits:{},inheritAttrs:!1,setup(n,{attrs:c}){const r=t.shallowRef(),o=t.shallowRef(),l=t.shallowRef(),h=t.inject(q,null),J=t.inject(G,null),K=t.inject(W,null),{autoresize:g,manualUpdate:M,loading:S,loadingOptions:Y}=t.toRefs(n),x=t.computed(()=>l.value||n.option||null),L=t.computed(()=>n.theme||b(h,{})),w=t.computed(()=>n.initOptions||b(J,{})),j=t.computed(()=>n.updateOptions||b(K,{})),$=t.computed(()=>P(c)),H={},z=t.getCurrentInstance().proxy.$listeners,C={};z?Object.keys(z).forEach(i=>{F.test(i)?H[i.replace(F,"$1")]=z[i]:C[i]=z[i]}):Object.keys(c).filter(i=>f(i)).forEach(i=>{let s=i.charAt(2).toLowerCase()+i.slice(3);if(s.indexOf("native:")===0){const T=`on${s.charAt(7).toUpperCase()}${s.slice(8)}`;H[T]=c[i];return}s.substring(s.length-4)==="Once"&&(s=`~${s.substring(0,s.length-4)}`),C[s]=c[i]});function N(i){if(!r.value)return;const s=o.value=y.init(r.value,L.value,w.value);n.group&&(s.group=n.group),Object.keys(C).forEach(I=>{let _=C[I];if(!_)return;let E=I.toLowerCase();E.charAt(0)==="~"&&(E=E.substring(1),_.__once__=!0);let k=s;if(E.indexOf("zr:")===0&&(k=s.getZr(),E=E.substring(3)),_.__once__){delete _.__once__;const st=_;_=(...rt)=>{st(...rt),k.off(E,_)}}k.on(E,_)});function T(){s&&!s.isDisposed()&&s.resize()}function Q(){const I=i||x.value;I&&s.setOption(I,j.value)}g.value?t.nextTick(()=>{T(),Q()}):Q()}function nt(i,s){n.manualUpdate&&(l.value=i),o.value?o.value.setOption(i,s||{}):N(i)}function m(){o.value&&(o.value.dispose(),o.value=void 0)}let R=null;t.watch(M,i=>{typeof R=="function"&&(R(),R=null),i||(R=t.watch(()=>n.option,(s,T)=>{s&&(o.value?o.value.setOption(s,{notMerge:s!==T,...j.value}):N())},{deep:!0}))},{immediate:!0}),t.watch([L,w],()=>{m(),N()},{deep:!0}),t.watchEffect(()=>{n.group&&o.value&&(o.value.group=n.group)});const ot=B(o);return O(o,S,Y),a(o,g,r),t.onMounted(()=>{N()}),t.onBeforeUnmount(()=>{D&&r.value?r.value.__dispose=m:m()}),{chart:o,root:r,setOption:nt,nonEventAttrs:$,nativeListeners:H,...ot}},render(){const n=t.Vue2?{attrs:this.nonEventAttrs,on:this.nativeListeners}:{...this.nonEventAttrs,...this.nativeListeners};return n.ref="root",n.class=n.class?["echarts"].concat(n.class):"echarts",t.h(U,n)}}),tt=Object.freeze({__proto__:null,INIT_OPTIONS_KEY:G,LOADING_OPTIONS_KEY:p,THEME_KEY:q,UPDATE_OPTIONS_KEY:W,default:Z}),et={...Z,...tt};return et});
//# sourceMappingURL=index.min.js.map