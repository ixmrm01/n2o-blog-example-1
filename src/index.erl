-module(index).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("records.hrl").

posts() ->
  [
    #panel{body=[
      #h2{body = #link{body = P#post.title, url = "/app/post.htm?id=" ++ nitro:to_list(P#post.id)}},
      #p{body = P#post.text}
    ]} || P <- posts:get()
  ].

event(init) ->
  nitro:update(posts, posts()).
