(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["9a0f270c"],{"097d":function(t,a,e){"use strict";var l=e("5ca1"),n=e("8378"),i=e("7726"),s=e("ebd6"),r=e("bcaa");l(l.P+l.R,"Promise",{finally:function(t){var a=s(this,n.Promise||i.Promise),e="function"==typeof t;return this.then(e?function(e){return r(a,t()).then(function(){return e})}:t,e?function(e){return r(a,t()).then(function(){throw e})}:t)}})},"22d6":function(t,a,e){"use strict";e.r(a);var l=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("q-page",{attrs:{padding:""}},[e("q-card",[e("q-card-section",[e("q-input",{attrs:{label:"Source path",error:t.source_error,clearable:""},model:{value:t.source_path,callback:function(a){t.source_path=a},expression:"source_path"}}),e("q-input",{attrs:{label:"Artist",clearable:""},model:{value:t.artist,callback:function(a){t.artist=a},expression:"artist"}}),e("q-input",{attrs:{label:"Album",clearable:""},model:{value:t.album,callback:function(a){t.album=a},expression:"album"}}),e("q-input",{attrs:{label:"Destination path",clearable:""},model:{value:t.dst_path,callback:function(a){t.dst_path=a},expression:"dst_path"}}),e("br"),e("q-toggle",{staticClass:"q-mt-md",attrs:{label:"Collect MusicBrainz info"},model:{value:t.collect_mb_info,callback:function(a){t.collect_mb_info=a},expression:"collect_mb_info"}}),e("br"),e("q-toggle",{staticClass:"q-mt-md",attrs:{label:"Copy files"},model:{value:t.copy_files,callback:function(a){t.copy_files=a},expression:"copy_files"}})],1),e("q-separator"),e("q-card-actions",{attrs:{align:"around"}},[e("q-btn",{attrs:{disable:""===t.source_path,loading:t.collecting_info,label:"Collect info",color:"secondary"},on:{click:t.collect_info}}),e("q-btn",{attrs:{disable:0===t.source_infos.length,loading:t.organizing,label:"Organize",color:"primary"},on:{click:t.organize}}),e("q-btn",{attrs:{label:"Reset",color:"warning"},on:{click:t.reset}})],1)],1),t._l(t.source_infos,function(a,l){return[e("q-card",{key:"source-"+l,staticClass:"q-mt-md",attrs:{color:"light"}},[e("q-card-section",[t._v("\n        "+t._s(l+1+". "+(a.file||""))+"\n\n        "),a.mb_release?[e("span",{attrs:{slot:"subtitle"},slot:"subtitle"},[e("a",{staticClass:"q-ml-sm",attrs:{href:a.mb_release_url,target:"_blank"}},[t._v("\n              "+t._s(a.mb_release)+"\n              "),e("q-icon",{attrs:{name:"fas fa-external-link-alt",size:"14px"}})],1)])]:t._e()],2),t._l(a.albums,function(l,n){return[e("album-form",{key:"album-"+n,attrs:{album:l,images:a.images},on:{"split-album":function(e){return t.split_album(l,a)}}})]})],2)]})],2)},n=[],i=(e("f751"),e("551c"),e("06db"),e("097d"),e("4e1d")),s={name:"AlbumOrganizerPage",components:{AlbumForm:i["a"]},data:function(){return{source_path:"",source_error:null,source_infos:[],artist:null,album:null,dst_path:"",collect_mb_info:!1,copy_files:!1,collecting_info:!1,organizing:!1}},methods:{collect_info:function(){var t=this;this.organizing||(this.collecting_info=!0,this.$api.query("music_info",{path:this.source_path,artist:this.artist,album:this.album,collect_mb_info:this.collect_mb_info}).then(function(a){a.forEach(function(t){t.albums.forEach(function(t){t.tracks.forEach(function(t){t.checked=!1})})}),t.source_infos=a}).finally(function(){t.collecting_info=!1}))},split_album:function(t,a){var e=t.tracks,l=[];t.tracks=[],e.forEach(function(a){a.checked?(a.checked=!1,a.number=l.length+1,l.push(a)):t.tracks.push(a)});var n=Object.assign({},t,{tracks:l});a.albums.push(n)},organize:function(){var t=this;this.collecting_info||(this.organizing=!0,this.$api.query("organize_files",{path:this.source_path,source_infos:this.source_infos,dst_path:this.dst_path,copy_files:this.copy_files}).finally(function(){t.organizing=!1}))},reset:function(){this.source_infos=[]}}},r=s,o=e("2877"),c=Object(o["a"])(r,l,n,!1,null,null,null);a["default"]=c.exports},"4e1d":function(t,a,e){"use strict";var l=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("q-card",{staticClass:"q-mb-sm",attrs:{color:"white","text-color":"black"}},[e("q-card-section",[e("q-input",{attrs:{label:"Album Artist"},model:{value:t.album.album_artist,callback:function(a){t.$set(t.album,"album_artist",a)},expression:"album.album_artist"}}),t.album.mb_artists?[e("q-btn",{attrs:{label:t.album.mb_artists,icon:"fas fa-check",color:"accent",size:"form","no-caps":"",flat:""},on:{click:t.set_mb_artists}})]:t._e(),e("q-select",{attrs:{options:t.artist_options,"input-debounce":"1000","use-input":"","hide-selected":"","fill-input":""},on:{filter:t.search_artist},scopedSlots:t._u([{key:"append",fn:function(){return[null!==t.album.artist?e("q-icon",{staticClass:"cursor-pointer",attrs:{name:"clear"},on:{click:function(a){return a.stopPropagation(),t.clear_artist(a)}}}):t._e()]},proxy:!0},{key:"no-option",fn:function(){return[e("q-item",[e("q-item-section",{staticClass:"text-grey"},[t._v("\n            No result\n          ")])],1)]},proxy:!0}]),model:{value:t.album.artist,callback:function(a){t.$set(t.album,"artist",a)},expression:"album.artist"}}),t.album.mb_composer?[e("q-btn",{attrs:{label:t.album.mb_composer,icon:"fas fa-check",color:"accent",size:"form","no-caps":"",flat:""},on:{click:t.set_mb_composer}}),e("a",{staticClass:"q-ml-sm",attrs:{href:t.album.mb_composer_url,target:"_blank"}},[e("q-icon",{attrs:{name:"fas fa-external-link-alt"}})],1)]:t._e(),e("q-input",{attrs:{label:"Title"},model:{value:t.album.title,callback:function(a){t.$set(t.album,"title",a)},expression:"album.title"}}),t.album.mb_title?[e("q-btn",{attrs:{label:t.album.mb_title,icon:"fas fa-check",color:"accent",size:"form","no-caps":"",flat:""},on:{click:t.set_mb_title}}),e("a",{staticClass:"q-ml-sm",attrs:{href:t.album.mb_url,target:"_blank"}},[e("q-icon",{attrs:{name:"fas fa-external-link-alt"}})],1)]:t._e(),e("q-input",{attrs:{label:"Genre"},model:{value:t.album.genre,callback:function(a){t.$set(t.album,"genre",a)},expression:"album.genre"}}),e("q-input",{attrs:{label:"Year"},model:{value:t.album.year,callback:function(a){t.$set(t.album,"year",a)},expression:"album.year"}}),t.album.mb_date?[e("q-btn",{attrs:{label:t.album.mb_date,icon:"fas fa-check",color:"accent",size:"form","no-caps":"",flat:""},on:{click:t.set_mb_year}})]:t._e(),e("q-select",{attrs:{options:t.cover_options,"float-label":"Cover"},model:{value:t.album.cover,callback:function(a){t.$set(t.album,"cover",a)},expression:"album.cover"}})],2),e("q-expansion-item",{attrs:{label:"Tracks"}},[e("q-list",{attrs:{separator:""}},[t._l(t.album.tracks,function(a,l){return[e("q-item",{key:"track-"+l},[e("q-item-section",[e("q-checkbox",{model:{value:a.checked,callback:function(e){t.$set(a,"checked",e)},expression:"track.checked"}})],1),e("q-item-label",[e("q-item-label",{staticClass:"row gutter-xs",attrs:{header:""}},[e("q-input",{staticClass:"col-1",attrs:{type:"number",min:"1"},model:{value:a.number,callback:function(e){t.$set(a,"number",e)},expression:"track.number"}}),e("q-input",{staticClass:"col",model:{value:a.title,callback:function(e){t.$set(a,"title",e)},expression:"track.title"}})],1),a.mb_title?[e("q-item-label",{attrs:{caption:""}},[e("q-btn",{attrs:{label:a.mb_title,icon:"fas fa-check",color:"accent",size:"form","no-caps":"",flat:""},on:{click:function(e){return t.set_mb_track_title(a)}}}),e("a",{staticClass:"q-ml-sm",attrs:{href:a.mb_url,target:"_blank"}},[e("q-icon",{attrs:{name:"fas fa-external-link-alt"}})],1)],1)]:t._e()],2),e("q-item-section",{attrs:{side:"",right:""}},[e("q-btn",{attrs:{flat:"",color:"negative",icon:"fas fa-minus"},on:{click:function(e){return t.remove_track(a)}}})],1)],1)]})],2)],1),e("q-separator"),e("q-card-actions",{attrs:{align:"around"}},[e("q-btn",{attrs:{loading:t.searching_work,label:"Find work info",color:"info",flat:""},on:{click:t.find_work_info}}),e("q-btn",{attrs:{label:"Split",color:"secondary",flat:""},on:{click:function(a){return t.$emit("split-album")}}})],1)],1)},n=[],i=(e("28a5"),e("7f7f"),e("551c"),e("06db"),e("097d"),{name:"AlbumForm",props:{album:{type:Object,required:!0},images:{type:Array,required:!1}},data:function(){return{searching_work:!1,searching_artist:!1,artist_options:[],artist_mbid:null}},computed:{cover_options:function(){return this.images.map(function(t){return{label:t,value:t}})}},methods:{find_work_info:function(){var t=this;this.searching_work=!0,this.$api.query("find_work_info",{title:this.album.title,artist:this.album.artist,artist_mbid:this.artist_mbid}).then(function(a){console.log(t.album),t.album.mb_composer=a.composer,t.album.mb_composer_url=a.composer_url,t.album.mb_title=a.title,t.album.mb_url=a.url,t.album.mb_date=a.date,a.parts.forEach(function(a){t.album.tracks.forEach(function(t){t.number===a.number&&(t.mb_title=a.title,t.mb_url=a.url)})})}).finally(function(){t.searching_work=!1})},search_artist:function(t,a,e){var l=this;val.length<2?e():this.$api.query("search_artist",{name:t}).then(function(t){a(function(){l.artist_options=t.map(function(t){return{value:t.sort_name,label:t.name,sublabel:"[".concat(t.life_span.begin," - ").concat(t.life_span.end,"]. Country: ").concat(t.country),stamp:t.score,mbid:t.id}})})}).catch(function(){return e()})},select_artist:function(t){this.artist_mbid=t.mbid,this.album.artist=t.label,this.album.mb_composer=t.label,this.album.mb_composer_url="https://musicbrainz.org/artist/".concat(t.mbid)},clear_artist:function(){this.artist_mbid=null,this.album.mb_composer=null,this.album.mb_composer_url=null},set_mb_artists:function(){this.album.album_artist=this.album.mb_artists},set_mb_composer:function(){this.album.artist=this.album.mb_composer},set_mb_title:function(){this.album.title=this.album.mb_title},set_mb_year:function(){this.album.year=this.album.mb_date.split("-")[0]},set_mb_track_title:function(t){t.title=t.mb_title},remove_track:function(t){}}}),s=i,r=e("2877"),o=Object(r["a"])(s,l,n,!1,null,null,null);a["a"]=o.exports}}]);